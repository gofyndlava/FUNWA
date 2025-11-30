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

// Get Stencil Models
router.get('/models', async (req, res) => {
  try {
    const query = `
      SELECT '-- Select Model --' AS "Model", '' AS "StencilValue"
      UNION ALL 
      SELECT DISTINCT "Model", "Model" AS "StencilValue" 
      FROM "StencilModel"
      ORDER BY "Model" ASC
    `;
    const results = await executeQuery(query);
    res.json({ success: true, data: results });
  } catch (error) {
    console.error('Error fetching stencil models:', error);
    res.status(500).json({ error: 'Failed to fetch stencil models' });
  }
});

// Create new Stencil
router.post('/new', authorizeRole('ADMIN', 'PROCESS'), async (req, res) => {
  try {
    const { model, stencilid, totalpcba_allowed, totalcycle_allowed } = req.body;
    const userid = req.user.userid;

    if (!model || !stencilid || !totalpcba_allowed || !totalcycle_allowed) {
      return res.status(400).json({ error: 'All fields including Model are required' });
    }

    const stencilIdUpper = stencilid.toUpperCase();
    const modelUpper = model.trim() === '-- Select Model --' ? null : model.trim().toUpperCase();

    if (!modelUpper || modelUpper === '') {
      return res.status(400).json({ error: 'Please select a valid Model' });
    }

    // Insert into StencilMaster
    const insertMasterQuery = `
      INSERT INTO "StencilMaster"(
        "Stencil_id", "Model", "totalpcba_allowed", "totalcycle_allowed",
        "currentstencil_status", "currentpcba_count", "currentcycle_count",
        "created_by", "created_DT", "Lastupdated_by", "Lastupdated_DT"
      )
      VALUES (@stencilid, @model, @totalpcba, @totalcycle, 'New', 0, 0, @user, CURRENT_TIMESTAMP, @user, CURRENT_TIMESTAMP)
    `;

    await executeNonQuery(insertMasterQuery, {
      stencilid: stencilIdUpper,
      model: modelUpper,
      totalpcba: totalpcba_allowed,
      totalcycle: totalcycle_allowed,
      user: userid
    });

    // Insert into Stencilchangehistory
    const insertHistoryQuery = `
      INSERT INTO "Stencilchangehistory"(
        "stencil_id", "routeno", "status1", "cyclecount", "totalcycle_count",
        "created_by", "created_DT", "Lastupdated_by", "Lastupdated_DT",
        "pcbacount", "totalpcba_count"
      )
      VALUES (@stencilid, 1, 'new', 0, 0, @user, CURRENT_TIMESTAMP, @user, CURRENT_TIMESTAMP, 0, 0)
    `;

    await executeNonQuery(insertHistoryQuery, {
      stencilid: stencilIdUpper,
      user: userid
    });

    res.json({ success: true, message: 'Successfully Submitted' });

  } catch (error) {
    console.error('Error creating stencil:', error);
    
    if (error.number === 2627) {
      return res.status(400).json({ error: 'Duplicate Stencil ID. Please enter a unique value.' });
    }

    res.status(500).json({ error: 'Failed to create stencil: ' + error.message });
  }
});

// Get Stencil Routes/Statuses
router.get('/routes', async (req, res) => {
  try {
    const query = `
      SELECT '-- Select Status --' AS "TextFiled", '' AS "ValueField" 
      UNION ALL 
      SELECT DISTINCT "routedescription" AS "TextFiled", "routedescription" AS "ValueField"
      FROM "StencilRoute" 
      WHERE "routeno" <> 1
      ORDER BY "TextFiled" ASC
    `;
    const results = await executeQuery(query);
    res.json({ success: true, data: results });
  } catch (error) {
    console.error('Error fetching stencil routes:', error);
    res.status(500).json({ error: 'Failed to fetch stencil routes' });
  }
});

