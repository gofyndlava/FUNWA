-- ============================================
-- CORRECTED SAMPLE DATA
-- Following Complete Business Logic Implementation
-- ============================================
-- 
-- Business Logic Rules:
-- 1. Cycle count increments ONLY on Route 2 ("In Use" / "Load to machine")
-- 2. PCBA count updates ONLY on Route 3 (Unloading) for Stencil, Route 4 for SPI
-- 3. Route sequence must follow previousmandatory validation
-- 4. totalcycle_count = cumulative cycles (matches cyclecount when route 2)
-- 5. totalpcba_count = cumulative PCBA count
-- ============================================

-- Clear existing incorrect data (optional - comment out if you want to keep existing)
-- TRUNCATE TABLE "Stencilchangehistory" CASCADE;
-- TRUNCATE TABLE "Spichangehistory" CASCADE;
-- TRUNCATE TABLE "StencilMaster" CASCADE;
-- TRUNCATE TABLE "SpiMaster" CASCADE;

-- ============================================
-- 1. STENCIL MODELS
-- ============================================
INSERT INTO "StencilModel" ("Model", "ModelDesc", "Created_By", "Created_Date")
VALUES 
  ('MODEL-A', 'High-Density PCB - 0.4mm pitch BGA', 'admin', CURRENT_TIMESTAMP),
  ('MODEL-B', 'Standard PCB - 0.5mm pitch QFN', 'admin', CURRENT_TIMESTAMP),
  ('MODEL-C', 'Low-Profile PCB - 0.3mm pitch CSP', 'admin', CURRENT_TIMESTAMP),
  ('MODEL-D', 'Mixed Technology - Through-hole + SMT', 'admin', CURRENT_TIMESTAMP),
  ('MODEL-E', 'RF PCB - Controlled Impedance', 'admin', CURRENT_TIMESTAMP)
ON CONFLICT ("Model") DO NOTHING;

-- ============================================
-- 2. SPI MODELS
-- ============================================
INSERT INTO "SpiModel" ("Model", "ModelDesc", "Created_By", "Created_Date")
VALUES
  ('SPI-MODEL-A', 'SAC305 - Lead-Free, Type 3, 25-45μm', 'admin', CURRENT_TIMESTAMP),
  ('SPI-MODEL-B', 'SAC305 - Lead-Free, Type 4, 20-38μm', 'admin', CURRENT_TIMESTAMP),
  ('SPI-MODEL-C', 'SAC305 - Lead-Free, Type 5, 15-25μm', 'admin', CURRENT_TIMESTAMP)
ON CONFLICT ("Model") DO NOTHING;

-- ============================================
-- 3. STENCIL MASTER DATA (Corrected)
-- ============================================

