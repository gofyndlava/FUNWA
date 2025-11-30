const express = require('express');
const router = express.Router();
const { executeQuery, executeNonQuery } = require('../config/database');
const { authenticateToken, authorizeRole } = require('../middleware/auth');

// Apply authentication middleware to all routes except specific public ones
router.use((req, res, next) => {
  // Allow unauthenticated access to model and route lists for dropdowns
  if (req.path === '/models' || req.path === '/routes') {
    return next();
  }
  authenticateToken(req, res, next);
});

// Get SPI Models (for dropdown)
router.get('/models', async (req, res) => {
  try {
    const query = `
      SELECT '-- Select Model --' AS "Model", '' AS "SPIValue" 
      UNION ALL 
      SELECT DISTINCT "Model", "Model" AS "SPIValue" 
      FROM "SpiModel"
      ORDER BY "Model" ASC
    `;

    const results = await executeQuery(query);
    res.json({ success: true, data: results });
  } catch (error) {
    console.error('Error fetching SPI models:', error);
    res.status(500).json({ error: 'Failed to fetch SPI models' });
  }
});

// Create new SPI
router.post('/new', authorizeRole('ADMIN', 'PROCESS'), async (req, res) => {
  try {
    const { model, spiid, totalpcba_allowed, totalcycle_allowed } = req.body;
    const userid = req.user.userid;

    if (!model || model === '-- Select Model --' || !spiid || !totalpcba_allowed || !totalcycle_allowed) {
      return res.status(400).json({ error: 'All fields are required, and a valid Model must be selected.' });
    }

    const spiIdUpper = spiid.toUpperCase();
    const modelUpper = model.trim() === '-- Select Model --' ? null : model.trim().toUpperCase();

    if (!modelUpper || modelUpper === '') {
      return res.status(400).json({ error: 'Please select a valid Model' });
    }

    // Insert into SpiMaster
    const insertMasterQuery = `
      INSERT INTO "SpiMaster"(
        "Spi_id", "Model", "totalpcba_allowed", "totalcycle_allowed", 
        "currentstencil_status", "currentpcba_count", "currentcycle_count", 
        "created_by", "created_DT", "Lastupdated_by", "Lastupdated_DT"
      )
      VALUES (@spiid, @model, @pcba, @cycle, 'New', 0, 0, @user, CURRENT_TIMESTAMP, @user, CURRENT_TIMESTAMP)
    `;

    await executeNonQuery(insertMasterQuery, {
      spiid: spiIdUpper,
      model: modelUpper,
      pcba: totalpcba_allowed,
      cycle: totalcycle_allowed,
      user: userid
    });

    // Insert into Spichangehistory
    const insertHistoryQuery = `
      INSERT INTO "Spichangehistory"(
        "Spi_id", "routeno", "status1", "cyclecount", "totalcycle_count", 
        "created_by", "created_DT", "Lastupdated_by", "Lastupdated_DT", 
        "pcbacount", "totalpcba_count"
      )
      VALUES (@spiid, 1, 'new', 0, 0, @user, CURRENT_TIMESTAMP, @user, CURRENT_TIMESTAMP, 0, 0)
    `;

    await executeNonQuery(insertHistoryQuery, {
      spiid: spiIdUpper,
      user: userid
    });

    res.json({ success: true, message: 'Successfully Submitted' });

  } catch (error) {
    console.error('Error creating SPI:', error);
    
    if (error.number === 2627) {
      // Primary key violation (duplicate SPI ID)
      return res.status(400).json({ error: 'Duplicate SPI ID. Please enter a unique value.' });
    }

    res.status(500).json({ error: 'Failed to create SPI: ' + error.message });
  }
});

// Get SPI routes/statuses (for change status dropdown)
router.get('/routes', async (req, res) => {
  try {
    const query = `
      SELECT '-- Select Status --' AS "TextFiled", '' AS "ValueField" 
      UNION ALL 
      SELECT DISTINCT "routedescription" AS "ValueField", "routedescription" AS "TextFiled"
      FROM "SpiRoute" 
      WHERE "routeno" <> 1
      ORDER BY "TextFiled" ASC
    `;

    const results = await executeQuery(query);
    res.json({ success: true, data: results });
  } catch (error) {
    console.error('Error fetching SPI routes:', error);
    res.status(500).json({ error: 'Failed to fetch SPI routes' });
  }
});

