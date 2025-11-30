const { Pool } = require('pg');
require('dotenv').config();

const pool = new Pool({
  host: process.env.DB_SERVER || '127.0.0.1', // Use 127.0.0.1 instead of localhost for better compatibility
  port: parseInt(process.env.DB_PORT || '5433'), // Changed to 5433 to avoid local PostgreSQL conflict
  database: process.env.DB_NAME || 'FactoryUtility',
  user: process.env.DB_USER || 'postgres',
  password: process.env.DB_PASSWORD || 'FactoryUtility@123',
  max: 20,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 5000, // Increased timeout
});

// Handle pool errors
pool.on('error', (err, client) => {
  console.error('Unexpected error on idle client', err);
  process.exit(-1);
});

// Convert SQL Server query to PostgreSQL
const convertQuery = (query, params) => {
  let convertedQuery = query;
  const paramArray = [];
  const paramMap = {}; // Map param names to positions
  
  // First, identify all parameter placeholders and map them
  if (params && typeof params === 'object' && !Array.isArray(params)) {
    const keys = Object.keys(params);
    keys.forEach((key, index) => {
      paramMap[key] = index;
      paramArray.push(params[key]);
    });
  } else if (Array.isArray(params)) {
    paramArray.push(...params);
  }
  
  // Convert @param syntax to PostgreSQL $1, $2, etc. (order matters - process in reverse to avoid conflicts)
  if (Object.keys(paramMap).length > 0) {
    // Sort keys by length (longest first) to avoid partial replacements
    const sortedKeys = Object.keys(paramMap).sort((a, b) => b.length - a.length);
    sortedKeys.forEach(key => {
      const placeholder = `$${paramMap[key] + 1}`;
      // Use word boundary to match whole parameter names
      const regex = new RegExp(`@${key.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}\\b`, 'g');
      convertedQuery = convertedQuery.replace(regex, placeholder);
    });
  }
  
  // Convert SQL Server functions to PostgreSQL
  convertedQuery = convertedQuery
    .replace(/GETDATE\(\)/gi, 'CURRENT_TIMESTAMP')
    .replace(/GETDATE\b/gi, 'CURRENT_TIMESTAMP')
    .replace(/\bISNULL\(/gi, 'COALESCE(')
    .replace(/TOP\s+(\d+)/gi, (match, num) => `LIMIT ${num}`)
    .replace(/SELECT\s+TOP\s+1\s+/gi, 'SELECT ')
    .replace(/\bDATETIME\b/gi, 'TIMESTAMP')
    .replace(/\bNVARCHAR\b/gi, 'VARCHAR')
    .replace(/\bBIT\b/gi, 'BOOLEAN');
  
  // Convert error handling - PostgreSQL uses different error codes
  // SQL Server 2627 (duplicate key) = PostgreSQL 23505 (unique violation)
  
  // Convert [dbo].[TableName] to "TableName" first (before other replacements)
  convertedQuery = convertedQuery.replace(/\[dbo\]\.\[(\w+)\]/gi, '"$1"');
  convertedQuery = convertedQuery.replace(/\[(\w+)\]/gi, '"$1"');
  
  // Handle table names - PostgreSQL is case-sensitive, wrap in quotes
  // Only replace if not already quoted
  const tableNames = [
    'LoginDetails', 'SpiMaster', 'Spichangehistory', 'SpiModel', 'SpiRoute',
    'StencilMaster', 'Stencilchangehistory', 'StencilModel', 'StencilRoute',
    'SQGMaster', 'SQGchangehistory', 'SQGRoute',
    'WaveMaster', 'Wavechangehistory', 'WaveModel', 'WaveRoute',
    'HoldRelease', 'LastUpdated'
  ];
  
  tableNames.forEach(tableName => {
    // Replace table name only if not already quoted (negative lookbehind/lookahead)
    // Match word boundary, table name, word boundary, but not if preceded or followed by quote
    const regex = new RegExp(`(?<!")\\b${tableName}\\b(?!")`, 'gi');
    convertedQuery = convertedQuery.replace(regex, `"${tableName}"`);
  });
  
  // Quote common column names that are case-sensitive in PostgreSQL
  // These columns exist in our schema with mixed case
  const columnNames = [
    'Userid', 'Username', 'Useremail', 'Userpassword', 'Roles', 'Created_DT', 'Lastupdated_DT', 'IsActive',
    'Spi_id', 'totalpcba_allowed', 'totalcycle_allowed', 'currentstencil_status', 'currentpcba_count', 'currentcycle_count',
    'created_by', 'created_DT', 'Lastupdated_by', 'Lastupdated_DT',
    'Stencil_id', 'SQG_id', 'Wave_id', 'Model', 'ModelDesc', 'Created_By', 'Created_Date',
    'routeno', 'status1', 'cyclecount', 'totalcycle_count', 'pcbacount', 'totalpcba_count', 'remarks',
    'routedescription', 'previousmandatory', 'gaptime',
    'StencilId', 'Status', 'CurrentStatus', 'Remarks', 'HoldDate', 'ReleaseDate', 'Created_By', 'Created_DT',
    'ComputerName', 'StartDate'
  ];
  
  columnNames.forEach(columnName => {
    // Replace column name only if not already quoted and not part of a quoted identifier
    const regex = new RegExp(`(?<!")\\b${columnName}\\b(?!")`, 'gi');
    convertedQuery = convertedQuery.replace(regex, `"${columnName}"`);
  });
  
  return { query: convertedQuery, params: paramArray };
};

// Map PostgreSQL error codes to SQL Server error codes for compatibility
const mapErrorCode = (pgError) => {
  if (!pgError || !pgError.code) return pgError;
  
  // Map PostgreSQL error codes to SQL Server error numbers
  const errorMap = {
    '23505': 2627,  // unique_violation -> duplicate key
    '23503': 547,   // foreign_key_violation -> foreign key constraint
    '23502': 515,   // not_null_violation -> cannot insert null
    '42P01': 208,   // undefined_table -> object name invalid
    '42703': 207,   // undefined_column -> invalid column name
  };
  
  if (errorMap[pgError.code]) {
    pgError.number = errorMap[pgError.code];
  }
  
  return pgError;
};

// Helper function to execute queries
const executeQuery = async (query, params = {}) => {
  const client = await pool.connect();
  try {
    const { query: convertedQuery, params: convertedParams } = convertQuery(query, params);
    const result = await client.query(convertedQuery, convertedParams);
    
    // Convert PostgreSQL results to match SQL Server format (capitalize keys)
    return result.rows.map(row => {
      const convertedRow = {};
      Object.keys(row).forEach(key => {
        // Keep original case but also add capitalized version for compatibility
        convertedRow[key] = row[key];
        const capitalizedKey = key.charAt(0).toUpperCase() + key.slice(1);
        if (capitalizedKey !== key) {
          convertedRow[capitalizedKey] = row[key];
        }
      });
      return convertedRow;
    });
  } catch (err) {
    console.error('Query execution error:', err);
    console.error('Original query:', query);
    throw mapErrorCode(err);
  } finally {
    client.release();
  }
};

// Helper function to execute queries that return a single row
const executeQuerySingle = async (query, params = {}) => {
  const result = await executeQuery(query, params);
  return result[0] || null;
};

// Helper function for INSERT/UPDATE/DELETE
const executeNonQuery = async (query, params = {}) => {
  const client = await pool.connect();
  try {
    const { query: convertedQuery, params: convertedParams } = convertQuery(query, params);
    const result = await client.query(convertedQuery, convertedParams);
    return result.rowCount;
  } catch (err) {
    console.error('Non-query execution error:', err);
    console.error('Original query:', query);
    throw mapErrorCode(err);
  } finally {
    client.release();
  }
};

// Helper function to get pool (for compatibility)
const getPool = async () => {
  return pool;
};

// Test connection
const testConnection = async () => {
  try {
    const result = await executeQuery('SELECT NOW() as current_time');
    console.log('PostgreSQL connection successful');
    return true;
  } catch (err) {
    console.error('PostgreSQL connection failed:', err);
    return false;
  }
};

module.exports = {
  pool,
  getPool,
  executeQuery,
  executeQuerySingle,
  executeNonQuery,
  testConnection
};
