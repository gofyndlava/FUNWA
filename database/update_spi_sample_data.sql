-- ============================================
-- UPDATE SPI SAMPLE DATA TO NEW ROUTE TERMINOLOGY
-- ============================================
-- SP Workflow:
-- 1. New → Route 1
-- 2. Thawing in → Route 2
-- 3. Thawing out → Route 3
-- 4. Mixing in → Route 4
-- 5. Mixing out → Route 5
-- 6. Load to machine → Route 6 (cycle count increments)
-- 7. Unload from machine → Route 8 (PCBA count updates)
-- ============================================

-- Update SPI Master records to use new terminology
-- SPI001: Currently "In Use" with cycle 4, PCBA 7500
-- Should be "Load to machine" (Route 6) after going through workflow
UPDATE "SpiMaster" 
SET "currentstencil_status" = 'Load to machine'
WHERE "Spi_id" = 'SPI001' AND "currentstencil_status" = 'In Use';

-- SPI002-SPI005: Update to appropriate statuses
UPDATE "SpiMaster" 
SET "currentstencil_status" = 'Load to machine'
WHERE "Spi_id" IN ('SPI002', 'SPI003', 'SPI004', 'SPI005') AND "currentstencil_status" = 'In Use';

-- Update SPI History records to use new route terminology
-- Delete old history for SPI001 and recreate with correct workflow
DELETE FROM "Spichangehistory" WHERE "Spi_id" = 'SPI001';