// Change SPI Status - COMPLETE BUSINESS LOGIC
router.post('/change-status', async (req, res) => {
  try {
    const { model, spiid, status1, remarks, pcbacount } = req.body;
    const userid = req.user.userid;
    const userRoles = req.user.roles || '';

    if (!model || !spiid || !status1 || !remarks || pcbacount === undefined) {
      return res.status(400).json({ error: 'All fields are required' });
    }

    const spiIdUpper = spiid.toUpperCase();
    let failureRemarks = '';

    // 1. Get current SPI data from master
    const getMasterQuery = `SELECT * FROM "SpiMaster" WHERE "Spi_id" = @spiid`;
    const masterData = await executeQuery(getMasterQuery, { spiid: spiIdUpper });

    if (masterData.length === 0) {
      return res.status(404).json({ error: 'SPI ID not found' });
    }

    const masterRecord = masterData[0];
    const totalPcbaAllowed = parseInt(masterRecord.totalpcba_allowed || 0);
    const totalCycleAllowed = parseInt(masterRecord.totalcycle_allowed || 0);

    // 2. Get latest history record (last route for max cycle count)
    const getLatestHistoryQuery = `
      SELECT * FROM (
        SELECT * FROM "Spichangehistory" 
        WHERE "Spi_id" = @spiid 
          AND "cyclecount" = (SELECT MAX("cyclecount") FROM "Spichangehistory" WHERE "Spi_id" = @spiid)
      ) t1 
      WHERE "routeno" = (
        SELECT MAX("routeno") 
        FROM "Spichangehistory" 
        WHERE "Spi_id" = @spiid 
          AND "cyclecount" = (SELECT MAX("cyclecount") FROM "Spichangehistory" WHERE "Spi_id" = @spiid)
      )
      ORDER BY "Lastupdated_DT" DESC
      LIMIT 1
    `;
    const latestHistoryData = await executeQuery(getLatestHistoryQuery, { spiid: spiIdUpper });

    if (latestHistoryData.length === 0) {
      return res.status(400).json({ error: 'No history found for this SPI' });
    }

    const latestHistory = latestHistoryData[0];
    const preRouteNo = parseInt(latestHistory.routeno || latestHistory.Routeno || 1);
    const preCycleCount = parseInt(latestHistory.cyclecount || latestHistory.Cyclecount || 0);
    const prePcbaCount = parseInt(latestHistory.pcbacount || latestHistory.Pcbacount || 0);
    const preTotalPcbaCount = parseInt(latestHistory.totalpcba_count || latestHistory.Totalpcba_count || 0);
    const lastUpdatedDt = latestHistory.Lastupdated_DT || latestHistory.lastupdated_dt || latestHistory.Lastupdated_DT;

    // 3. Get target route info from SpiRoute table
    const getTargetRouteQuery = `SELECT * FROM "SpiRoute" WHERE "routedescription" = @status`;
    const targetRouteData = await executeQuery(getTargetRouteQuery, { status: status1 });

    if (targetRouteData.length === 0) {
      return res.status(400).json({ error: 'Invalid status/route description' });
    }

    const targetRoute = targetRouteData[0];
    const currRouteNo = parseInt(targetRoute.routeno || targetRoute.Routeno);
    const currPreviousMandatory = parseInt(targetRoute.previousmandatory || targetRoute.Previousmandatory || 0);
    const currRoles = targetRoute.roles || targetRoute.Roles || '';
    const currGapTime = parseInt(targetRoute.gaptime || targetRoute.Gaptime || 0);

    // 4. Role validation
    const hasAdmin = userRoles.toUpperCase().includes('ADMIN');
    const requiredRoles = currRoles.toUpperCase().split(',').map(r => r.trim());
    const hasRequiredRole = requiredRoles.some(role => userRoles.toUpperCase().includes(role));

    if (!hasAdmin && !hasRequiredRole) {
      return res.status(403).json({ error: 'Please login with correct credentials. Insufficient role permissions.' });
    }

    // 5. Gap time validation (ENFORCED for SPI)
    if (currGapTime > 0 && lastUpdatedDt) {
      const lastUpdated = new Date(lastUpdatedDt);
      const requiredTime = new Date(lastUpdated.getTime() + (currGapTime * 60 * 1000));
      const now = new Date();

      if (now < requiredTime) {
        return res.status(400).json({ error: `Gap time is not matching as per required time minutes. Required ${currGapTime} minutes between status changes.` });
      }
    }

    // 6. Calculate new cycle and PCBA counts
    let currCycleCount = preCycleCount;
    let currTotalCycleCount = preCycleCount;
    let currPcbaCount = prePcbaCount;
    let currTotalPcbaCount = preTotalPcbaCount;

    // Cycle count: Increment on Route 6 (Load to machine)
    if (currRouteNo === 6) {
      currCycleCount = preCycleCount + 1;
      currTotalCycleCount = currCycleCount;
    }

    // PCBA count: Update only on Route 8 (Unload from machine)
    if (currRouteNo === 8) {
      const newPcbaCountValue = parseInt(pcbacount) || 0;
      currPcbaCount = newPcbaCountValue;
      currTotalPcbaCount = preTotalPcbaCount + newPcbaCountValue;
    }

    // 7. Route validation
    let routeCheck = false;
    if (preRouteNo === currPreviousMandatory && currTotalPcbaCount <= totalPcbaAllowed && currCycleCount <= totalCycleAllowed) {
      routeCheck = true;
    } else if (currRouteNo === 2 && preRouteNo === 1) {
      // Exception: Route 1 → Route 2 (New → Thawing in) always allowed
      routeCheck = true;
    }

    if (!routeCheck) {
      return res.status(400).json({ error: 'Validation Failed, please check dashboard to current status. Route transition not allowed or limits exceeded.' });
    }

    // 8. Limit validation
    if (currTotalPcbaCount > totalPcbaAllowed) {
      return res.status(400).json({ 
        error: `Current total PCBA count (${currTotalPcbaCount}) exceeds allowed maximum (${totalPcbaAllowed}).` 
      });
    }

    if (currTotalCycleCount > totalCycleAllowed) {
      return res.status(400).json({ 
        error: `Cycle count (${currTotalCycleCount}) exceeds allowed (${totalCycleAllowed}).` 
      });
    }

    // 9. Get next route number (sequential)
    const getNextRouteNoQuery = `
      SELECT COALESCE(MAX("routeno"), 0) + 1 AS "nextRouteNo" 
      FROM "Spichangehistory" 
      WHERE "Spi_id" = @spiid
    `;
    const nextRouteNoResult = await executeQuery(getNextRouteNoQuery, { spiid: spiIdUpper });
    const nextRouteNo = nextRouteNoResult[0].nextRouteNo || nextRouteNoResult[0].nextrouteno;

    // 10. Insert into history
    const insertHistoryQuery = `
      INSERT INTO "Spichangehistory"(
        "Spi_id", "routeno", "status1", "cyclecount", "totalcycle_count",
        "created_by", "created_DT", "Lastupdated_by", "Lastupdated_DT",
        "pcbacount", "totalpcba_count", "remarks"
      )
      VALUES (@spiid, @routeno, @status, @ccount, @tccount, 
              @user, CURRENT_TIMESTAMP, @user, CURRENT_TIMESTAMP, 
              @pcbacount, @totalpcbacount, @remarks)
    `;

    await executeNonQuery(insertHistoryQuery, {
      spiid: spiIdUpper,
      routeno: nextRouteNo,
      status: status1,
      ccount: currCycleCount,
      tccount: currTotalCycleCount,
      user: userid,
      pcbacount: currPcbaCount,
      totalpcbacount: currTotalPcbaCount,
      remarks: remarks
    });

    // 11. Update master
    const updateMasterQuery = `
      UPDATE "SpiMaster" 
      SET "currentstencil_status" = @status,
          "currentpcba_count" = @newTotalPcbaCount,
          "currentcycle_count" = @newTotalCycleCount,
          "Lastupdated_by" = @user,
          "Lastupdated_DT" = CURRENT_TIMESTAMP
      WHERE "Spi_id" = @spiid
    `;

    await executeNonQuery(updateMasterQuery, {
      status: status1,
      newTotalPcbaCount: currTotalPcbaCount,
      newTotalCycleCount: currTotalCycleCount,
      user: userid,
      spiid: spiIdUpper
    });

    // 12. Label printing logic (if Load to machine - Route 6)
    if (currRouteNo === 6 && status1.toUpperCase() === 'LOAD TO MACHINE') {
      // Label printing logic - placeholder for printer integration
      // In production, this would call a printer service to print labels
      console.log(`Label printing triggered for SPI ID: ${spiIdUpper} on Load to machine`);
      // TODO: Implement actual label printing service call here
    }
    // This can be implemented later with Web.config settings:
    // - IsLabelPrintRequired: "Yes"/"No"
    // - PrinterIP: "192.168.11.91"
    // - Copy: "2"

    res.json({ success: true, message: 'SPI status updated successfully' });

  } catch (error) {
    console.error('Error changing SPI status:', error);
    res.status(500).json({ error: 'Failed to change SPI status: ' + error.message });
  }
});

