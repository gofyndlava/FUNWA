const sql = require('mssql');
const fs = require('fs');
const path = require('path');
require('dotenv').config();

// Database configuration
const config = {
  server: process.env.DB_SERVER || '20.198.94.108',
  port: parseInt(process.env.DB_PORT || '49172'),
  database: 'master', // Connect to master first to create database if needed
  user: process.env.DB_USER || 'wtsqluser',
  password: process.env.DB_PASSWORD || 'Password@1',
  options: {
    encrypt: false,
    trustServerCertificate: true,
    enableArithAbort: true
  }
};

const dbName = process.env.DB_NAME || 'FactoryUtility';

async function setupDatabase() {
  let pool;
  
  try {
    console.log('🔌 Connecting to SQL Server...');
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
      // Split by GO statements
      const statements = schemaSQL.split(/^\s*GO\s*$/gmi).filter(s => s.trim());
      
      for (const statement of statements) {
        if (statement.trim()) {
          try {
            await pool.request().query(statement);
          } catch (error) {
            if (!error.message.includes('already exists')) {
              console.error('Error executing statement:', error.message);
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
      const statements = usersSQL.split(/^\s*GO\s*$/gmi).filter(s => s.trim());
      
      for (const statement of statements) {
        if (statement.trim()) {
          try {
            await pool.request().query(statement);
          } catch (error) {
            console.error('Error creating user:', error.message);
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
    console.log('\n⚠️  IMPORTANT: Change default passwords in production!\n');

  } catch (error) {
    console.error('❌ Database setup error:', error);
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