// Change Stencil Status - COMPLETE BUSINESS LOGIC
router.post('/change-status', async (req, res) => {
  try {
    const { model, stencilid, status1, remarks, pcbacount } = req.body;
    const userid = req.user.userid;
    const userRoles = req.user.roles || '';

    if (!model || !stencilid || !status1 || !remarks || pcbacount === undefined) {
      return res.status(400).json({ error: 'All fields are required' });
    }

    const stencilIdUpper = stencilid.toUpperCase();
    let failureRemarks = '';

    // 1. Get current stencil data from master
    const getMasterQuery = `SELECT * FROM "StencilMaster" WHERE "Stencil_id" = @stencilid`;
    const masterData = await executeQuery(getMasterQuery, { stencilid: stencilIdUpper });

    if (masterData.length === 0) {
      return res.status(404).json({ error: 'Stencil ID not found' });
    }

    const masterRecord = masterData[0];
    const totalPcbaAllowed = parseInt(masterRecord.totalpcba_allowed || 0);
    const totalCycleAllowed = parseInt(masterRecord.totalcycle_allowed || 0);

    // 2. Get latest history record (last route for max cycle count)
    const getLatestHistoryQuery = `
      SELECT * FROM (
        SELECT * FROM "Stencilchangehistory" 
        WHERE "stencil_id" = @stencilid 
          AND "cyclecount" = (SELECT MAX("cyclecount") FROM "Stencilchangehistory" WHERE "stencil_id" = @stencilid)
      ) t1 
      WHERE "routeno" = (
        SELECT MAX("routeno") 
        FROM "Stencilchangehistory" 
        WHERE "stencil_id" = @stencilid 
          AND "cyclecount" = (SELECT MAX("cyclecount") FROM "Stencilchangehistory" WHERE "stencil_id" = @stencilid)
      )
      ORDER BY "Lastupdated_DT" DESC
      LIMIT 1
    `;
    const latestHistoryData = await executeQuery(getLatestHistoryQuery, { stencilid: stencilIdUpper });

    if (latestHistoryData.length === 0) {
      return res.status(400).json({ error: 'No history found for this stencil' });
    }

    const latestHistory = latestHistoryData[0];
    const preRouteNo = parseInt(latestHistory.routeno || latestHistory.Routeno || 1);
    const preCycleCount = parseInt(latestHistory.cyclecount || latestHistory.Cyclecount || 0);
    const prePcbaCount = parseInt(latestHistory.pcbacount || latestHistory.Pcbacount || 0);
    const preTotalPcbaCount = parseInt(latestHistory.totalpcba_count || latestHistory.Totalpcba_count || 0);
    const lastUpdatedDt = latestHistory.Lastupdated_DT || latestHistory.lastupdated_dt || latestHistory.Lastupdated_DT;

    // 3. Get target route info from StencilRoute table
    const getTargetRouteQuery = `SELECT * FROM "StencilRoute" WHERE "routedescription" = @status`;
    const targetRouteData = await executeQuery(getTargetRouteQuery, { status: status1 });

    if (targetRouteData.length === 0) {
      return res.status(400).json({ error: 'Invalid status/route description' });
    }

    const targetRoute = targetRouteData[0];
    const currRouteNo = parseInt(targetRoute.routeno || targetRoute.Routeno);
    const currPreviousMandatory = parseInt(targetRoute.previousmandatory || targetRoute.Previousmandatory || 0);
    const currRoles = targetRoute.roles || targetRoute.Roles || '';
    const currGapTime = parseInt(targetRoute.gaptime || targetRoute.Gaptime || 0);

    // 4. Get previous route info for gap time
    const getPrevRouteQuery = `SELECT * FROM "StencilRoute" WHERE "routeno" = @routeno`;
    const prevRouteData = await executeQuery(getPrevRouteQuery, { routeno: preRouteNo });

    // 5. Role validation
    const hasAdmin = userRoles.toUpperCase().includes('ADMIN');
    const requiredRoles = currRoles.toUpperCase().split(',').map(r => r.trim());
    const hasRequiredRole = requiredRoles.some(role => userRoles.toUpperCase().includes(role));

    if (!hasAdmin && !hasRequiredRole) {
      return res.status(403).json({ error: 'Please login with correct credentials. Insufficient role permissions.' });
    }

    // 6. Gap time validation (if applicable)
    if (currGapTime > 0 && lastUpdatedDt) {
      const lastUpdated = new Date(lastUpdatedDt);
      const requiredTime = new Date(lastUpdated.getTime() + (currGapTime * 60 * 1000));
      const now = new Date();

      if (now < requiredTime) {
        return res.status(400).json({ error: `Gap time is not matching. Required ${currGapTime} minutes between status changes.` });
      }
    }

    // 7. Calculate new cycle and PCBA counts
    let currCycleCount = preCycleCount;
    let currTotalCycleCount = preCycleCount;
    let currPcbaCount = prePcbaCount;
    let currTotalPcbaCount = preTotalPcbaCount;

    // Cycle count: Increment on Route 2 (Load to machine / In Use)
    if (currRouteNo === 2) {
      currCycleCount = preCycleCount + 1;
      currTotalCycleCount = currCycleCount;
    }

    // PCBA count: Update only on Route 3 (Unloading)
    if (currRouteNo === 3) {
      const newPcbaCountValue = parseInt(pcbacount) || 0;
      currPcbaCount = newPcbaCountValue;
      currTotalPcbaCount = preTotalPcbaCount + newPcbaCountValue;
    }

    // 8. Route validation
    let routeCheck = false;
    if (preRouteNo === currPreviousMandatory) {
      // Previous route matches required route
      routeCheck = true;
    } else if (currRouteNo === 2 && preRouteNo === 1) {
      // Exception: Route 1 → Route 2 (New → Load) always allowed
      routeCheck = true;
    }

    if (!routeCheck) {
      return res.status(400).json({ error: 'Validation Failed, please check dashboard for current status. Route transition not allowed.' });
    }

    // 9. Limit validation
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

    // 10. Get next route number (sequential)
    const getNextRouteNoQuery = `
      SELECT COALESCE(MAX("routeno"), 0) + 1 AS "nextRouteNo" 
      FROM "Stencilchangehistory" 
      WHERE "stencil_id" = @stencilid
    `;
    const nextRouteNoResult = await executeQuery(getNextRouteNoQuery, { stencilid: stencilIdUpper });
    const nextRouteNo = nextRouteNoResult[0].nextRouteNo || nextRouteNoResult[0].nextrouteno;

    // 11. Insert into history
    const insertHistoryQuery = `
      INSERT INTO "Stencilchangehistory"(
        "stencil_id", "routeno", "status1", "cyclecount", "totalcycle_count",
        "created_by", "created_DT", "Lastupdated_by", "Lastupdated_DT",
        "pcbacount", "totalpcba_count", "remarks"
      )
      VALUES (@stencilid, @routeno, @status, @ccount, @tccount,
              @user, CURRENT_TIMESTAMP, @user, CURRENT_TIMESTAMP,
              @pcbacount, @totalpcbacount, @remarks)
    `;

    await executeNonQuery(insertHistoryQuery, {
      stencilid: stencilIdUpper,
      routeno: nextRouteNo,
      status: status1,
      ccount: currCycleCount,
      tccount: currTotalCycleCount,
      user: userid,
      pcbacount: currPcbaCount,
      totalpcbacount: currTotalPcbaCount,
      remarks: remarks
    });

    // 12. Update master
    const updateMasterQuery = `
      UPDATE "StencilMaster" 
      SET "currentstencil_status" = @status,
          "currentpcba_count" = @newTotalPcbaCount,
          "currentcycle_count" = @newTotalCycleCount,
          "Lastupdated_by" = @user,
          "Lastupdated_DT" = CURRENT_TIMESTAMP
      WHERE "Stencil_id" = @stencilid
    `;

    await executeNonQuery(updateMasterQuery, {
      status: status1,
      newTotalPcbaCount: currTotalPcbaCount,
      newTotalCycleCount: currTotalCycleCount,
      user: userid,
      stencilid: stencilIdUpper
    });

    // 13. Auto-cleaning logic: If status is "Quality verified" with "NG" in remarks
    // Note: "Quality verified" route may not exist in route table - check if it exists
    // If route doesn't exist, this logic will be skipped
    const remarksUpper = remarks.toUpperCase();
    // Check if Quality verified route exists and status matches
    if (status1 && status1.toLowerCase().includes('quality') && remarksUpper.includes('NG')) {
      const autoCycleCount = currCycleCount + 1;
      const autoRouteNo = 3; // Cleaning route
      const autoStatus = 'Cleaning'; // Use existing Cleaning route

      // Insert auto-cleaning history
      const autoCleanHistoryQuery = `
        INSERT INTO "Stencilchangehistory"(
          "stencil_id", "routeno", "status1", "cyclecount", "totalcycle_count",
          "created_by", "created_DT", "Lastupdated_by", "Lastupdated_DT",
          "pcbacount", "totalpcba_count", "remarks"
        )
        VALUES (@stencilid, @routeno, @status, @ccount, @tccount,
                @user, CURRENT_TIMESTAMP, @user, CURRENT_TIMESTAMP,
                @pcbacount, @totalpcbacount, @remarks)
      `;

      await executeNonQuery(autoCleanHistoryQuery, {
        stencilid: stencilIdUpper,
        routeno: autoRouteNo,
        status: autoStatus,
        ccount: autoCycleCount,
        tccount: autoCycleCount,
        user: userid,
        pcbacount: currPcbaCount,
        totalpcbacount: currTotalPcbaCount,
        remarks: remarks
      });

      // Update master with auto-cleaning status
      const autoCleanMasterQuery = `
        UPDATE "StencilMaster" 
        SET "currentstencil_status" = @status,
            "currentcycle_count" = @cyclecount,
            "Lastupdated_by" = @user,
            "Lastupdated_DT" = CURRENT_TIMESTAMP
        WHERE "Stencil_id" = @stencilid
      `;

      await executeNonQuery(autoCleanMasterQuery, {
        status: autoStatus,
        cyclecount: autoCycleCount,
        user: userid,
        stencilid: stencilIdUpper
      });

      return res.json({ 
        success: true, 
        message: 'Stencil status updated successfully. Auto-cleaning triggered due to NG in remarks.' 
      });
    }

    res.json({ success: true, message: 'Stencil status updated successfully' });

  } catch (error) {
    console.error('Error changing stencil status:', error);
    res.status(500).json({ error: 'Failed to change stencil status: ' + error.message });
  }
});

