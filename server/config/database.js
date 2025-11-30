// Unified Database Module - Supports both SQL Server and PostgreSQL
require('dotenv').config();

// Determine which database to use
// Use PostgreSQL if:
// 1. DB_TYPE is explicitly set to 'postgres'
// 2. DB_PORT is 5432 (PostgreSQL default)
// 3. DB_SERVER is localhost AND no DB_TYPE specified (assumed local PostgreSQL)
const USE_POSTGRES = process.env.DB_TYPE === 'postgres' || 
                     process.env.DB_PORT === '5432' ||
                     (process.env.DB_SERVER === 'localhost' && !process.env.DB_TYPE && process.env.DB_PORT !== '49172' && process.env.DB_PORT !== '1433');

let dbModule;

if (USE_POSTGRES) {
  console.log('📊 Using PostgreSQL database');
  console.log(`   Host: ${process.env.DB_SERVER || 'localhost'}:${process.env.DB_PORT || '5432'}`);
  dbModule = require('./database-postgres');
} else {
  console.log('📊 Using SQL Server database');
  console.log(`   Server: ${process.env.DB_SERVER || 'localhost'}:${process.env.DB_PORT || '1433'}`);
  dbModule = require('./database-sqlserver');
}

// Export the database module
module.exports = dbModule;
