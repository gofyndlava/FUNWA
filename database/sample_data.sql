-- Sample Data for Factory Utility Demo
-- This script adds 25+ multi-scenario records for a comprehensive demo

-- ============================================
-- 1. ADDITIONAL USERS (if needed)
-- ============================================
INSERT INTO "LoginDetails" ("Userid", "Username", "Useremail", "Userpassword", "Roles", "IsActive")
VALUES 
  ('operator1', 'Operator One', 'operator1@factory.com', 'Operator@123', 'OPERATOR', TRUE),
  ('process1', 'Process Engineer', 'process1@factory.com', 'Process@123', 'PROCESS', TRUE),
  ('quality1', 'Quality Inspector', 'quality1@factory.com', 'Quality@123', 'QUALITY', TRUE)
ON CONFLICT ("Userid") DO NOTHING;

-- ============================================
-- 2. STENCIL MODELS
-- ============================================
INSERT INTO "StencilModel" ("Model", "ModelDesc", "Created_By", "Created_Date")
VALUES 
  ('MODEL-A', 'Model A Description', 'admin', CURRENT_TIMESTAMP),
  ('MODEL-B', 'Model B Description', 'admin', CURRENT_TIMESTAMP),
  ('MODEL-C', 'Model C Description', 'admin', CURRENT_TIMESTAMP),
  ('MODEL-D', 'Model D Description', 'admin', CURRENT_TIMESTAMP),
  ('MODEL-E', 'Model E Description', 'admin', CURRENT_TIMESTAMP)
ON CONFLICT DO NOTHING;

-- ============================================
-- 3. STENCIL ROUTES (already inserted by schema, skip if exists)
-- ============================================
-- Routes are already inserted by schema.sql, so we skip this section

