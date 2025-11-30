const express = require('express');
const router = express.Router();
const { executeQuery, executeNonQuery } = require('../config/database');
const { authenticateToken, authorizeRole } = require('../middleware/auth');

router.use(authenticateToken);

// Get SQG Models (if exists)
router.get('/models', async (req, res) => {
  try {
    // Adjust query based on your SQG table structure
    const query = `SELECT '-- Select Model --' AS Model, '' AS SQGValue UNION ALL SELECT DISTINCT Model, Model AS SQGValue FROM SQGModel`;
    const results = await executeQuery(query);
    res.json({ success: true, data: results });
  } catch (error) {
    console.error('Error fetching SQG models:', error);
    res.status(500).json({ error: 'Failed to fetch SQG models' });
  }
});

// Create new SQG
router.post('/new', authorizeRole('ADMIN', 'PROCESS'), async (req, res) => {
  try {
    const { sqgid, totalpcba_allowed, totalcycle_allowed } = req.body;
    const userid = req.user.userid;

    // Adjust based on your SQG table structure
    const insertQuery = `
      INSERT INTO SQGMaster(
        SQG_id, totalpcba_allowed, totalcycle_allowed,
        currentstencil_status, currentpcba_count, currentcycle_count,
        created_by, created_DT, Lastupdated_by, Lastupdated_DT
      )
      VALUES (@sqgid, @totalpcba, @totalcycle, 'New', 0, 0, @user, GETDATE(), @user, GETDATE())
    `;

    await executeNonQuery(insertQuery, {
      sqgid: sqgid,
      totalpcba: totalpcba_allowed,
      totalcycle: totalcycle_allowed,
      user: userid
    });

    res.json({ success: true, message: 'Successfully Submitted' });
  } catch (error) {
    console.error('Error creating SQG:', error);
    res.status(500).json({ error: 'Failed to create SQG: ' + error.message });
  }
});

// Get SQG History
router.get('/history/:sqgid', authorizeRole('ADMIN', 'PROCESS', 'QUALITY', 'OPERATOR'), async (req, res) => {
  try {
    const { sqgid } = req.params;
    const query = `SELECT * FROM "SQGchangehistory" WHERE "SQG_id" = @sqgid ORDER BY "Lastupdated_DT" DESC`;
    const results = await executeQuery(query, { sqgid });
    res.json({ success: true, data: results });
  } catch (error) {
    console.error('Error fetching SQG history:', error);
    res.status(500).json({ error: 'Failed to fetch SQG history' });
  }
});

module.exports = router;