// Update SPI (Modify SPI)
router.put('/edit/:spiid', authorizeRole('ADMIN', 'PROCESS', 'QUALITY', 'OPERATOR'), async (req, res) => {
  try {
    const { spiid } = req.params;
    const { totalpcba_allowed, totalcycle_allowed } = req.body;
    const userid = req.user.userid;

    if (!totalpcba_allowed || !totalcycle_allowed) {
      return res.status(400).json({ error: 'PCBA allowed and cycle allowed are required' });
    }

    const spiIdUpper = spiid.toUpperCase();

    const updateQuery = `
      UPDATE "SpiMaster" 
      SET "totalpcba_allowed" = @pcba, 
          "totalcycle_allowed" = @cycle,
          "Lastupdated_by" = @user,
          "Lastupdated_DT" = CURRENT_TIMESTAMP
      WHERE "Spi_id" = @spiid
    `;

    const rowsAffected = await executeNonQuery(updateQuery, {
      pcba: totalpcba_allowed,
      cycle: totalcycle_allowed,
      user: userid,
      spiid: spiIdUpper
    });

    if (rowsAffected === 0) {
      return res.status(404).json({ error: 'SPI not found' });
    }

    res.json({ success: true, message: 'SPI updated successfully' });
  } catch (error) {
    console.error('Error updating SPI:', error);
    res.status(500).json({ error: 'Failed to update SPI: ' + error.message });
  }
});