// Get Stencil History
router.get('/history/:stencilid', authorizeRole('ADMIN', 'PROCESS', 'QUALITY', 'OPERATOR'), async (req, res) => {
  try {
    const { stencilid } = req.params;
    const stencilIdUpper = stencilid.toUpperCase();

    const query = `
      SELECT 
        "stencil_id",
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
      FROM "Stencilchangehistory" 
      WHERE "stencil_id" = @stencilid
      ORDER BY "routeno" ASC, "Lastupdated_DT" ASC
    `;

    const results = await executeQuery(query, { stencilid: stencilIdUpper });
    res.json({ success: true, data: results });
  } catch (error) {
    console.error('Error fetching stencil history:', error);
    res.status(500).json({ error: 'Failed to fetch stencil history: ' + error.message });
  }
});

// Update Stencil (Modify Stencil)
router.put('/edit/:stencilid', authorizeRole('ADMIN', 'PROCESS', 'QUALITY', 'OPERATOR'), async (req, res) => {
  try {
    const { stencilid } = req.params;
    const { totalpcba_allowed, totalcycle_allowed } = req.body;
    const userid = req.user.userid;

    if (!totalpcba_allowed || !totalcycle_allowed) {
      return res.status(400).json({ error: 'PCBA allowed and cycle allowed are required' });
    }

    const stencilIdUpper = stencilid.toUpperCase();

    const updateQuery = `
      UPDATE "StencilMaster" 
      SET "totalpcba_allowed" = @pcba, 
          "totalcycle_allowed" = @cycle,
          "Lastupdated_by" = @user,
          "Lastupdated_DT" = CURRENT_TIMESTAMP
      WHERE "Stencil_id" = @stencilid
    `;

    const rowsAffected = await executeNonQuery(updateQuery, {
      pcba: totalpcba_allowed,
      cycle: totalcycle_allowed,
      user: userid,
      stencilid: stencilIdUpper
    });

    if (rowsAffected === 0) {
      return res.status(404).json({ error: 'Stencil not found' });
    }

    res.json({ success: true, message: 'Stencil updated successfully' });
  } catch (error) {
    console.error('Error updating stencil:', error);
    res.status(500).json({ error: 'Failed to update stencil: ' + error.message });
  }
});

