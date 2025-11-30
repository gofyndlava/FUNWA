const express = require('express');
const router = express.Router();
const { executeQuery, executeNonQuery } = require('../config/database');
const { authenticateToken, authorizeRole } = require('../middleware/auth');

router.use(authenticateToken);

// Create new Wave
router.post('/new', authorizeRole('ADMIN', 'PROCESS'), async (req, res) => {
  try {
    const { waveid, totalpcba_allowed, totalcycle_allowed } = req.body;
    const userid = req.user.userid;

    // Adjust based on your Wave table structure
    const insertQuery = `
      INSERT INTO WaveMaster(
        Wave_id, totalpcba_allowed, totalcycle_allowed,
        currentstencil_status, currentpcba_count, currentcycle_count,
        created_by, created_DT, Lastupdated_by, Lastupdated_DT
      )
      VALUES (@waveid, @totalpcba, @totalcycle, 'New', 0, 0, @user, GETDATE(), @user, GETDATE())
    `;

    await executeNonQuery(insertQuery, {
      waveid: waveid,
      totalpcba: totalpcba_allowed,
      totalcycle: totalcycle_allowed,
      user: userid
    });

    res.json({ success: true, message: 'Successfully Submitted' });
  } catch (error) {
    console.error('Error creating Wave:', error);
    res.status(500).json({ error: 'Failed to create Wave: ' + error.message });
  }
});

module.exports = router;

