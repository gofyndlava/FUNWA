const { Pool } = require('pg');
const fs = require('fs');
const path = require('path');
require('dotenv').config();

const dbName = process.env.DB_NAME || 'FactoryUtility';

async function setupDatabase() {
  let pool;
  let adminPool = null;
  
  try {
    console.log('🔌 Connecting to PostgreSQL...');
    console.log(`   Host: ${process.env.DB_SERVER || 'localhost'}:${process.env.DB_PORT || '5432'}`);
    console.log(`   User: ${process.env.DB_USER || 'postgres'}`);
    console.log('');
    
    const baseConfig = {
      host: process.env.DB_SERVER || 'localhost',
      port: parseInt(process.env.DB_PORT || '5432'),
      user: process.env.DB_USER || 'postgres',
      password: process.env.DB_PASSWORD || 'FactoryUtility@123',
    };
    
    // Try to connect to FactoryUtility first (might already exist from docker-compose)
    try {
      pool = new Pool({ ...baseConfig, database: dbName });
      await pool.query('SELECT NOW()');
      console.log(`✅ Connected directly to database '${dbName}'`);
    } catch (err) {
      // If direct connection fails, connect to template1 to check/create database
      console.log(`   Direct connection failed, trying template1...`);
      adminPool = new Pool({ ...baseConfig, database: 'template1' });
      await adminPool.query('SELECT NOW()');
      console.log('✅ Connected to PostgreSQL');
      
      // Check if database exists
      console.log(`\n📊 Checking if database '${dbName}' exists...`);
      const dbCheck = await adminPool.query(`
        SELECT datname FROM pg_database WHERE datname = $1
      `, [dbName]);

      if (dbCheck.rows.length === 0) {
        console.log(`📦 Creating database '${dbName}'...`);
        // Terminate any existing connections to the database
        await adminPool.query(`
          SELECT pg_terminate_backend(pg_stat_activity.pid)
          FROM pg_stat_activity
          WHERE pg_stat_activity.datname = $1
            AND pid <> pg_backend_pid()
        `, [dbName]).catch(() => {}); // Ignore errors if database doesn't exist
        
        await adminPool.query(`CREATE DATABASE "${dbName}"`);
        console.log(`✅ Database '${dbName}' created successfully`);
      } else {
        console.log(`✅ Database '${dbName}' already exists`);
      }

      // Close admin connection
      await adminPool.end();
      adminPool = null;

      // Connect to the FactoryUtility database
      console.log(`\n🔌 Connecting to database '${dbName}'...`);
      pool = new Pool({ ...baseConfig, database: dbName });
      await pool.query('SELECT NOW()');
      console.log(`✅ Connected to database '${dbName}'`);
    }

    // Read and execute schema SQL
    console.log('\n📋 Creating database tables...');
    const schemaPath = path.join(__dirname, 'schema-postgres.sql');
    
    if (fs.existsSync(schemaPath)) {
      const schemaSQL = fs.readFileSync(schemaPath, 'utf8');
      // Execute the entire schema file
      await pool.query(schemaSQL);
      console.log('✅ Database schema created successfully');
    } else {
      console.warn('⚠️  schema-postgres.sql not found. Skipping table creation.');
    }

    // Create default users
    console.log('\n👤 Creating default users...');
    const usersPath = path.join(__dirname, 'default_user-postgres.sql');
    
    if (fs.existsSync(usersPath)) {
      const usersSQL = fs.readFileSync(usersPath, 'utf8');
      await pool.query(usersSQL);
      console.log('✅ Default users created successfully');
    } else {
      console.warn('⚠️  default_user-postgres.sql not found. Skipping user creation.');
    }

    // Verify setup
    console.log('\n🔍 Verifying setup...');
    const tableCheck = await pool.query(`
      SELECT COUNT(*) as "TableCount" 
      FROM information_schema.tables 
      WHERE table_schema = 'public'
    `);
    console.log(`✅ Found ${tableCheck.rows[0].TableCount} tables in database`);

    const userCheck = await pool.query(`
      SELECT COUNT(*) as "UserCount" FROM "LoginDetails"
    `);
    console.log(`✅ Found ${userCheck.rows[0].UserCount} users in LoginDetails table`);

    console.log('\n========================================');
    console.log('✅ Database setup completed successfully!');
    console.log('========================================\n');

    console.log('Default Admin Credentials:');
    console.log('  Username: admin');
    console.log('  Password: Admin@123');
    console.log('\n📝 PostgreSQL Configuration:');
    console.log(`  Host: ${baseConfig.host}:${baseConfig.port}`);
    console.log(`  Database: ${dbName}`);
    console.log(`  User: ${baseConfig.user}`);
    console.log('\n⚠️  IMPORTANT: Change default passwords in production!\n');

  } catch (error) {
    console.error('\n❌ Database setup error:', error.message);
    console.error('\n💡 Troubleshooting:');
    console.error('   1. Make sure PostgreSQL is running');
    console.error('   2. Check Docker container is up: docker ps');
    console.error('   3. Verify credentials in .env file');
    console.error('   4. Wait 20-30 seconds after starting container');
    
    if (error.code === 'ECONNREFUSED' || error.message.includes('does not exist')) {
      console.error('\n💡 PostgreSQL not accessible?');
      console.error('   Start container: npm run db:start:postgres');
      console.error('   Wait 20 seconds, then try again');
      console.error('   Check logs: npm run db:logs:postgres');
    }
    
    process.exit(1);
  } finally {
    if (pool) {
      await pool.end();
    }
    if (adminPool) {
      await adminPool.end();
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