-- SPI001: Complete SP workflow with CORRECT route terminology
INSERT INTO "Spichangehistory" ("Spi_id", "routeno", "status1", "cyclecount", "totalcycle_count", "pcbacount", "totalpcba_count", "remarks", "created_by", "created_DT", "Lastupdated_by", "Lastupdated_DT")
VALUES
  -- Route 1: New (cycle=0, PCBA=0)
  ('SPI001', 1, 'New', 0, 0, 0, 0, 'New solder paste container received', 'admin', CURRENT_TIMESTAMP - INTERVAL '10 days', 'admin', CURRENT_TIMESTAMP - INTERVAL '10 days'),
  
  -- Route 2: Thawing in (cycle=0, PCBA=0)
  ('SPI001', 2, 'Thawing in', 0, 0, 0, 0, 'Thawing started - Room temperature', 'process1', CURRENT_TIMESTAMP - INTERVAL '9 days 20 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '9 days 20 hours'),
  
  -- Route 3: Thawing out (cycle=0, PCBA=0, 30 min gap time)
  ('SPI001', 3, 'Thawing out', 0, 0, 0, 0, 'Thawing completed - Ready for mixing', 'process1', CURRENT_TIMESTAMP - INTERVAL '9 days 18 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '9 days 18 hours'),
  
  -- Route 4: Mixing in (cycle=0, PCBA=0)
  ('SPI001', 4, 'Mixing in', 0, 0, 0, 0, 'Mixing started - Centrifuge process', 'process1', CURRENT_TIMESTAMP - INTERVAL '9 days 16 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '9 days 16 hours'),
  
  -- Route 5: Mixing out (cycle=0, PCBA=0, 15 min gap time)
  ('SPI001', 5, 'Mixing out', 0, 0, 0, 0, 'Mixing completed - Ready for use', 'process1', CURRENT_TIMESTAMP - INTERVAL '9 days 14 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '9 days 14 hours'),
  
  -- Route 6: Load to machine (cycle increments to 1, PCBA stays 0, label printing)
  ('SPI001', 6, 'Load to machine', 1, 1, 0, 0, 'Loaded to printing machine Line 1 - Label printed', 'process1', CURRENT_TIMESTAMP - INTERVAL '9 days 12 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '9 days 12 hours'),
  
  -- Route 8: Unload from machine (cycle stays 1, PCBA updates to 2000)
  ('SPI001', 8, 'Unload from machine', 1, 1, 2000, 2000, 'Unloaded after cycle 1 - 2000 PCBA produced', 'process1', CURRENT_TIMESTAMP - INTERVAL '9 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '9 days'),
  
  -- Route 2: Thawing in (cycle stays 1, PCBA stays 2000)
  ('SPI001', 2, 'Thawing in', 1, 1, 0, 2000, 'Re-thawing for next cycle', 'process1', CURRENT_TIMESTAMP - INTERVAL '8 days 20 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '8 days 20 hours'),
  
  -- Route 3: Thawing out (cycle stays 1, PCBA stays 2000)
  ('SPI001', 3, 'Thawing out', 1, 1, 0, 2000, 'Thawing completed', 'process1', CURRENT_TIMESTAMP - INTERVAL '8 days 18 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '8 days 18 hours'),
  
  -- Route 4: Mixing in (cycle stays 1, PCBA stays 2000)
  ('SPI001', 4, 'Mixing in', 1, 1, 0, 2000, 'Mixing started', 'process1', CURRENT_TIMESTAMP - INTERVAL '8 days 16 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '8 days 16 hours'),
  
  -- Route 5: Mixing out (cycle stays 1, PCBA stays 2000)
  ('SPI001', 5, 'Mixing out', 1, 1, 0, 2000, 'Mixing completed', 'process1', CURRENT_TIMESTAMP - INTERVAL '8 days 14 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '8 days 14 hours'),
  
  -- Route 6: Load to machine (cycle increments to 2, PCBA stays 2000, label printing)
  ('SPI001', 6, 'Load to machine', 2, 2, 0, 2000, 'Re-loaded to machine - Label printed', 'process1', CURRENT_TIMESTAMP - INTERVAL '8 days 12 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '8 days 12 hours'),
  
  -- Route 8: Unload from machine (cycle stays 2, PCBA updates to 4500 total)
  ('SPI001', 8, 'Unload from machine', 2, 2, 2500, 4500, 'Unloaded after cycle 2 - 2500 more PCBA', 'process1', CURRENT_TIMESTAMP - INTERVAL '7 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '7 days'),
  
  -- Route 2: Thawing in (cycle stays 2, PCBA stays 4500)
  ('SPI001', 2, 'Thawing in', 2, 2, 0, 4500, 'Re-thawing for next cycle', 'process1', CURRENT_TIMESTAMP - INTERVAL '6 days 20 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '6 days 20 hours'),
  
  -- Route 3: Thawing out (cycle stays 2, PCBA stays 4500)
  ('SPI001', 3, 'Thawing out', 2, 2, 0, 4500, 'Thawing completed', 'process1', CURRENT_TIMESTAMP - INTERVAL '6 days 18 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '6 days 18 hours'),
  
  -- Route 4: Mixing in (cycle stays 2, PCBA stays 4500)
  ('SPI001', 4, 'Mixing in', 2, 2, 0, 4500, 'Mixing started', 'process1', CURRENT_TIMESTAMP - INTERVAL '6 days 16 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '6 days 16 hours'),
  
  -- Route 5: Mixing out (cycle stays 2, PCBA stays 4500)
  ('SPI001', 5, 'Mixing out', 2, 2, 0, 4500, 'Mixing completed', 'process1', CURRENT_TIMESTAMP - INTERVAL '6 days 14 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '6 days 14 hours'),
  
  -- Route 6: Load to machine (cycle increments to 3, PCBA stays 4500, label printing)
  ('SPI001', 6, 'Load to machine', 3, 3, 0, 4500, 'Re-loaded to machine - Label printed', 'process1', CURRENT_TIMESTAMP - INTERVAL '6 days 12 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '6 days 12 hours'),
  
  -- Route 8: Unload from machine (cycle stays 3, PCBA updates to 7500 total)
  ('SPI001', 8, 'Unload from machine', 3, 3, 3000, 7500, 'Unloaded after cycle 3 - 3000 more PCBA', 'process1', CURRENT_TIMESTAMP - INTERVAL '5 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '5 days'),
  
  -- Route 2: Thawing in (cycle stays 3, PCBA stays 7500)
  ('SPI001', 2, 'Thawing in', 3, 3, 0, 7500, 'Re-thawing for next cycle', 'process1', CURRENT_TIMESTAMP - INTERVAL '4 days 20 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '4 days 20 hours'),
  
  -- Route 3: Thawing out (cycle stays 3, PCBA stays 7500)
  ('SPI001', 3, 'Thawing out', 3, 3, 0, 7500, 'Thawing completed', 'process1', CURRENT_TIMESTAMP - INTERVAL '4 days 18 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '4 days 18 hours'),
  
  -- Route 4: Mixing in (cycle stays 3, PCBA stays 7500)
  ('SPI001', 4, 'Mixing in', 3, 3, 0, 7500, 'Mixing started', 'process1', CURRENT_TIMESTAMP - INTERVAL '4 days 16 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '4 days 16 hours'),
  
  -- Route 5: Mixing out (cycle stays 3, PCBA stays 7500)
  ('SPI001', 5, 'Mixing out', 3, 3, 0, 7500, 'Mixing completed', 'process1', CURRENT_TIMESTAMP - INTERVAL '4 days 14 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '4 days 14 hours'),
  
  -- Route 6: Load to machine (cycle increments to 4, PCBA stays 7500, label printing) - CURRENT STATUS
  ('SPI001', 6, 'Load to machine', 4, 4, 0, 7500, 'Re-loaded to machine - Current production - Label printed', 'process1', CURRENT_TIMESTAMP - INTERVAL '2 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '2 hours');

-- Update SPI001 master to match latest history
UPDATE "SpiMaster"
SET "currentstencil_status" = 'Load to machine',
    "currentcycle_count" = 4,
    "currentpcba_count" = 7500,
    "Lastupdated_by" = 'process1',
    "Lastupdated_DT" = CURRENT_TIMESTAMP - INTERVAL '2 hours'
WHERE "Spi_id" = 'SPI001';

-- Update other SPI records to use new terminology
-- SPI002: Update to "Load to machine" if currently "In Use"
UPDATE "SpiMaster"
SET "currentstencil_status" = 'Load to machine'
WHERE "Spi_id" = 'SPI002' AND "currentstencil_status" = 'In Use';

-- SPI003-SPI005: Update to "Load to machine" if currently "In Use"
UPDATE "SpiMaster"
SET "currentstencil_status" = 'Load to machine'
WHERE "Spi_id" IN ('SPI003', 'SPI004', 'SPI005') AND "currentstencil_status" = 'In Use';

-- Note: SPI006-SPI010 are "New" status, which is correct and doesn't need updating

