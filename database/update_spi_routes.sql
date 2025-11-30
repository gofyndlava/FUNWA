-- ============================================
-- UPDATE SPI ROUTES TO CORRECT TERMINOLOGY
-- ============================================
-- SP Workflow:
-- 1. New → Route 1
-- 2. Thawing in → Route 2
-- 3. Thawing out → Route 3
-- 4. Mixing in → Route 4
-- 5. Mixing out → Route 5
-- 6. Load to machine → Route 6 (label printing, cycle count increments)
-- 7. Unload from machine → Route 8 (PCBA count updated)
-- ============================================

-- Delete old routes
DELETE FROM "SpiRoute";

-- Insert correct SPI routes
INSERT INTO "SpiRoute" ("routeno", "routedescription", "previousmandatory", "roles", "gaptime")
VALUES
  (1, 'New', 0, 'ADMIN,PROCESS', 0),
  (2, 'Thawing in', 1, 'PROCESS,OPERATOR', 0),
  (3, 'Thawing out', 2, 'PROCESS,OPERATOR', 30),  -- 30 minutes gap time for thawing
  (4, 'Mixing in', 3, 'PROCESS,OPERATOR', 0),
  (5, 'Mixing out', 4, 'PROCESS,OPERATOR', 15),  -- 15 minutes gap time for mixing
  (6, 'Load to machine', 5, 'PROCESS,OPERATOR', 0),  -- Cycle count increments here, label printing
  (8, 'Unload from machine', 6, 'PROCESS,OPERATOR', 0),  -- PCBA count updates here
  (9, 'Hold', 0, 'ADMIN,QUALITY', 0),
  (10, 'Scrap', 0, 'ADMIN,QUALITY', 0);

-- Note: Route 7 is skipped (not used in workflow)
-- Hold (9) and Scrap (10) can be accessed from any route (previousmandatory = 0)