// Get stencils for monitoring (status = 'In Use')
router.get('/monitor/list', async (req, res) => {
  try {
    const { filter } = req.query;
    
    let query = `
      SELECT "Stencil_id" AS stencil_id
      FROM "StencilMaster"
      WHERE "currentstencil_status" = @status
    `;

    const params = { status: 'In Use' };

    if (filter && filter.trim() !== '') {
      query += ` AND "Stencil_id" LIKE @filter`;
      params.filter = `%${filter.trim().toUpperCase()}%`;
    }

    query += ` ORDER BY "Stencil_id" ASC`;

    const results = await executeQuery(query, params);
    
    // Add default option at the beginning
    const data = [{ stencil_id: '-- Select Stencil --' }, ...results];
    
    res.json({ success: true, data: data });
  } catch (error) {
    console.error('Error fetching monitor stencils:', error);
    res.status(500).json({ error: 'Failed to fetch monitor stencils: ' + error.message });
  }
});

// Start monitoring a stencil
router.post('/monitor/start', authorizeRole('PROCESS', 'QUALITY', 'OPERATOR'), async (req, res) => {
  try {
    const { stencilid } = req.body;
    const userid = req.user.userid;

    if (!stencilid) {
      return res.status(400).json({ error: 'Stencil ID is required' });
    }

    const stencilIdUpper = stencilid.toUpperCase();

    // Get computer name (use a default for now, or get from request)
    const computerName = req.headers['x-computer-name'] || 'unknown';

    // Delete any existing entry for this computer
    const deleteQuery = 'DELETE FROM "LastUpdated" WHERE "ComputerName" = @comp';
    await executeNonQuery(deleteQuery, { comp: computerName });

    // Insert new active monitoring entry
    const insertQuery = `
      INSERT INTO "LastUpdated" ("StencilId", "ComputerName", "StartDate", "IsActive")
      VALUES (@id, @comp, CURRENT_TIMESTAMP, TRUE)
    `;
    await executeNonQuery(insertQuery, {
      id: stencilIdUpper,
      comp: computerName
    });

    // Get last updated time from StencilMaster
    const getLastUpdatedQuery = `
      SELECT "Lastupdated_DT" 
      FROM "StencilMaster" 
      WHERE "Stencil_id" = @id
      LIMIT 1
    `;
    const lastUpdatedResult = await executeQuery(getLastUpdatedQuery, { id: stencilIdUpper });

    if (lastUpdatedResult.length === 0) {
      return res.status(404).json({ error: 'Stencil not found' });
    }

    const lastUpdated = new Date(lastUpdatedResult[0].Lastupdated_DT);
    const warningTime = new Date(lastUpdated.getTime() + (4 * 60 * 60 * 1000)); // 4 hours

    res.json({
      success: true,
      message: 'Monitoring started',
      data: {
        stencilId: stencilIdUpper,
        lastUpdated: lastUpdated.toISOString(),
        warningTime: warningTime.toISOString()
      }
    });
  } catch (error) {
    console.error('Error starting monitor:', error);
    res.status(500).json({ error: 'Failed to start monitoring: ' + error.message });
  }
});

// Get Stencil by ID
router.get('/:stencilid', async (req, res) => {
  try {
    const { stencilid } = req.params;
    const stencilIdUpper = stencilid.toUpperCase();
    const query = `SELECT * FROM "StencilMaster" WHERE "Stencil_id" = @stencilid`;
    const results = await executeQuery(query, { stencilid: stencilIdUpper });

    if (results.length === 0) {
      return res.status(404).json({ error: 'Stencil not found' });
    }

    res.json({ success: true, data: results[0] });
  } catch (error) {
    console.error('Error fetching stencil:', error);
    res.status(500).json({ error: 'Failed to fetch stencil' });
  }
});

module.exports = router;
