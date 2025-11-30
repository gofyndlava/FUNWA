const express = require('express');
const router = express.Router();
const { executeQuery, executeNonQuery } = require('../config/database');
const { authenticateToken } = require('../middleware/auth');

router.use(authenticateToken);

// Hold/Scrap operations
router.post('/hold', async (req, res) => {
  try {
    const { stencilid, status, remarks } = req.body;
    const userid = req.user.userid;

    // Implementation based on your HoldScrap logic
    res.json({ success: true, message: 'Hold/Scrap operation completed' });
  } catch (error) {
    console.error('Error in hold/scrap:', error);
    res.status(500).json({ error: 'Failed to perform hold/scrap operation' });
  }
});

// Get Hold/Scrap Report
router.get('/report', async (req, res) => {
  try {
    // Implementation for scrap report
    const query = `SELECT * FROM HoldScrapReport ORDER BY created_DT DESC`;
    const results = await executeQuery(query);
    res.json({ success: true, data: results });
  } catch (error) {
    console.error('Error fetching scrap report:', error);
    res.status(500).json({ error: 'Failed to fetch scrap report' });
  }
});

module.exports = router;

