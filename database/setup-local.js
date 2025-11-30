const sql = require('mssql');
const fs = require('fs');
const path = require('path');
require('dotenv').config();

// Local database configuration
const config = {
  server: process.env.DB_SERVER || 'localhost',
  port: parseInt(process.env.DB_PORT || '1433'),
  database: 'master', // Connect to master first to create database if needed
  user: process.env.DB_USER || 'sa',
  password: process.env.DB_PASSWORD || 'FactoryUtility@123',
  options: {
    encrypt: false, // Local connections don't need encryption
    trustServerCertificate: true,
    enableArithAbort: true,
    connectionTimeout: 30000, // 30 seconds
    requestTimeout: 30000
  }
};

const dbName = process.env.DB_NAME || 'FactoryUtility';

async function setupDatabase() {
  let pool;
  
  try {
    console.log('🔌 Connecting to local SQL Server...');
    console.log(`   Server: ${config.server}:${config.port}`);
    console.log(`   User: ${config.user}`);
    console.log('');
    
    pool = await sql.connect(config);
    console.log('✅ Connected to SQL Server');

    // Check if database exists, create if not
    console.log(`\n📊 Checking if database '${dbName}' exists...`);
    const dbCheck = await pool.request().query(`
      SELECT name FROM sys.databases WHERE name = '${dbName}'
    `);

    if (dbCheck.recordset.length === 0) {
      console.log(`📦 Creating database '${dbName}'...`);
      await pool.request().query(`
        CREATE DATABASE [${dbName}]
      `);
      console.log(`✅ Database '${dbName}' created successfully`);
    } else {
      console.log(`✅ Database '${dbName}' already exists`);
    }

    // Close connection to master
    await pool.close();

    // Connect to the new database
    config.database = dbName;
    console.log(`\n🔌 Connecting to database '${dbName}'...`);
    pool = await sql.connect(config);
    console.log(`✅ Connected to database '${dbName}'`);

    // Read and execute schema SQL
    console.log('\n📋 Creating database tables...');
    const schemaPath = path.join(__dirname, 'schema.sql');
    
    if (fs.existsSync(schemaPath)) {
      const schemaSQL = fs.readFileSync(schemaPath, 'utf8');
      // Split by GO statements - handle both \nGO and standalone GO
      const statements = schemaSQL
        .split(/\n\s*GO\s*\n/gi)
        .concat(schemaSQL.split(/^\s*GO\s*$/gmi))
        .filter(s => s && s.trim() && !s.match(/^\s*GO\s*$/i));
      
      // Remove duplicates
      const uniqueStatements = [...new Set(statements)];
      
      for (const statement of uniqueStatements) {
        if (statement.trim() && !statement.match(/^\s*GO\s*$/i)) {
          try {
            await pool.request().query(statement);
          } catch (error) {
            // Ignore "already exists" errors
            if (!error.message.includes('already exists') && 
                !error.message.includes('There is already an object') &&
                !error.message.includes('duplicate key')) {
              console.warn('⚠️  Warning:', error.message.substring(0, 100));
            }
          }
        }
      }
      console.log('✅ Database schema created successfully');
    } else {
      console.warn('⚠️  schema.sql not found. Skipping table creation.');
    }

    // Create default users
    console.log('\n👤 Creating default users...');
    const usersPath = path.join(__dirname, 'default_user.sql');
    
    if (fs.existsSync(usersPath)) {
      const usersSQL = fs.readFileSync(usersPath, 'utf8');
      const statements = usersSQL
        .split(/\n\s*GO\s*\n/gi)
        .concat(usersSQL.split(/^\s*GO\s*$/gmi))
        .filter(s => s && s.trim() && !s.match(/^\s*GO\s*$/i));
      
      const uniqueStatements = [...new Set(statements)];
      
      for (const statement of uniqueStatements) {
        if (statement.trim() && !statement.match(/^\s*GO\s*$/i)) {
          try {
            await pool.request().query(statement);
          } catch (error) {
            if (!error.message.includes('already exists')) {
              console.warn('⚠️  Warning:', error.message.substring(0, 100));
            }
          }
        }
      }
      console.log('✅ Default users created successfully');
    } else {
      console.warn('⚠️  default_user.sql not found. Skipping user creation.');
    }

    // Verify setup
    console.log('\n🔍 Verifying setup...');
    const tableCheck = await pool.request().query(`
      SELECT COUNT(*) as TableCount 
      FROM INFORMATION_SCHEMA.TABLES 
      WHERE TABLE_TYPE = 'BASE TABLE'
    `);
    console.log(`✅ Found ${tableCheck.recordset[0].TableCount} tables in database`);

    const userCheck = await pool.request().query(`
      SELECT COUNT(*) as UserCount FROM LoginDetails
    `);
    console.log(`✅ Found ${userCheck.recordset[0].UserCount} users in LoginDetails table`);

    console.log('\n========================================');
    console.log('✅ Database setup completed successfully!');
    console.log('========================================\n');

    console.log('Default Admin Credentials:');
    console.log('  Username: admin');
    console.log('  Password: Admin@123');
    console.log('\n📝 Local Database Configuration:');
    console.log(`  Server: ${config.server}:${config.port}`);
    console.log(`  Database: ${dbName}`);
    console.log(`  User: ${config.user}`);
    console.log('\n⚠️  IMPORTANT: Change default passwords in production!\n');

  } catch (error) {
    console.error('\n❌ Database setup error:', error.message);
    console.error('\n💡 Troubleshooting:');
    console.error('   1. Make sure SQL Server is running');
    console.error('   2. Check Docker container is up: docker ps');
    console.error('   3. Verify credentials in .env file');
    console.error('   4. Check connection string matches your setup');
    
    if (error.code === 'ETIMEOUT' || error.code === 'ECONNREFUSED') {
      console.error('\n💡 Local SQL Server not running?');
      console.error('   Start Docker container: docker-compose up -d');
      console.error('   Or see: database/LOCAL_SETUP.md');
    }
    
    process.exit(1);
  } finally {
    if (pool) {
      await pool.close();
    }
  }
}

// Run setup
if (require.main === module) {
  setupDatabase()
    .then(() => {
      console.log('Setup completed. Exiting...');
      process.exit(0);
    })
    .catch((error) => {
      console.error('Fatal error:', error);
      process.exit(1);
    });
}

module.exports = { setupDatabase };