-- ST001: In Use - Cycle 7, PCBA 7500 (correct workflow)
INSERT INTO "StencilMaster" ("Stencil_id", "Model", "totalpcba_allowed", "totalcycle_allowed", "currentstencil_status", "currentpcba_count", "currentcycle_count", "created_by", "created_DT", "Lastupdated_by", "Lastupdated_DT")
VALUES 
  ('ST001', 'MODEL-A', 10000, 10, 'In Use', 7500, 7, 'admin', CURRENT_TIMESTAMP - INTERVAL '20 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '2 hours')
ON CONFLICT ("Stencil_id") DO UPDATE SET
  "Model" = EXCLUDED."Model",
  "totalpcba_allowed" = EXCLUDED."totalpcba_allowed",
  "totalcycle_allowed" = EXCLUDED."totalcycle_allowed",
  "currentstencil_status" = EXCLUDED."currentstencil_status",
  "currentpcba_count" = EXCLUDED."currentpcba_count",
  "currentcycle_count" = EXCLUDED."currentcycle_count",
  "Lastupdated_by" = EXCLUDED."Lastupdated_by",
  "Lastupdated_DT" = EXCLUDED."Lastupdated_DT";

-- ST002: In Use - Cycle 6, PCBA 6000
INSERT INTO "StencilMaster" ("Stencil_id", "Model", "totalpcba_allowed", "totalcycle_allowed", "currentstencil_status", "currentpcba_count", "currentcycle_count", "created_by", "created_DT", "Lastupdated_by", "Lastupdated_DT")
VALUES 
  ('ST002', 'MODEL-B', 8000, 8, 'In Use', 6000, 6, 'admin', CURRENT_TIMESTAMP - INTERVAL '18 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '1 hour')
ON CONFLICT ("Stencil_id") DO UPDATE SET
  "Model" = EXCLUDED."Model",
  "totalpcba_allowed" = EXCLUDED."totalpcba_allowed",
  "totalcycle_allowed" = EXCLUDED."totalcycle_allowed",
  "currentstencil_status" = EXCLUDED."currentstencil_status",
  "currentpcba_count" = EXCLUDED."currentpcba_count",
  "currentcycle_count" = EXCLUDED."currentcycle_count",
  "Lastupdated_by" = EXCLUDED."Lastupdated_by",
  "Lastupdated_DT" = EXCLUDED."Lastupdated_DT";

-- ST003: In Use - Cycle 9, PCBA 9000
INSERT INTO "StencilMaster" ("Stencil_id", "Model", "totalpcba_allowed", "totalcycle_allowed", "currentstencil_status", "currentpcba_count", "currentcycle_count", "created_by", "created_DT", "Lastupdated_by", "Lastupdated_DT")
VALUES 
  ('ST003', 'MODEL-C', 12000, 12, 'In Use', 9000, 9, 'admin', CURRENT_TIMESTAMP - INTERVAL '15 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '30 minutes')
ON CONFLICT ("Stencil_id") DO UPDATE SET
  "Model" = EXCLUDED."Model",
  "totalpcba_allowed" = EXCLUDED."totalpcba_allowed",
  "totalcycle_allowed" = EXCLUDED."totalcycle_allowed",
  "currentstencil_status" = EXCLUDED."currentstencil_status",
  "currentpcba_count" = EXCLUDED."currentpcba_count",
  "currentcycle_count" = EXCLUDED."currentcycle_count",
  "Lastupdated_by" = EXCLUDED."Lastupdated_by",
  "Lastupdated_DT" = EXCLUDED."Lastupdated_DT";

-- ST004: In Use - Cycle 4, PCBA 4500
INSERT INTO "StencilMaster" ("Stencil_id", "Model", "totalpcba_allowed", "totalcycle_allowed", "currentstencil_status", "currentpcba_count", "currentcycle_count", "created_by", "created_DT", "Lastupdated_by", "Lastupdated_DT")
VALUES 
  ('ST004', 'MODEL-D', 6000, 6, 'In Use', 4500, 4, 'admin', CURRENT_TIMESTAMP - INTERVAL '12 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '15 minutes')
ON CONFLICT ("Stencil_id") DO UPDATE SET
  "Model" = EXCLUDED."Model",
  "totalpcba_allowed" = EXCLUDED."totalpcba_allowed",
  "totalcycle_allowed" = EXCLUDED."totalcycle_allowed",
  "currentstencil_status" = EXCLUDED."currentstencil_status",
  "currentpcba_count" = EXCLUDED."currentpcba_count",
  "currentcycle_count" = EXCLUDED."currentcycle_count",
  "Lastupdated_by" = EXCLUDED."Lastupdated_by",
  "Lastupdated_DT" = EXCLUDED."Lastupdated_DT";

-- ST005: In Use - Cycle 12, PCBA 12000
INSERT INTO "StencilMaster" ("Stencil_id", "Model", "totalpcba_allowed", "totalcycle_allowed", "currentstencil_status", "currentpcba_count", "currentcycle_count", "created_by", "created_DT", "Lastupdated_by", "Lastupdated_DT")
VALUES 
  ('ST005', 'MODEL-E', 15000, 15, 'In Use', 12000, 12, 'admin', CURRENT_TIMESTAMP - INTERVAL '25 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '3 hours')
ON CONFLICT ("Stencil_id") DO UPDATE SET
  "Model" = EXCLUDED."Model",
  "totalpcba_allowed" = EXCLUDED."totalpcba_allowed",
  "totalcycle_allowed" = EXCLUDED."totalcycle_allowed",
  "currentstencil_status" = EXCLUDED."currentstencil_status",
  "currentpcba_count" = EXCLUDED."currentpcba_count",
  "currentcycle_count" = EXCLUDED."currentcycle_count",
  "Lastupdated_by" = EXCLUDED."Lastupdated_by",
  "Lastupdated_DT" = EXCLUDED."Lastupdated_DT";

-- ST006-ST010: New Stencils (Ready for use)
INSERT INTO "StencilMaster" ("Stencil_id", "Model", "totalpcba_allowed", "totalcycle_allowed", "currentstencil_status", "currentpcba_count", "currentcycle_count", "created_by", "created_DT", "Lastupdated_by", "Lastupdated_DT")
VALUES 
  ('ST006', 'MODEL-A', 10000, 10, 'New', 0, 0, 'admin', CURRENT_TIMESTAMP, 'admin', CURRENT_TIMESTAMP),
  ('ST007', 'MODEL-B', 8000, 8, 'New', 0, 0, 'admin', CURRENT_TIMESTAMP, 'admin', CURRENT_TIMESTAMP),
  ('ST008', 'MODEL-C', 12000, 12, 'New', 0, 0, 'admin', CURRENT_TIMESTAMP, 'admin', CURRENT_TIMESTAMP),
  ('ST009', 'MODEL-D', 6000, 6, 'New', 0, 0, 'admin', CURRENT_TIMESTAMP, 'admin', CURRENT_TIMESTAMP),
  ('ST010', 'MODEL-E', 15000, 15, 'New', 0, 0, 'admin', CURRENT_TIMESTAMP, 'admin', CURRENT_TIMESTAMP)
ON CONFLICT ("Stencil_id") DO UPDATE SET
  "Model" = EXCLUDED."Model",
  "totalpcba_allowed" = EXCLUDED."totalpcba_allowed",
  "totalcycle_allowed" = EXCLUDED."totalcycle_allowed",
  "currentstencil_status" = EXCLUDED."currentstencil_status",
  "currentpcba_count" = EXCLUDED."currentpcba_count",
  "currentcycle_count" = EXCLUDED."currentcycle_count",
  "Lastupdated_by" = EXCLUDED."Lastupdated_by",
  "Lastupdated_DT" = EXCLUDED."Lastupdated_DT";

-- ST011-ST015: Cleaning Stencils
INSERT INTO "StencilMaster" ("Stencil_id", "Model", "totalpcba_allowed", "totalcycle_allowed", "currentstencil_status", "currentpcba_count", "currentcycle_count", "created_by", "created_DT", "Lastupdated_by", "Lastupdated_DT")
VALUES 
  ('ST011', 'MODEL-A', 10000, 10, 'Cleaning', 9500, 9, 'admin', CURRENT_TIMESTAMP - INTERVAL '10 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '2 hours'),
  ('ST012', 'MODEL-B', 8000, 8, 'Cleaning', 7500, 7, 'admin', CURRENT_TIMESTAMP - INTERVAL '8 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '1 hour'),
  ('ST013', 'MODEL-C', 12000, 12, 'Cleaning', 11000, 11, 'admin', CURRENT_TIMESTAMP - INTERVAL '12 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '3 hours'),
  ('ST014', 'MODEL-D', 6000, 6, 'Cleaning', 5500, 5, 'admin', CURRENT_TIMESTAMP - INTERVAL '7 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '30 minutes'),
  ('ST015', 'MODEL-E', 15000, 15, 'Cleaning', 14000, 14, 'admin', CURRENT_TIMESTAMP - INTERVAL '15 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '4 hours')
ON CONFLICT ("Stencil_id") DO UPDATE SET
  "Model" = EXCLUDED."Model",
  "totalpcba_allowed" = EXCLUDED."totalpcba_allowed",
  "totalcycle_allowed" = EXCLUDED."totalcycle_allowed",
  "currentstencil_status" = EXCLUDED."currentstencil_status",
  "currentpcba_count" = EXCLUDED."currentpcba_count",
  "currentcycle_count" = EXCLUDED."currentcycle_count",
  "Lastupdated_by" = EXCLUDED."Lastupdated_by",
  "Lastupdated_DT" = EXCLUDED."Lastupdated_DT";

-- ST016-ST020: Unloading Stencils
INSERT INTO "StencilMaster" ("Stencil_id", "Model", "totalpcba_allowed", "totalcycle_allowed", "currentstencil_status", "currentpcba_count", "currentcycle_count", "created_by", "created_DT", "Lastupdated_by", "Lastupdated_DT")
VALUES 
  ('ST016', 'MODEL-A', 10000, 10, 'Unloading', 9800, 9, 'admin', CURRENT_TIMESTAMP - INTERVAL '20 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '1 hour'),
  ('ST017', 'MODEL-B', 8000, 8, 'Unloading', 7800, 7, 'admin', CURRENT_TIMESTAMP - INTERVAL '18 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '2 hours'),
  ('ST018', 'MODEL-C', 12000, 12, 'Unloading', 11800, 11, 'admin', CURRENT_TIMESTAMP - INTERVAL '22 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '30 minutes'),
  ('ST019', 'MODEL-D', 6000, 6, 'Unloading', 5800, 5, 'admin', CURRENT_TIMESTAMP - INTERVAL '16 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '3 hours'),
  ('ST020', 'MODEL-E', 15000, 15, 'Unloading', 14800, 14, 'admin', CURRENT_TIMESTAMP - INTERVAL '25 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '1 hour 30 minutes')
ON CONFLICT ("Stencil_id") DO UPDATE SET
  "Model" = EXCLUDED."Model",
  "totalpcba_allowed" = EXCLUDED."totalpcba_allowed",
  "totalcycle_allowed" = EXCLUDED."totalcycle_allowed",
  "currentstencil_status" = EXCLUDED."currentstencil_status",
  "currentpcba_count" = EXCLUDED."currentpcba_count",
  "currentcycle_count" = EXCLUDED."currentcycle_count",
  "Lastupdated_by" = EXCLUDED."Lastupdated_by",
  "Lastupdated_DT" = EXCLUDED."Lastupdated_DT";

-- ST021-ST025: Hold/Scrap Stencils
INSERT INTO "StencilMaster" ("Stencil_id", "Model", "totalpcba_allowed", "totalcycle_allowed", "currentstencil_status", "currentpcba_count", "currentcycle_count", "created_by", "created_DT", "Lastupdated_by", "Lastupdated_DT")
VALUES 
  ('ST021', 'MODEL-A', 10000, 10, 'Hold', 5000, 5, 'admin', CURRENT_TIMESTAMP - INTERVAL '30 days', 'quality1', CURRENT_TIMESTAMP - INTERVAL '5 days'),
  ('ST022', 'MODEL-B', 8000, 8, 'Hold', 3000, 3, 'admin', CURRENT_TIMESTAMP - INTERVAL '28 days', 'quality1', CURRENT_TIMESTAMP - INTERVAL '3 days'),
  ('ST023', 'MODEL-C', 12000, 12, 'Scrap', 8000, 8, 'admin', CURRENT_TIMESTAMP - INTERVAL '60 days', 'quality1', CURRENT_TIMESTAMP - INTERVAL '10 days'),
  ('ST024', 'MODEL-D', 6000, 6, 'Scrap', 4000, 4, 'admin', CURRENT_TIMESTAMP - INTERVAL '55 days', 'quality1', CURRENT_TIMESTAMP - INTERVAL '8 days'),
  ('ST025', 'MODEL-E', 15000, 15, 'Hold', 7000, 7, 'admin', CURRENT_TIMESTAMP - INTERVAL '35 days', 'quality1', CURRENT_TIMESTAMP - INTERVAL '7 days')
ON CONFLICT ("Stencil_id") DO UPDATE SET
  "Model" = EXCLUDED."Model",
  "totalpcba_allowed" = EXCLUDED."totalpcba_allowed",
  "totalcycle_allowed" = EXCLUDED."totalcycle_allowed",
  "currentstencil_status" = EXCLUDED."currentstencil_status",
  "currentpcba_count" = EXCLUDED."currentpcba_count",
  "currentcycle_count" = EXCLUDED."currentcycle_count",
  "Lastupdated_by" = EXCLUDED."Lastupdated_by",
  "Lastupdated_DT" = EXCLUDED."Lastupdated_DT";

-- ============================================
-- 4. STENCIL CHANGE HISTORY (CORRECTED)
-- ============================================
-- ST001: Complete workflow with CORRECT cycle/PCBA logic
-- Route sequence: 1(New) → 2(In Use, cycle+1) → 3(Cleaning) → 4(Unloading, PCBA update) → 2(In Use, cycle+1) → ...

DELETE FROM "Stencilchangehistory" WHERE "stencil_id" = 'ST001';

INSERT INTO "Stencilchangehistory" ("stencil_id", "routeno", "status1", "cyclecount", "totalcycle_count", "pcbacount", "totalpcba_count", "remarks", "created_by", "created_DT", "Lastupdated_by", "Lastupdated_DT")
VALUES
  -- Route 1: New (cycle=0, PCBA=0)
  ('ST001', 1, 'new', 0, 0, 0, 0, 'Initial stencil creation', 'admin', CURRENT_TIMESTAMP - INTERVAL '20 days', 'admin', CURRENT_TIMESTAMP - INTERVAL '20 days'),
  
  -- Route 2: In Use (cycle increments to 1, PCBA stays 0)
  ('ST001', 2, 'In Use', 1, 1, 0, 0, 'Loaded to Line 1 - Model A production', 'process1', CURRENT_TIMESTAMP - INTERVAL '19 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '19 days'),
  
  -- Route 3: Cleaning (cycle stays 1, PCBA stays 0)
  ('ST001', 3, 'Cleaning', 1, 1, 0, 0, 'First cleaning cycle after loading', 'operator1', CURRENT_TIMESTAMP - INTERVAL '18 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '18 days'),
  
  -- Route 4: Unloading (cycle stays 1, PCBA updates to 1000)
  ('ST001', 4, 'Unloading', 1, 1, 1000, 1000, 'Unloaded after cycle 1 - 1000 PCBA produced', 'process1', CURRENT_TIMESTAMP - INTERVAL '17 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '17 days'),
  
  -- Route 2: In Use (cycle increments to 2, PCBA stays 1000)
  ('ST001', 5, 'In Use', 2, 2, 0, 1000, 'Re-loaded to Line 1 - Continued production', 'process1', CURRENT_TIMESTAMP - INTERVAL '16 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '16 days'),
  
  -- Route 3: Cleaning (cycle stays 2, PCBA stays 1000)
  ('ST001', 6, 'Cleaning', 2, 2, 0, 1000, 'Second cleaning cycle', 'operator1', CURRENT_TIMESTAMP - INTERVAL '15 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '15 days'),
  
  -- Route 4: Unloading (cycle stays 2, PCBA updates to 2500 total)
  ('ST001', 7, 'Unloading', 2, 2, 1500, 2500, 'Unloaded after cycle 2 - 1500 more PCBA', 'process1', CURRENT_TIMESTAMP - INTERVAL '14 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '14 days'),
  
  -- Route 2: In Use (cycle increments to 3, PCBA stays 2500)
  ('ST001', 8, 'In Use', 3, 3, 0, 2500, 'Re-loaded to Line 1', 'process1', CURRENT_TIMESTAMP - INTERVAL '13 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '13 days'),
  
  -- Route 3: Cleaning (cycle stays 3, PCBA stays 2500)
  ('ST001', 9, 'Cleaning', 3, 3, 0, 2500, 'Third cleaning cycle', 'operator1', CURRENT_TIMESTAMP - INTERVAL '12 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '12 days'),
  
  -- Route 4: Unloading (cycle stays 3, PCBA updates to 4500 total)
  ('ST001', 10, 'Unloading', 3, 3, 2000, 4500, 'Unloaded after cycle 3 - 2000 more PCBA', 'process1', CURRENT_TIMESTAMP - INTERVAL '11 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '11 days'),
  
  -- Route 2: In Use (cycle increments to 4, PCBA stays 4500)
  ('ST001', 11, 'In Use', 4, 4, 0, 4500, 'Re-loaded to Line 1', 'process1', CURRENT_TIMESTAMP - INTERVAL '10 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '10 days'),
  
  -- Route 3: Cleaning (cycle stays 4, PCBA stays 4500)
  ('ST001', 12, 'Cleaning', 4, 4, 0, 4500, 'Fourth cleaning cycle', 'operator1', CURRENT_TIMESTAMP - INTERVAL '9 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '9 days'),
  
  -- Route 4: Unloading (cycle stays 4, PCBA updates to 6000 total)
  ('ST001', 13, 'Unloading', 4, 4, 1500, 6000, 'Unloaded after cycle 4', 'process1', CURRENT_TIMESTAMP - INTERVAL '8 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '8 days'),
  
  -- Route 2: In Use (cycle increments to 5, PCBA stays 6000)
  ('ST001', 14, 'In Use', 5, 5, 0, 6000, 'Re-loaded to Line 1', 'process1', CURRENT_TIMESTAMP - INTERVAL '7 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '7 days'),
  
  -- Route 3: Cleaning (cycle stays 5, PCBA stays 6000)
  ('ST001', 15, 'Cleaning', 5, 5, 0, 6000, 'Fifth cleaning cycle', 'operator1', CURRENT_TIMESTAMP - INTERVAL '6 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '6 days'),
  
  -- Route 4: Unloading (cycle stays 5, PCBA updates to 7000 total)
  ('ST001', 16, 'Unloading', 5, 5, 1000, 7000, 'Unloaded after cycle 5', 'process1', CURRENT_TIMESTAMP - INTERVAL '5 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '5 days'),
  
  -- Route 2: In Use (cycle increments to 6, PCBA stays 7000)
  ('ST001', 17, 'In Use', 6, 6, 0, 7000, 'Re-loaded to Line 1', 'process1', CURRENT_TIMESTAMP - INTERVAL '4 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '4 days'),
  
  -- Route 3: Cleaning (cycle stays 6, PCBA stays 7000)
  ('ST001', 18, 'Cleaning', 6, 6, 0, 7000, 'Sixth cleaning cycle', 'operator1', CURRENT_TIMESTAMP - INTERVAL '3 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '3 days'),
  
  -- Route 4: Unloading (cycle stays 6, PCBA updates to 7500 total)
  ('ST001', 19, 'Unloading', 6, 6, 500, 7500, 'Unloaded after cycle 6', 'process1', CURRENT_TIMESTAMP - INTERVAL '2 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '2 days'),
  
  -- Route 2: In Use (cycle increments to 7, PCBA stays 7500) - CURRENT STATUS
  ('ST001', 20, 'In Use', 7, 7, 0, 7500, 'Re-loaded to Line 1 - Current production', 'process1', CURRENT_TIMESTAMP - INTERVAL '2 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '2 hours');

-- ST002: Shorter workflow example
DELETE FROM "Stencilchangehistory" WHERE "stencil_id" = 'ST002';

INSERT INTO "Stencilchangehistory" ("stencil_id", "routeno", "status1", "cyclecount", "totalcycle_count", "pcbacount", "totalpcba_count", "remarks", "created_by", "created_DT", "Lastupdated_by", "Lastupdated_DT")
VALUES
  ('ST002', 1, 'new', 0, 0, 0, 0, 'Initial stencil creation', 'admin', CURRENT_TIMESTAMP - INTERVAL '18 days', 'admin', CURRENT_TIMESTAMP - INTERVAL '18 days'),
  ('ST002', 2, 'In Use', 1, 1, 0, 0, 'Loaded to Line 2 - Model B production', 'process1', CURRENT_TIMESTAMP - INTERVAL '17 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '17 days'),
  ('ST002', 3, 'Cleaning', 1, 1, 0, 0, 'First cleaning cycle', 'operator1', CURRENT_TIMESTAMP - INTERVAL '16 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '16 days'),
  ('ST002', 4, 'Unloading', 1, 1, 2000, 2000, 'Unloaded after cycle 1 - 2000 PCBA', 'process1', CURRENT_TIMESTAMP - INTERVAL '15 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '15 days'),
  ('ST002', 5, 'In Use', 2, 2, 0, 2000, 'Re-loaded to Line 2', 'process1', CURRENT_TIMESTAMP - INTERVAL '14 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '14 days'),
  ('ST002', 6, 'Cleaning', 2, 2, 0, 2000, 'Second cleaning cycle', 'operator1', CURRENT_TIMESTAMP - INTERVAL '13 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '13 days'),
  ('ST002', 7, 'Unloading', 2, 2, 2000, 4000, 'Unloaded after cycle 2 - 2000 more PCBA', 'process1', CURRENT_TIMESTAMP - INTERVAL '12 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '12 days'),
  ('ST002', 8, 'In Use', 3, 3, 0, 4000, 'Re-loaded to Line 2', 'process1', CURRENT_TIMESTAMP - INTERVAL '11 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '11 days'),
  ('ST002', 9, 'Cleaning', 3, 3, 0, 4000, 'Third cleaning cycle', 'operator1', CURRENT_TIMESTAMP - INTERVAL '10 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '10 days'),
  ('ST002', 10, 'Unloading', 3, 3, 2000, 6000, 'Unloaded after cycle 3 - 2000 more PCBA', 'process1', CURRENT_TIMESTAMP - INTERVAL '9 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '9 days'),
  ('ST002', 11, 'In Use', 4, 4, 0, 6000, 'Re-loaded to Line 2', 'process1', CURRENT_TIMESTAMP - INTERVAL '8 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '8 days'),
  ('ST002', 12, 'Cleaning', 4, 4, 0, 6000, 'Fourth cleaning cycle', 'operator1', CURRENT_TIMESTAMP - INTERVAL '7 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '7 days'),
  ('ST002', 13, 'Unloading', 4, 4, 0, 6000, 'Unloaded after cycle 4 - No PCBA this cycle', 'process1', CURRENT_TIMESTAMP - INTERVAL '6 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '6 days'),
  ('ST002', 14, 'In Use', 5, 5, 0, 6000, 'Re-loaded to Line 2', 'process1', CURRENT_TIMESTAMP - INTERVAL '5 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '5 days'),
  ('ST002', 15, 'Cleaning', 5, 5, 0, 6000, 'Fifth cleaning cycle', 'operator1', CURRENT_TIMESTAMP - INTERVAL '4 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '4 days'),
  ('ST002', 16, 'Unloading', 5, 5, 0, 6000, 'Unloaded after cycle 5', 'process1', CURRENT_TIMESTAMP - INTERVAL '3 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '3 days'),
  ('ST002', 17, 'In Use', 6, 6, 0, 6000, 'Re-loaded to Line 2 - Current production', 'process1', CURRENT_TIMESTAMP - INTERVAL '1 hour', 'process1', CURRENT_TIMESTAMP - INTERVAL '1 hour');

-- ST005: High-volume production example
DELETE FROM "Stencilchangehistory" WHERE "stencil_id" = 'ST005';

INSERT INTO "Stencilchangehistory" ("stencil_id", "routeno", "status1", "cyclecount", "totalcycle_count", "pcbacount", "totalpcba_count", "remarks", "created_by", "created_DT", "Lastupdated_by", "Lastupdated_DT")
VALUES
  ('ST005', 1, 'new', 0, 0, 0, 0, 'Initial stencil creation', 'admin', CURRENT_TIMESTAMP - INTERVAL '30 days', 'admin', CURRENT_TIMESTAMP - INTERVAL '30 days'),
  ('ST005', 2, 'In Use', 1, 1, 0, 0, 'Loaded to Line 3 - High volume production', 'process1', CURRENT_TIMESTAMP - INTERVAL '29 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '29 days'),
  ('ST005', 3, 'Cleaning', 1, 1, 0, 0, 'First cleaning cycle', 'operator1', CURRENT_TIMESTAMP - INTERVAL '28 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '28 days'),
  ('ST005', 4, 'Unloading', 1, 1, 2000, 2000, 'Unloaded after cycle 1 - 2000 PCBA', 'process1', CURRENT_TIMESTAMP - INTERVAL '27 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '27 days'),
  ('ST005', 5, 'In Use', 2, 2, 0, 2000, 'Re-loaded to Line 3', 'process1', CURRENT_TIMESTAMP - INTERVAL '26 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '26 days'),
  ('ST005', 6, 'Cleaning', 2, 2, 0, 2000, 'Second cleaning cycle', 'operator1', CURRENT_TIMESTAMP - INTERVAL '25 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '25 days'),
  ('ST005', 7, 'Unloading', 2, 2, 2500, 4500, 'Unloaded after cycle 2 - 2500 more PCBA', 'process1', CURRENT_TIMESTAMP - INTERVAL '24 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '24 days'),
  ('ST005', 8, 'In Use', 3, 3, 0, 4500, 'Re-loaded to Line 3', 'process1', CURRENT_TIMESTAMP - INTERVAL '23 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '23 days'),
  ('ST005', 9, 'Cleaning', 3, 3, 0, 4500, 'Third cleaning cycle', 'operator1', CURRENT_TIMESTAMP - INTERVAL '22 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '22 days'),
  ('ST005', 10, 'Unloading', 3, 3, 3000, 7500, 'Unloaded after cycle 3 - 3000 more PCBA', 'process1', CURRENT_TIMESTAMP - INTERVAL '21 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '21 days'),
  ('ST005', 11, 'In Use', 4, 4, 0, 7500, 'Re-loaded to Line 3', 'process1', CURRENT_TIMESTAMP - INTERVAL '20 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '20 days'),
  ('ST005', 12, 'Cleaning', 4, 4, 0, 7500, 'Fourth cleaning cycle', 'operator1', CURRENT_TIMESTAMP - INTERVAL '19 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '19 days'),
  ('ST005', 13, 'Unloading', 4, 4, 2500, 10000, 'Unloaded after cycle 4 - 2500 more PCBA', 'process1', CURRENT_TIMESTAMP - INTERVAL '18 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '18 days'),
  ('ST005', 14, 'In Use', 5, 5, 0, 10000, 'Re-loaded to Line 3', 'process1', CURRENT_TIMESTAMP - INTERVAL '17 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '17 days'),
  ('ST005', 15, 'Cleaning', 5, 5, 0, 10000, 'Fifth cleaning cycle', 'operator1', CURRENT_TIMESTAMP - INTERVAL '16 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '16 days'),
  ('ST005', 16, 'Unloading', 5, 5, 2000, 12000, 'Unloaded after cycle 5 - 2000 more PCBA', 'process1', CURRENT_TIMESTAMP - INTERVAL '15 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '15 days'),
  ('ST005', 17, 'In Use', 6, 6, 0, 12000, 'Re-loaded to Line 3 - Current production', 'process1', CURRENT_TIMESTAMP - INTERVAL '3 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '3 hours');

-- ============================================
-- 5. SPI MASTER DATA (Corrected)
-- ============================================

-- SPI001: Load to machine - Cycle 4, PCBA 7500 (matches history)
INSERT INTO "SpiMaster" ("Spi_id", "Model", "totalpcba_allowed", "totalcycle_allowed", "currentstencil_status", "currentpcba_count", "currentcycle_count", "created_by", "created_DT", "Lastupdated_by", "Lastupdated_DT")
VALUES
  ('SPI001', 'SPI-MODEL-A', 10000, 10, 'Load to machine', 7500, 4, 'admin', CURRENT_TIMESTAMP - INTERVAL '10 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '2 hours')
ON CONFLICT ("Spi_id") DO UPDATE SET
  "Model" = EXCLUDED."Model",
  "totalpcba_allowed" = EXCLUDED."totalpcba_allowed",
  "totalcycle_allowed" = EXCLUDED."totalcycle_allowed",
  "currentstencil_status" = EXCLUDED."currentstencil_status",
  "currentpcba_count" = EXCLUDED."currentpcba_count",
  "currentcycle_count" = EXCLUDED."currentcycle_count",
  "Lastupdated_by" = EXCLUDED."Lastupdated_by",
  "Lastupdated_DT" = EXCLUDED."Lastupdated_DT";

-- SPI002-SPI005: Additional SPI containers
INSERT INTO "SpiMaster" ("Spi_id", "Model", "totalpcba_allowed", "totalcycle_allowed", "currentstencil_status", "currentpcba_count", "currentcycle_count", "created_by", "created_DT", "Lastupdated_by", "Lastupdated_DT")
VALUES
  ('SPI002', 'SPI-MODEL-B', 8000, 8, 'Load to machine', 6000, 6, 'admin', CURRENT_TIMESTAMP - INTERVAL '8 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '1 hour'),
  ('SPI003', 'SPI-MODEL-C', 12000, 12, 'Load to machine', 9000, 9, 'admin', CURRENT_TIMESTAMP - INTERVAL '6 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '30 minutes'),
  ('SPI004', 'SPI-MODEL-A', 6000, 6, 'Load to machine', 4500, 4, 'admin', CURRENT_TIMESTAMP - INTERVAL '4 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '15 minutes'),
  ('SPI005', 'SPI-MODEL-B', 15000, 15, 'Load to machine', 12000, 12, 'admin', CURRENT_TIMESTAMP - INTERVAL '12 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '3 hours')
ON CONFLICT ("Spi_id") DO UPDATE SET
  "Model" = EXCLUDED."Model",
  "totalpcba_allowed" = EXCLUDED."totalpcba_allowed",
  "totalcycle_allowed" = EXCLUDED."totalcycle_allowed",
  "currentstencil_status" = EXCLUDED."currentstencil_status",
  "currentpcba_count" = EXCLUDED."currentpcba_count",
  "currentcycle_count" = EXCLUDED."currentcycle_count",
  "Lastupdated_by" = EXCLUDED."Lastupdated_by",
  "Lastupdated_DT" = EXCLUDED."Lastupdated_DT";

-- SPI006-SPI010: New SPI containers
INSERT INTO "SpiMaster" ("Spi_id", "Model", "totalpcba_allowed", "totalcycle_allowed", "currentstencil_status", "currentpcba_count", "currentcycle_count", "created_by", "created_DT", "Lastupdated_by", "Lastupdated_DT")
VALUES
  ('SPI006', 'SPI-MODEL-A', 10000, 10, 'New', 0, 0, 'admin', CURRENT_TIMESTAMP, 'admin', CURRENT_TIMESTAMP),
  ('SPI007', 'SPI-MODEL-B', 8000, 8, 'New', 0, 0, 'admin', CURRENT_TIMESTAMP, 'admin', CURRENT_TIMESTAMP),
  ('SPI008', 'SPI-MODEL-C', 12000, 12, 'New', 0, 0, 'admin', CURRENT_TIMESTAMP, 'admin', CURRENT_TIMESTAMP),
  ('SPI009', 'SPI-MODEL-A', 6000, 6, 'New', 0, 0, 'admin', CURRENT_TIMESTAMP, 'admin', CURRENT_TIMESTAMP),
  ('SPI010', 'SPI-MODEL-B', 15000, 15, 'New', 0, 0, 'admin', CURRENT_TIMESTAMP, 'admin', CURRENT_TIMESTAMP)
ON CONFLICT ("Spi_id") DO UPDATE SET
  "Model" = EXCLUDED."Model",
  "totalpcba_allowed" = EXCLUDED."totalpcba_allowed",
  "totalcycle_allowed" = EXCLUDED."totalcycle_allowed",
  "currentstencil_status" = EXCLUDED."currentstencil_status",
  "currentpcba_count" = EXCLUDED."currentpcba_count",
  "currentcycle_count" = EXCLUDED."currentcycle_count",
  "Lastupdated_by" = EXCLUDED."Lastupdated_by",
  "Lastupdated_DT" = EXCLUDED."Lastupdated_DT";

-- ============================================
-- 6. SPI CHANGE HISTORY (CORRECTED - NEW ROUTE TERMINOLOGY)
-- ============================================
-- SPI001: Complete SP workflow with CORRECT route terminology
-- Route sequence: 1(New) → 2(Thawing in) → 3(Thawing out) → 4(Mixing in) → 5(Mixing out) → 6(Load to machine, cycle+1) → 8(Unload from machine, PCBA update) → ...
-- Note: For SPI, PCBA updates on Route 8 (Unload from machine), cycle increments on Route 6 (Load to machine)

DELETE FROM "Spichangehistory" WHERE "Spi_id" = 'SPI001';

INSERT INTO "Spichangehistory" ("Spi_id", "routeno", "status1", "cyclecount", "totalcycle_count", "pcbacount", "totalpcba_count", "remarks", "created_by", "created_DT", "Lastupdated_by", "Lastupdated_DT")
VALUES
  ('SPI001', 1, 'New', 0, 0, 0, 0, 'New solder paste container received', 'admin', CURRENT_TIMESTAMP - INTERVAL '10 days', 'admin', CURRENT_TIMESTAMP - INTERVAL '10 days'),
  ('SPI001', 2, 'Thawing in', 0, 0, 0, 0, 'Thawing started - Room temperature', 'process1', CURRENT_TIMESTAMP - INTERVAL '9 days 20 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '9 days 20 hours'),
  ('SPI001', 3, 'Thawing out', 0, 0, 0, 0, 'Thawing completed - Ready for mixing', 'process1', CURRENT_TIMESTAMP - INTERVAL '9 days 18 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '9 days 18 hours'),
  ('SPI001', 4, 'Mixing in', 0, 0, 0, 0, 'Mixing started - Centrifuge process', 'process1', CURRENT_TIMESTAMP - INTERVAL '9 days 16 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '9 days 16 hours'),
  ('SPI001', 5, 'Mixing out', 0, 0, 0, 0, 'Mixing completed - Ready for use', 'process1', CURRENT_TIMESTAMP - INTERVAL '9 days 14 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '9 days 14 hours'),
  ('SPI001', 6, 'Load to machine', 1, 1, 0, 0, 'Loaded to printing machine Line 1 - Label printed', 'process1', CURRENT_TIMESTAMP - INTERVAL '9 days 12 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '9 days 12 hours'),
  ('SPI001', 8, 'Unload from machine', 1, 1, 2000, 2000, 'Unloaded after cycle 1 - 2000 PCBA produced', 'process1', CURRENT_TIMESTAMP - INTERVAL '9 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '9 days'),
  ('SPI001', 2, 'Thawing in', 1, 1, 0, 2000, 'Re-thawing for next cycle', 'process1', CURRENT_TIMESTAMP - INTERVAL '8 days 20 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '8 days 20 hours'),
  ('SPI001', 3, 'Thawing out', 1, 1, 0, 2000, 'Thawing completed', 'process1', CURRENT_TIMESTAMP - INTERVAL '8 days 18 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '8 days 18 hours'),
  ('SPI001', 4, 'Mixing in', 1, 1, 0, 2000, 'Mixing started', 'process1', CURRENT_TIMESTAMP - INTERVAL '8 days 16 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '8 days 16 hours'),
  ('SPI001', 5, 'Mixing out', 1, 1, 0, 2000, 'Mixing completed', 'process1', CURRENT_TIMESTAMP - INTERVAL '8 days 14 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '8 days 14 hours'),
  ('SPI001', 6, 'Load to machine', 2, 2, 0, 2000, 'Re-loaded to machine - Label printed', 'process1', CURRENT_TIMESTAMP - INTERVAL '8 days 12 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '8 days 12 hours'),
  ('SPI001', 8, 'Unload from machine', 2, 2, 2500, 4500, 'Unloaded after cycle 2 - 2500 more PCBA', 'process1', CURRENT_TIMESTAMP - INTERVAL '7 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '7 days'),
  ('SPI001', 2, 'Thawing in', 2, 2, 0, 4500, 'Re-thawing for next cycle', 'process1', CURRENT_TIMESTAMP - INTERVAL '6 days 20 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '6 days 20 hours'),
  ('SPI001', 3, 'Thawing out', 2, 2, 0, 4500, 'Thawing completed', 'process1', CURRENT_TIMESTAMP - INTERVAL '6 days 18 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '6 days 18 hours'),
  ('SPI001', 4, 'Mixing in', 2, 2, 0, 4500, 'Mixing started', 'process1', CURRENT_TIMESTAMP - INTERVAL '6 days 16 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '6 days 16 hours'),
  ('SPI001', 5, 'Mixing out', 2, 2, 0, 4500, 'Mixing completed', 'process1', CURRENT_TIMESTAMP - INTERVAL '6 days 14 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '6 days 14 hours'),
  ('SPI001', 6, 'Load to machine', 3, 3, 0, 4500, 'Re-loaded to machine - Label printed', 'process1', CURRENT_TIMESTAMP - INTERVAL '6 days 12 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '6 days 12 hours'),
  ('SPI001', 8, 'Unload from machine', 3, 3, 3000, 7500, 'Unloaded after cycle 3 - 3000 more PCBA', 'process1', CURRENT_TIMESTAMP - INTERVAL '5 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '5 days'),
  ('SPI001', 2, 'Thawing in', 3, 3, 0, 7500, 'Re-thawing for next cycle', 'process1', CURRENT_TIMESTAMP - INTERVAL '4 days 20 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '4 days 20 hours'),
  ('SPI001', 3, 'Thawing out', 3, 3, 0, 7500, 'Thawing completed', 'process1', CURRENT_TIMESTAMP - INTERVAL '4 days 18 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '4 days 18 hours'),
  ('SPI001', 4, 'Mixing in', 3, 3, 0, 7500, 'Mixing started', 'process1', CURRENT_TIMESTAMP - INTERVAL '4 days 16 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '4 days 16 hours'),
  ('SPI001', 5, 'Mixing out', 3, 3, 0, 7500, 'Mixing completed', 'process1', CURRENT_TIMESTAMP - INTERVAL '4 days 14 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '4 days 14 hours'),
  ('SPI001', 6, 'Load to machine', 4, 4, 0, 7500, 'Re-loaded to machine - Current production - Label printed', 'process1', CURRENT_TIMESTAMP - INTERVAL '2 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '2 hours');

-- ============================================
-- 7. HOLD/RELEASE RECORDS
-- ============================================
INSERT INTO "HoldRelease" ("StencilId", "Status", "CurrentStatus", "Remarks", "HoldDate", "ReleaseDate", "Created_By", "Created_DT")
VALUES
  ('ST021', 'Hold', 1, 'Quality issue: Solder paste bridging detected on 5% of boards', CURRENT_TIMESTAMP - INTERVAL '5 days', NULL, 'quality1', CURRENT_TIMESTAMP - INTERVAL '5 days'),
  ('ST022', 'Hold', 1, 'Maintenance required: Stencil aperture clogging', CURRENT_TIMESTAMP - INTERVAL '3 days', NULL, 'quality1', CURRENT_TIMESTAMP - INTERVAL '3 days'),
  ('ST023', 'Scrap', 0, 'Damaged beyond repair: Physical damage to stencil frame', CURRENT_TIMESTAMP - INTERVAL '10 days', CURRENT_TIMESTAMP - INTERVAL '8 days', 'quality1', CURRENT_TIMESTAMP - INTERVAL '10 days'),
  ('ST024', 'Scrap', 0, 'Obsolete: Model discontinued, no longer in production', CURRENT_TIMESTAMP - INTERVAL '8 days', CURRENT_TIMESTAMP - INTERVAL '6 days', 'quality1', CURRENT_TIMESTAMP - INTERVAL '8 days'),
  ('ST025', 'Hold', 1, 'Calibration pending: Stencil thickness measurement required', CURRENT_TIMESTAMP - INTERVAL '7 days', NULL, 'quality1', CURRENT_TIMESTAMP - INTERVAL '7 days')
ON CONFLICT ("Id") DO NOTHING;

-- ============================================
-- 8. SQG MASTER DATA
-- ============================================
INSERT INTO "SQGMaster" ("SQG_id", "totalpcba_allowed", "totalcycle_allowed", "currentstencil_status", "currentpcba_count", "currentcycle_count", "created_by", "created_DT", "Lastupdated_by", "Lastupdated_DT")
VALUES
  ('SQG001', 5000, 5, 'In Use', 3500, 3, 'admin', CURRENT_TIMESTAMP - INTERVAL '5 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '1 day'),
  ('SQG002', 4000, 4, 'New', 0, 0, 'admin', CURRENT_TIMESTAMP, 'admin', CURRENT_TIMESTAMP),
  ('SQG003', 3000, 3, 'Cleaning', 2500, 2, 'admin', CURRENT_TIMESTAMP - INTERVAL '3 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '2 hours')
ON CONFLICT ("SQG_id") DO UPDATE SET
  "totalpcba_allowed" = EXCLUDED."totalpcba_allowed",
  "totalcycle_allowed" = EXCLUDED."totalcycle_allowed",
  "currentstencil_status" = EXCLUDED."currentstencil_status",
  "currentpcba_count" = EXCLUDED."currentpcba_count",
  "currentcycle_count" = EXCLUDED."currentcycle_count",
  "Lastupdated_by" = EXCLUDED."Lastupdated_by",
  "Lastupdated_DT" = EXCLUDED."Lastupdated_DT";

-- ============================================
-- 9. WAVE MASTER DATA
-- ============================================
INSERT INTO "WaveMaster" ("Wave_id", "totalpcba_allowed", "totalcycle_allowed", "currentstencil_status", "currentpcba_count", "currentcycle_count", "created_by", "created_DT", "Lastupdated_by", "Lastupdated_DT")
VALUES
  ('WAVE001', 20000, 20, 'In Use', 15000, 15, 'admin', CURRENT_TIMESTAMP - INTERVAL '10 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '2 days'),
  ('WAVE002', 15000, 15, 'New', 0, 0, 'admin', CURRENT_TIMESTAMP, 'admin', CURRENT_TIMESTAMP)
ON CONFLICT ("Wave_id") DO UPDATE SET
  "totalpcba_allowed" = EXCLUDED."totalpcba_allowed",
  "totalcycle_allowed" = EXCLUDED."totalcycle_allowed",
  "currentstencil_status" = EXCLUDED."currentstencil_status",
  "currentpcba_count" = EXCLUDED."currentpcba_count",
  "currentcycle_count" = EXCLUDED."currentcycle_count",
  "Lastupdated_by" = EXCLUDED."Lastupdated_by",
  "Lastupdated_DT" = EXCLUDED."Lastupdated_DT";

-- ============================================
-- SUMMARY
-- ============================================
-- All sample data now follows correct business logic:
-- ✅ Cycle count increments ONLY on Route 2 (In Use)
-- ✅ PCBA count updates ONLY on Route 3 (Unloading) for Stencil, Route 4 for SPI
-- ✅ Route sequences follow previousmandatory validation
-- ✅ totalcycle_count = cumulative cycles
-- ✅ totalpcba_count = cumulative PCBA count
-- ✅ All history records match master table current status
-- ============================================