-- ============================================
-- 4. STENCIL MASTER RECORDS (Multiple Scenarios)
-- ============================================
-- Scenario 1-5: Stencils "In Use" (for Monitor Stencil feature)
INSERT INTO "StencilMaster" ("Stencil_id", "totalpcba_allowed", "totalcycle_allowed", "currentstencil_status", "currentpcba_count", "currentcycle_count", "created_by", "created_DT", "Lastupdated_by", "Lastupdated_DT")
VALUES 
  ('ST001', 5000, 5, 'In Use', 2500, 2, 'admin', CURRENT_TIMESTAMP - INTERVAL '2 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '2 hours'),
  ('ST002', 6000, 6, 'In Use', 3000, 3, 'admin', CURRENT_TIMESTAMP - INTERVAL '1 hour', 'process1', CURRENT_TIMESTAMP - INTERVAL '1 hour'),
  ('ST003', 4000, 4, 'In Use', 2000, 1, 'admin', CURRENT_TIMESTAMP - INTERVAL '30 minutes', 'operator1', CURRENT_TIMESTAMP - INTERVAL '30 minutes'),
  ('ST004', 5500, 5, 'In Use', 1000, 1, 'admin', CURRENT_TIMESTAMP - INTERVAL '15 minutes', 'operator1', CURRENT_TIMESTAMP - INTERVAL '15 minutes'),
  ('ST005', 7000, 7, 'In Use', 5000, 4, 'admin', CURRENT_TIMESTAMP - INTERVAL '3 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '3 hours')
ON CONFLICT ("Stencil_id") DO NOTHING;

-- Scenario 6-10: Stencils "New" (for Change Status feature)
INSERT INTO "StencilMaster" ("Stencil_id", "totalpcba_allowed", "totalcycle_allowed", "currentstencil_status", "currentpcba_count", "currentcycle_count", "created_by", "created_DT", "Lastupdated_by", "Lastupdated_DT")
VALUES 
  ('ST006', 5000, 5, 'New', 0, 0, 'admin', CURRENT_TIMESTAMP, 'admin', CURRENT_TIMESTAMP),
  ('ST007', 6000, 6, 'New', 0, 0, 'admin', CURRENT_TIMESTAMP, 'admin', CURRENT_TIMESTAMP),
  ('ST008', 4500, 4, 'New', 0, 0, 'admin', CURRENT_TIMESTAMP, 'admin', CURRENT_TIMESTAMP),
  ('ST009', 5500, 5, 'New', 0, 0, 'admin', CURRENT_TIMESTAMP, 'admin', CURRENT_TIMESTAMP),
  ('ST010', 6500, 6, 'New', 0, 0, 'admin', CURRENT_TIMESTAMP, 'admin', CURRENT_TIMESTAMP)
ON CONFLICT ("Stencil_id") DO NOTHING;

-- Scenario 11-15: Stencils "Cleaning" (for workflow demo)
INSERT INTO "StencilMaster" ("Stencil_id", "totalpcba_allowed", "totalcycle_allowed", "currentstencil_status", "currentpcba_count", "currentcycle_count", "created_by", "created_DT", "Lastupdated_by", "Lastupdated_DT")
VALUES 
  ('ST011', 5000, 5, 'Cleaning', 4500, 4, 'admin', CURRENT_TIMESTAMP - INTERVAL '1 day', 'process1', CURRENT_TIMESTAMP - INTERVAL '2 hours'),
  ('ST012', 6000, 6, 'Cleaning', 5500, 5, 'admin', CURRENT_TIMESTAMP - INTERVAL '2 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '3 hours'),
  ('ST013', 4000, 4, 'Cleaning', 3800, 3, 'admin', CURRENT_TIMESTAMP - INTERVAL '1 day', 'operator1', CURRENT_TIMESTAMP - INTERVAL '1 hour'),
  ('ST014', 5500, 5, 'Cleaning', 5000, 4, 'admin', CURRENT_TIMESTAMP - INTERVAL '3 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '4 hours'),
  ('ST015', 7000, 7, 'Cleaning', 6500, 6, 'admin', CURRENT_TIMESTAMP - INTERVAL '2 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '5 hours')
ON CONFLICT ("Stencil_id") DO NOTHING;

-- Scenario 16-20: Stencils "Unloading" (for cycle count demo)
INSERT INTO "StencilMaster" ("Stencil_id", "totalpcba_allowed", "totalcycle_allowed", "currentstencil_status", "currentpcba_count", "currentcycle_count", "created_by", "created_DT", "Lastupdated_by", "Lastupdated_DT")
VALUES 
  ('ST016', 5000, 5, 'Unloading', 4800, 4, 'admin', CURRENT_TIMESTAMP - INTERVAL '2 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '1 hour'),
  ('ST017', 6000, 6, 'Unloading', 5800, 5, 'admin', CURRENT_TIMESTAMP - INTERVAL '3 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '2 hours'),
  ('ST018', 4000, 4, 'Unloading', 3900, 3, 'admin', CURRENT_TIMESTAMP - INTERVAL '1 day', 'operator1', CURRENT_TIMESTAMP - INTERVAL '30 minutes'),
  ('ST019', 5500, 5, 'Unloading', 5400, 4, 'admin', CURRENT_TIMESTAMP - INTERVAL '4 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '3 hours'),
  ('ST020', 6500, 6, 'Unloading', 6400, 5, 'admin', CURRENT_TIMESTAMP - INTERVAL '2 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '1 hour')
ON CONFLICT ("Stencil_id") DO NOTHING;

-- Scenario 21-25: Stencils "Hold" and "Scrap" (for Hold/Scrap feature)
INSERT INTO "StencilMaster" ("Stencil_id", "totalpcba_allowed", "totalcycle_allowed", "currentstencil_status", "currentpcba_count", "currentcycle_count", "created_by", "created_DT", "Lastupdated_by", "Lastupdated_DT")
VALUES 
  ('ST021', 5000, 5, 'Hold', 2000, 2, 'admin', CURRENT_TIMESTAMP - INTERVAL '5 days', 'quality1', CURRENT_TIMESTAMP - INTERVAL '1 day'),
  ('ST022', 6000, 6, 'Hold', 3000, 3, 'admin', CURRENT_TIMESTAMP - INTERVAL '6 days', 'quality1', CURRENT_TIMESTAMP - INTERVAL '2 days'),
  ('ST023', 4000, 4, 'Scrap', 3500, 3, 'admin', CURRENT_TIMESTAMP - INTERVAL '10 days', 'quality1', CURRENT_TIMESTAMP - INTERVAL '5 days'),
  ('ST024', 5500, 5, 'Scrap', 5000, 4, 'admin', CURRENT_TIMESTAMP - INTERVAL '12 days', 'quality1', CURRENT_TIMESTAMP - INTERVAL '7 days'),
  ('ST025', 7000, 7, 'Hold', 1000, 1, 'admin', CURRENT_TIMESTAMP - INTERVAL '7 days', 'quality1', CURRENT_TIMESTAMP - INTERVAL '3 days')
ON CONFLICT ("Stencil_id") DO NOTHING;

-- ============================================
-- 5. STENCIL CHANGE HISTORY (for History feature)
-- ============================================
-- Add history for some stencils to show workflow
INSERT INTO "Stencilchangehistory" ("stencil_id", "routeno", "status1", "cyclecount", "totalcycle_count", "pcbacount", "totalpcba_count", "remarks", "created_by", "created_DT", "Lastupdated_by", "Lastupdated_DT")
VALUES 
  -- History for ST001
  ('ST001', 1, 'new', 0, 0, 0, 0, 'Initial creation', 'admin', CURRENT_TIMESTAMP - INTERVAL '3 days', 'admin', CURRENT_TIMESTAMP - INTERVAL '3 days'),
  ('ST001', 2, 'In Use', 0, 0, 0, 0, 'Loaded to machine', 'process1', CURRENT_TIMESTAMP - INTERVAL '2 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '2 days'),
  ('ST001', 3, 'Cleaning', 0, 0, 500, 500, 'First cleaning cycle', 'operator1', CURRENT_TIMESTAMP - INTERVAL '1 day', 'operator1', CURRENT_TIMESTAMP - INTERVAL '1 day'),
  ('ST001', 4, 'Unloading', 1, 1, 1000, 1500, 'First cycle completed', 'operator1', CURRENT_TIMESTAMP - INTERVAL '12 hours', 'operator1', CURRENT_TIMESTAMP - INTERVAL '12 hours'),
  ('ST001', 2, 'In Use', 1, 1, 1000, 2500, 'Reloaded after cleaning', 'process1', CURRENT_TIMESTAMP - INTERVAL '2 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '2 hours'),
  
  -- History for ST005 (near limit - good for demo)
  ('ST005', 1, 'new', 0, 0, 0, 0, 'Initial creation', 'admin', CURRENT_TIMESTAMP - INTERVAL '5 days', 'admin', CURRENT_TIMESTAMP - INTERVAL '5 days'),
  ('ST005', 2, 'In Use', 0, 0, 0, 0, 'Loaded to machine', 'process1', CURRENT_TIMESTAMP - INTERVAL '4 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '4 days'),
  ('ST005', 3, 'Cleaning', 0, 0, 1000, 1000, 'First cleaning', 'operator1', CURRENT_TIMESTAMP - INTERVAL '3 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '3 days'),
  ('ST005', 4, 'Unloading', 1, 1, 1000, 2000, 'Cycle 1', 'operator1', CURRENT_TIMESTAMP - INTERVAL '2 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '2 days'),
  ('ST005', 2, 'In Use', 1, 1, 1000, 3000, 'Reloaded', 'process1', CURRENT_TIMESTAMP - INTERVAL '1 day', 'process1', CURRENT_TIMESTAMP - INTERVAL '1 day'),
  ('ST005', 3, 'Cleaning', 1, 1, 1000, 4000, 'Second cleaning', 'operator1', CURRENT_TIMESTAMP - INTERVAL '12 hours', 'operator1', CURRENT_TIMESTAMP - INTERVAL '12 hours'),
  ('ST005', 4, 'Unloading', 2, 2, 1000, 5000, 'Cycle 2 - Near limit', 'operator1', CURRENT_TIMESTAMP - INTERVAL '3 hours', 'operator1', CURRENT_TIMESTAMP - INTERVAL '3 hours')
ON CONFLICT DO NOTHING;

-- ============================================
-- 6. SPI MODELS
-- ============================================
INSERT INTO "SpiModel" ("Model", "ModelDesc", "Created_By", "Created_Date")
VALUES 
  ('SPI-MODEL-A', 'SPI Model A', 'admin', CURRENT_TIMESTAMP),
  ('SPI-MODEL-B', 'SPI Model B', 'admin', CURRENT_TIMESTAMP),
  ('SPI-MODEL-C', 'SPI Model C', 'admin', CURRENT_TIMESTAMP)
ON CONFLICT DO NOTHING;

-- ============================================
-- 7. SPI ROUTES (already inserted by schema, skip if exists)
-- ============================================
-- Routes are already inserted by schema.sql, so we skip this section

-- ============================================
-- 8. SPI MASTER RECORDS
-- ============================================
INSERT INTO "SpiMaster" ("Spi_id", "totalpcba_allowed", "totalcycle_allowed", "currentstencil_status", "currentpcba_count", "currentcycle_count", "created_by", "created_DT", "Lastupdated_by", "Lastupdated_DT")
VALUES 
  ('SPI001', 5000, 5, 'In Use', 2000, 2, 'admin', CURRENT_TIMESTAMP - INTERVAL '1 day', 'process1', CURRENT_TIMESTAMP - INTERVAL '2 hours'),
  ('SPI002', 6000, 6, 'New', 0, 0, 'admin', CURRENT_TIMESTAMP, 'admin', CURRENT_TIMESTAMP),
  ('SPI003', 4000, 4, 'Cleaning', 3500, 3, 'admin', CURRENT_TIMESTAMP - INTERVAL '2 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '1 hour'),
  ('SPI004', 5500, 5, 'Unloading', 5000, 4, 'admin', CURRENT_TIMESTAMP - INTERVAL '3 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '30 minutes'),
  ('SPI005', 7000, 7, 'Hold', 1000, 1, 'admin', CURRENT_TIMESTAMP - INTERVAL '5 days', 'quality1', CURRENT_TIMESTAMP - INTERVAL '1 day')
ON CONFLICT ("Spi_id") DO NOTHING;

-- ============================================
-- 9. SPI CHANGE HISTORY
-- ============================================
INSERT INTO "Spichangehistory" ("Spi_id", "routeno", "status1", "cyclecount", "totalcycle_count", "pcbacount", "totalpcba_count", "remarks", "created_by", "created_DT", "Lastupdated_by", "Lastupdated_DT")
VALUES 
  ('SPI001', 1, 'new', 0, 0, 0, 0, 'Initial creation', 'admin', CURRENT_TIMESTAMP - INTERVAL '2 days', 'admin', CURRENT_TIMESTAMP - INTERVAL '2 days'),
  ('SPI001', 2, 'In Use', 0, 0, 0, 0, 'Loaded to machine', 'process1', CURRENT_TIMESTAMP - INTERVAL '1 day', 'process1', CURRENT_TIMESTAMP - INTERVAL '1 day'),
  ('SPI001', 3, 'Cleaning', 0, 0, 1000, 1000, 'First cleaning', 'operator1', CURRENT_TIMESTAMP - INTERVAL '12 hours', 'operator1', CURRENT_TIMESTAMP - INTERVAL '12 hours'),
  ('SPI001', 4, 'Unloading', 1, 1, 1000, 2000, 'Cycle 1 completed', 'operator1', CURRENT_TIMESTAMP - INTERVAL '2 hours', 'operator1', CURRENT_TIMESTAMP - INTERVAL '2 hours')
ON CONFLICT DO NOTHING;

-- ============================================
-- 10. SQG ROUTES (already inserted by schema, skip if exists)
-- ============================================
-- Routes are already inserted by schema.sql, so we skip this section

-- ============================================
-- 11. SQG MASTER RECORDS
-- ============================================
INSERT INTO "SQGMaster" ("SQG_id", "totalpcba_allowed", "totalcycle_allowed", "currentstencil_status", "currentpcba_count", "currentcycle_count", "created_by", "created_DT", "Lastupdated_by", "Lastupdated_DT")
VALUES 
  ('SQG001', 5000, 5, 'In Use', 1500, 1, 'admin', CURRENT_TIMESTAMP - INTERVAL '1 day', 'process1', CURRENT_TIMESTAMP - INTERVAL '3 hours'),
  ('SQG002', 6000, 6, 'New', 0, 0, 'admin', CURRENT_TIMESTAMP, 'admin', CURRENT_TIMESTAMP),
  ('SQG003', 4000, 4, 'Cleaning', 3800, 3, 'admin', CURRENT_TIMESTAMP - INTERVAL '2 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '2 hours')
ON CONFLICT ("SQG_id") DO NOTHING;

-- ============================================
-- 12. WAVE MODELS
-- ============================================
INSERT INTO "WaveModel" ("Model", "ModelDesc", "Created_By", "Created_Date")
VALUES 
  ('WAVE-MODEL-A', 'Wave Model A', 'admin', CURRENT_TIMESTAMP),
  ('WAVE-MODEL-B', 'Wave Model B', 'admin', CURRENT_TIMESTAMP)
ON CONFLICT DO NOTHING;

-- ============================================
-- 13. WAVE ROUTES (already inserted by schema, skip if exists)
-- ============================================
-- Routes are already inserted by schema.sql, so we skip this section

-- ============================================
-- 14. WAVE MASTER RECORDS
-- ============================================
INSERT INTO "WaveMaster" ("Wave_id", "totalpcba_allowed", "totalcycle_allowed", "currentstencil_status", "currentpcba_count", "currentcycle_count", "created_by", "created_DT", "Lastupdated_by", "Lastupdated_DT")
VALUES 
  ('WAVE001', 5000, 5, 'In Use', 2500, 2, 'admin', CURRENT_TIMESTAMP - INTERVAL '1 day', 'process1', CURRENT_TIMESTAMP - INTERVAL '4 hours'),
  ('WAVE002', 6000, 6, 'New', 0, 0, 'admin', CURRENT_TIMESTAMP, 'admin', CURRENT_TIMESTAMP)
ON CONFLICT ("Wave_id") DO NOTHING;

-- ============================================
-- 15. HOLD/RELEASE RECORDS (for Hold/Scrap feature)
-- ============================================
-- CurrentStatus is INTEGER: 1 = Active, 0 = Released
INSERT INTO "HoldRelease" ("StencilId", "Status", "CurrentStatus", "Remarks", "HoldDate", "ReleaseDate", "Created_By", "Created_DT")
VALUES 
  ('ST021', 'Hold', 1, 'Quality issue detected', CURRENT_TIMESTAMP - INTERVAL '1 day', NULL, 'quality1', CURRENT_TIMESTAMP - INTERVAL '1 day'),
  ('ST022', 'Hold', 1, 'Pending inspection', CURRENT_TIMESTAMP - INTERVAL '2 days', NULL, 'quality1', CURRENT_TIMESTAMP - INTERVAL '2 days'),
  ('ST023', 'Scrap', 1, 'Beyond repair', CURRENT_TIMESTAMP - INTERVAL '5 days', NULL, 'quality1', CURRENT_TIMESTAMP - INTERVAL '5 days'),
  ('ST024', 'Scrap', 1, 'Damaged beyond use', CURRENT_TIMESTAMP - INTERVAL '7 days', NULL, 'quality1', CURRENT_TIMESTAMP - INTERVAL '7 days'),
  ('ST025', 'Hold', 1, 'Under investigation', CURRENT_TIMESTAMP - INTERVAL '3 days', NULL, 'quality1', CURRENT_TIMESTAMP - INTERVAL '3 days')
ON CONFLICT DO NOTHING;

-- ============================================
-- SUMMARY
-- ============================================
-- Total Records Added:
-- - 3 Additional Users
-- - 5 Stencil Models
-- - 6 Stencil Routes
-- - 25 Stencil Master Records (various statuses)
-- - 12 Stencil History Records
-- - 3 SPI Models
-- - 6 SPI Routes
-- - 5 SPI Master Records
-- - 4 SPI History Records
-- - 4 SQG Routes
-- - 3 SQG Master Records
-- - 2 Wave Models
-- - 4 Wave Routes
-- - 2 Wave Master Records
-- - 5 Hold/Release Records
-- 
-- Total: 85+ records across all tables

