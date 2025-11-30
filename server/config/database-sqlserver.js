const sql = require('mssql');
require('dotenv').config();

const config = {
  server: process.env.DB_SERVER || '20.198.94.108',
  port: parseInt(process.env.DB_PORT || '49172'),
  database: process.env.DB_NAME || 'FactoryUtility',
  user: process.env.DB_USER || 'wtsqluser',
  password: process.env.DB_PASSWORD || 'Password@1',
  options: {
    encrypt: false,
    trustServerCertificate: true,
    enableArithAbort: true
  },
  pool: {
    max: 10,
    min: 0,
    idleTimeoutMillis: 30000
  }
};

let poolPromise;

const getPool = async () => {
  try {
    if (!poolPromise) {
      poolPromise = sql.connect(config);
    }
    return await poolPromise;
  } catch (err) {
    console.error('Database connection error:', err);
    poolPromise = null;
    throw err;
  }
};

// Convert PostgreSQL-style query to SQL Server
const convertQuery = (query) => {
  // Replace PostgreSQL placeholders ($1, $2) with SQL Server (@param1, @param2)
  // Replace CURRENT_TIMESTAMP with GETDATE()
  // Replace boolean true/false with 1/0
  let converted = query
    .replace(/CURRENT_TIMESTAMP/g, 'GETDATE()')
    .replace(/TRUE/g, '1')
    .replace(/FALSE/g, '0');
  
  return converted;
};

// Convert params object to SQL Server format
const convertParams = (params) => {
  if (Array.isArray(params)) {
    // Convert array params to object
    const result = {};
    params.forEach((value, index) => {
      result[`param${index + 1}`] = value;
    });
    return result;
  }
  return params;
};

const executeQuery = async (query, params = {}) => {
  try {
    const pool = await getPool();
    const request = pool.request();

    // Add parameters
    const convertedParams = convertParams(params);
    Object.keys(convertedParams).forEach(key => {
      request.input(key, convertedParams[key]);
    });

    const convertedQuery = convertQuery(query);
    // Replace @param references in query
    let finalQuery = convertedQuery;
    Object.keys(convertedParams).forEach((key, index) => {
      finalQuery = finalQuery.replace(new RegExp(`@${key}`, 'g'), `@${key}`);
    });

    const result = await request.query(finalQuery);
    return result.recordset;
  } catch (err) {
    console.error('Query execution error:', err);
    throw err;
  }
};

const executeQuerySingle = async (query, params = {}) => {
  const results = await executeQuery(query, params);
  return results[0] || null;
};

const executeNonQuery = async (query, params = {}) => {
  try {
    const pool = await getPool();
    const request = pool.request();

    const convertedParams = convertParams(params);
    Object.keys(convertedParams).forEach(key => {
      request.input(key, convertedParams[key]);
    });

    const convertedQuery = convertQuery(query);
    let finalQuery = convertedQuery;
    Object.keys(convertedParams).forEach(key => {
      finalQuery = finalQuery.replace(new RegExp(`@${key}`, 'g'), `@${key}`);
    });

    const result = await request.query(finalQuery);
    return result.rowsAffected[0];
  } catch (err) {
    console.error('Non-query execution error:', err);
    throw err;
  }
};

module.exports = {
  getPool,
  executeQuery,
  executeQuerySingle,
  executeNonQuery,
  sql
};