// Get SPI by ID (for change status page)
router.get('/:spiid', async (req, res) => {
  try {
    const { spiid } = req.params;
    const spiIdUpper = spiid.toUpperCase();
    const query = `SELECT * FROM "SpiMaster" WHERE "Spi_id" = @spiid`;
    const results = await executeQuery(query, { spiid: spiIdUpper });

    if (results.length === 0) {
      return res.status(404).json({ error: 'SPI not found' });
    }

    res.json({ success: true, data: results[0] });
  } catch (error) {
    console.error('Error fetching SPI:', error);
    res.status(500).json({ error: 'Failed to fetch SPI' });
  }
});

// Get SPI History
router.get('/history/:spiid', authorizeRole('ADMIN', 'PROCESS', 'QUALITY', 'OPERATOR'), async (req, res) => {
  try {
    const { spiid } = req.params;
    const spiIdUpper = spiid.toUpperCase();

    const query = `
      SELECT 
        "Spi_id",
        "routeno",
        "status1",
        "cyclecount",
        "totalcycle_count",
        "pcbacount",
        "totalpcba_count",
        "remarks",
        "created_by",
        "created_DT",
        "Lastupdated_by",
        "Lastupdated_DT"
      FROM "Spichangehistory" 
      WHERE "Spi_id" = @spiid
      ORDER BY "routeno" ASC, "Lastupdated_DT" ASC
    `;

    const results = await executeQuery(query, { spiid: spiIdUpper });
    res.json({ success: true, data: results });
  } catch (error) {
    console.error('Error fetching SPI history:', error);
    res.status(500).json({ error: 'Failed to fetch SPI history: ' + error.message });
  }
});

module.exports = router;
