-- ============================================
-- COMPREHENSIVE SMT LINE SAMPLE DATA
-- Realistic scenarios for Solder Paste Printing Machine Operations
-- ============================================

-- ============================================
-- 1. STENCIL MODELS (Product Types)
-- ============================================
INSERT INTO "StencilModel" ("Model", "ModelDesc", "Created_By", "Created_Date")
VALUES 
  ('MODEL-A', 'High-Density PCB - 0.4mm pitch BGA', 'admin', CURRENT_TIMESTAMP),
  ('MODEL-B', 'Standard PCB - 0.5mm pitch QFN', 'admin', CURRENT_TIMESTAMP),
  ('MODEL-C', 'Low-Profile PCB - 0.3mm pitch CSP', 'admin', CURRENT_TIMESTAMP),
  ('MODEL-D', 'Mixed Technology - Through-hole + SMT', 'admin', CURRENT_TIMESTAMP),
  ('MODEL-E', 'RF PCB - Controlled Impedance', 'admin', CURRENT_TIMESTAMP),
  ('MODEL-F', 'Power PCB - High Current Traces', 'admin', CURRENT_TIMESTAMP),
  ('MODEL-G', 'LED Board - Large Pad Design', 'admin', CURRENT_TIMESTAMP)
ON CONFLICT ("Model") DO NOTHING;

-- ============================================
-- 2. SPI MODELS (Solder Paste Types)
-- ============================================
INSERT INTO "SpiModel" ("Model", "ModelDesc", "Created_By", "Created_Date")
VALUES
  ('SPI-MODEL-A', 'SAC305 - Lead-Free, Type 3, 25-45μm', 'admin', CURRENT_TIMESTAMP),
  ('SPI-MODEL-B', 'SAC305 - Lead-Free, Type 4, 20-38μm', 'admin', CURRENT_TIMESTAMP),
  ('SPI-MODEL-C', 'SAC305 - Lead-Free, Type 5, 15-25μm', 'admin', CURRENT_TIMESTAMP),
  ('SPI-MODEL-D', 'Sn63Pb37 - Eutectic, Type 3', 'admin', CURRENT_TIMESTAMP),
  ('SPI-MODEL-E', 'Low-Temp Solder - Type 4', 'admin', CURRENT_TIMESTAMP)
ON CONFLICT ("Model") DO NOTHING;

-- ============================================
-- 3. STENCIL ROUTES (Workflow Statuses)
-- ============================================
-- Routes already exist in schema, but ensure they're correct
-- 1: New, 2: In Use, 3: Cleaning, 4: Unloading, 5: Hold, 6: Scrap

-- ============================================
-- 4. SPI ROUTES (Solder Paste Workflow)
-- ============================================
-- Routes already exist in schema
-- 1: New, 2: Thawing In, 3: Thawing Out, 4: Mixing In, 5: Mixing Out, 6: Load to Machine, 7: Unload from Machine

-- ============================================
-- 5. COMPREHENSIVE STENCIL MASTER DATA
-- ============================================

-- Production Line 1: Active Stencils (In Use) - 10 stencils
INSERT INTO "StencilMaster" ("Stencil_id", "totalpcba_allowed", "totalcycle_allowed", "currentstencil_status", "currentpcba_count", "currentcycle_count", "created_by", "created_DT", "Lastupdated_by", "Lastupdated_DT", "Model")
VALUES 
  -- High-volume production stencils
  ('ST001', 10000, 10, 'In Use', 7500, 7, 'admin', CURRENT_TIMESTAMP - INTERVAL '2 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '2 hours', 'MODEL-A'),
  ('ST002', 8000, 8, 'In Use', 6000, 6, 'admin', CURRENT_TIMESTAMP - INTERVAL '3 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '1 hour', 'MODEL-B'),
  ('ST003', 12000, 12, 'In Use', 9000, 9, 'admin', CURRENT_TIMESTAMP - INTERVAL '1 day', 'operator1', CURRENT_TIMESTAMP - INTERVAL '30 minutes', 'MODEL-C'),
  ('ST004', 6000, 6, 'In Use', 4500, 4, 'admin', CURRENT_TIMESTAMP - INTERVAL '4 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '15 minutes', 'MODEL-D'),
  ('ST005', 15000, 15, 'In Use', 12000, 12, 'admin', CURRENT_TIMESTAMP - INTERVAL '5 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '3 hours', 'MODEL-E'),
  ('ST006', 7000, 7, 'In Use', 5000, 5, 'admin', CURRENT_TIMESTAMP - INTERVAL '2 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '45 minutes', 'MODEL-F'),
  ('ST007', 9000, 9, 'In Use', 6500, 6, 'admin', CURRENT_TIMESTAMP - INTERVAL '3 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '1 hour 30 minutes', 'MODEL-G'),
  ('ST008', 5000, 5, 'In Use', 3500, 3, 'admin', CURRENT_TIMESTAMP - INTERVAL '1 day', 'operator1', CURRENT_TIMESTAMP - INTERVAL '20 minutes', 'MODEL-A'),
  ('ST009', 11000, 11, 'In Use', 8000, 8, 'admin', CURRENT_TIMESTAMP - INTERVAL '4 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '2 hours', 'MODEL-B'),
  ('ST010', 8500, 8, 'In Use', 6000, 6, 'admin', CURRENT_TIMESTAMP - INTERVAL '2 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '1 hour', 'MODEL-C')
ON CONFLICT ("Stencil_id") DO UPDATE SET
  "totalpcba_allowed" = EXCLUDED."totalpcba_allowed",
  "totalcycle_allowed" = EXCLUDED."totalcycle_allowed",
  "currentstencil_status" = EXCLUDED."currentstencil_status",
  "currentpcba_count" = EXCLUDED."currentpcba_count",
  "currentcycle_count" = EXCLUDED."currentcycle_count",
  "Lastupdated_by" = EXCLUDED."Lastupdated_by",
  "Lastupdated_DT" = EXCLUDED."Lastupdated_DT",
  "Model" = EXCLUDED."Model";

-- Production Line 2: New Stencils (Ready for Use) - 8 stencils
INSERT INTO "StencilMaster" ("Stencil_id", "totalpcba_allowed", "totalcycle_allowed", "currentstencil_status", "currentpcba_count", "currentcycle_count", "created_by", "created_DT", "Lastupdated_by", "Lastupdated_DT", "Model")
VALUES 
  ('ST011', 10000, 10, 'New', 0, 0, 'admin', CURRENT_TIMESTAMP, 'admin', CURRENT_TIMESTAMP, 'MODEL-A'),
  ('ST012', 8000, 8, 'New', 0, 0, 'admin', CURRENT_TIMESTAMP, 'admin', CURRENT_TIMESTAMP, 'MODEL-B'),
  ('ST013', 12000, 12, 'New', 0, 0, 'admin', CURRENT_TIMESTAMP, 'admin', CURRENT_TIMESTAMP, 'MODEL-C'),
  ('ST014', 6000, 6, 'New', 0, 0, 'admin', CURRENT_TIMESTAMP, 'admin', CURRENT_TIMESTAMP, 'MODEL-D'),
  ('ST015', 15000, 15, 'New', 0, 0, 'admin', CURRENT_TIMESTAMP, 'admin', CURRENT_TIMESTAMP, 'MODEL-E'),
  ('ST016', 7000, 7, 'New', 0, 0, 'admin', CURRENT_TIMESTAMP, 'admin', CURRENT_TIMESTAMP, 'MODEL-F'),
  ('ST017', 9000, 9, 'New', 0, 0, 'admin', CURRENT_TIMESTAMP, 'admin', CURRENT_TIMESTAMP, 'MODEL-G'),
  ('ST018', 5000, 5, 'New', 0, 0, 'admin', CURRENT_TIMESTAMP, 'admin', CURRENT_TIMESTAMP, 'MODEL-A')
ON CONFLICT ("Stencil_id") DO UPDATE SET
  "totalpcba_allowed" = EXCLUDED."totalpcba_allowed",
  "totalcycle_allowed" = EXCLUDED."totalcycle_allowed",
  "currentstencil_status" = EXCLUDED."currentstencil_status",
  "currentpcba_count" = EXCLUDED."currentpcba_count",
  "currentcycle_count" = EXCLUDED."currentcycle_count",
  "Lastupdated_by" = EXCLUDED."Lastupdated_by",
  "Lastupdated_DT" = EXCLUDED."Lastupdated_DT",
  "Model" = EXCLUDED."Model";

-- Production Line 3: Cleaning Stencils (Maintenance) - 7 stencils
INSERT INTO "StencilMaster" ("Stencil_id", "totalpcba_allowed", "totalcycle_allowed", "currentstencil_status", "currentpcba_count", "currentcycle_count", "created_by", "created_DT", "Lastupdated_by", "Lastupdated_DT", "Model")
VALUES 
  ('ST019', 10000, 10, 'Cleaning', 9500, 9, 'admin', CURRENT_TIMESTAMP - INTERVAL '10 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '2 hours', 'MODEL-A'),
  ('ST020', 8000, 8, 'Cleaning', 7500, 7, 'admin', CURRENT_TIMESTAMP - INTERVAL '8 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '1 hour', 'MODEL-B'),
  ('ST021', 12000, 12, 'Cleaning', 11000, 11, 'admin', CURRENT_TIMESTAMP - INTERVAL '12 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '3 hours', 'MODEL-C'),
  ('ST022', 6000, 6, 'Cleaning', 5500, 5, 'admin', CURRENT_TIMESTAMP - INTERVAL '7 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '30 minutes', 'MODEL-D'),
  ('ST023', 15000, 15, 'Cleaning', 14000, 14, 'admin', CURRENT_TIMESTAMP - INTERVAL '15 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '4 hours', 'MODEL-E'),
  ('ST024', 7000, 7, 'Cleaning', 6500, 6, 'admin', CURRENT_TIMESTAMP - INTERVAL '9 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '1 hour 30 minutes', 'MODEL-F'),
  ('ST025', 9000, 9, 'Cleaning', 8500, 8, 'admin', CURRENT_TIMESTAMP - INTERVAL '11 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '2 hours 30 minutes', 'MODEL-G')
ON CONFLICT ("Stencil_id") DO UPDATE SET
  "totalpcba_allowed" = EXCLUDED."totalpcba_allowed",
  "totalcycle_allowed" = EXCLUDED."totalcycle_allowed",
  "currentstencil_status" = EXCLUDED."currentstencil_status",
  "currentpcba_count" = EXCLUDED."currentpcba_count",
  "currentcycle_count" = EXCLUDED."currentcycle_count",
  "Lastupdated_by" = EXCLUDED."Lastupdated_by",
  "Lastupdated_DT" = EXCLUDED."Lastupdated_DT",
  "Model" = EXCLUDED."Model";

-- Production Line 4: Unloading Stencils (Cycle Complete) - 6 stencils
INSERT INTO "StencilMaster" ("Stencil_id", "totalpcba_allowed", "totalcycle_allowed", "currentstencil_status", "currentpcba_count", "currentcycle_count", "created_by", "created_DT", "Lastupdated_by", "Lastupdated_DT", "Model")
VALUES 
  ('ST026', 10000, 10, 'Unloading', 9800, 9, 'admin', CURRENT_TIMESTAMP - INTERVAL '20 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '1 hour', 'MODEL-A'),
  ('ST027', 8000, 8, 'Unloading', 7800, 7, 'admin', CURRENT_TIMESTAMP - INTERVAL '18 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '2 hours', 'MODEL-B'),
  ('ST028', 12000, 12, 'Unloading', 11800, 11, 'admin', CURRENT_TIMESTAMP - INTERVAL '22 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '30 minutes', 'MODEL-C'),
  ('ST029', 6000, 6, 'Unloading', 5800, 5, 'admin', CURRENT_TIMESTAMP - INTERVAL '16 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '3 hours', 'MODEL-D'),
  ('ST030', 15000, 15, 'Unloading', 14800, 14, 'admin', CURRENT_TIMESTAMP - INTERVAL '25 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '1 hour 30 minutes', 'MODEL-E'),
  ('ST031', 7000, 7, 'Unloading', 6800, 6, 'admin', CURRENT_TIMESTAMP - INTERVAL '19 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '45 minutes', 'MODEL-F')
ON CONFLICT ("Stencil_id") DO UPDATE SET
  "totalpcba_allowed" = EXCLUDED."totalpcba_allowed",
  "totalcycle_allowed" = EXCLUDED."totalcycle_allowed",
  "currentstencil_status" = EXCLUDED."currentstencil_status",
  "currentpcba_count" = EXCLUDED."currentpcba_count",
  "currentcycle_count" = EXCLUDED."currentcycle_count",
  "Lastupdated_by" = EXCLUDED."Lastupdated_by",
  "Lastupdated_DT" = EXCLUDED."Lastupdated_DT",
  "Model" = EXCLUDED."Model";

-- Quality Control: Hold/Scrap Stencils - 5 stencils
INSERT INTO "StencilMaster" ("Stencil_id", "totalpcba_allowed", "totalcycle_allowed", "currentstencil_status", "currentpcba_count", "currentcycle_count", "created_by", "created_DT", "Lastupdated_by", "Lastupdated_DT", "Model")
VALUES 
  ('ST032', 10000, 10, 'Hold', 5000, 5, 'admin', CURRENT_TIMESTAMP - INTERVAL '30 days', 'quality1', CURRENT_TIMESTAMP - INTERVAL '5 days', 'MODEL-A'),
  ('ST033', 8000, 8, 'Hold', 3000, 3, 'admin', CURRENT_TIMESTAMP - INTERVAL '28 days', 'quality1', CURRENT_TIMESTAMP - INTERVAL '3 days', 'MODEL-B'),
  ('ST034', 12000, 12, 'Scrap', 8000, 8, 'admin', CURRENT_TIMESTAMP - INTERVAL '60 days', 'quality1', CURRENT_TIMESTAMP - INTERVAL '10 days', 'MODEL-C'),
  ('ST035', 6000, 6, 'Scrap', 4000, 4, 'admin', CURRENT_TIMESTAMP - INTERVAL '55 days', 'quality1', CURRENT_TIMESTAMP - INTERVAL '8 days', 'MODEL-D'),
  ('ST036', 15000, 15, 'Hold', 7000, 7, 'admin', CURRENT_TIMESTAMP - INTERVAL '35 days', 'quality1', CURRENT_TIMESTAMP - INTERVAL '7 days', 'MODEL-E')
ON CONFLICT ("Stencil_id") DO UPDATE SET
  "totalpcba_allowed" = EXCLUDED."totalpcba_allowed",
  "totalcycle_allowed" = EXCLUDED."totalcycle_allowed",
  "currentstencil_status" = EXCLUDED."currentstencil_status",
  "currentpcba_count" = EXCLUDED."currentpcba_count",
  "currentcycle_count" = EXCLUDED."currentcycle_count",
  "Lastupdated_by" = EXCLUDED."Lastupdated_by",
  "Lastupdated_DT" = EXCLUDED."Lastupdated_DT",
  "Model" = EXCLUDED."Model";

-- ============================================
-- 6. COMPREHENSIVE SPI MASTER DATA
-- ============================================

-- Active SPI Containers (In Use) - 8 containers
INSERT INTO "SpiMaster" ("Spi_id", "totalpcba_allowed", "totalcycle_allowed", "currentstencil_status", "currentpcba_count", "currentcycle_count", "created_by", "created_DT", "Lastupdated_by", "Lastupdated_DT", "Model")
VALUES
  ('SPI001', 10000, 10, 'In Use', 7500, 7, 'admin', CURRENT_TIMESTAMP - INTERVAL '2 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '2 hours', 'SPI-MODEL-A'),
  ('SPI002', 8000, 8, 'In Use', 6000, 6, 'admin', CURRENT_TIMESTAMP - INTERVAL '3 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '1 hour', 'SPI-MODEL-B'),
  ('SPI003', 12000, 12, 'In Use', 9000, 9, 'admin', CURRENT_TIMESTAMP - INTERVAL '1 day', 'operator1', CURRENT_TIMESTAMP - INTERVAL '30 minutes', 'SPI-MODEL-C'),
  ('SPI004', 6000, 6, 'In Use', 4500, 4, 'admin', CURRENT_TIMESTAMP - INTERVAL '4 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '15 minutes', 'SPI-MODEL-D'),
  ('SPI005', 15000, 15, 'In Use', 12000, 12, 'admin', CURRENT_TIMESTAMP - INTERVAL '5 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '3 hours', 'SPI-MODEL-E'),
  ('SPI006', 7000, 7, 'In Use', 5000, 5, 'admin', CURRENT_TIMESTAMP - INTERVAL '2 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '45 minutes', 'SPI-MODEL-A'),
  ('SPI007', 9000, 9, 'In Use', 6500, 6, 'admin', CURRENT_TIMESTAMP - INTERVAL '3 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '1 hour 30 minutes', 'SPI-MODEL-B'),
  ('SPI008', 5000, 5, 'In Use', 3500, 3, 'admin', CURRENT_TIMESTAMP - INTERVAL '1 day', 'operator1', CURRENT_TIMESTAMP - INTERVAL '20 minutes', 'SPI-MODEL-C')
ON CONFLICT ("Spi_id") DO UPDATE SET
  "totalpcba_allowed" = EXCLUDED."totalpcba_allowed",
  "totalcycle_allowed" = EXCLUDED."totalcycle_allowed",
  "currentstencil_status" = EXCLUDED."currentstencil_status",
  "currentpcba_count" = EXCLUDED."currentpcba_count",
  "currentcycle_count" = EXCLUDED."currentcycle_count",
  "Lastupdated_by" = EXCLUDED."Lastupdated_by",
  "Lastupdated_DT" = EXCLUDED."Lastupdated_DT",
  "Model" = EXCLUDED."Model";

-- New SPI Containers (Ready) - 5 containers
INSERT INTO "SpiMaster" ("Spi_id", "totalpcba_allowed", "totalcycle_allowed", "currentstencil_status", "currentpcba_count", "currentcycle_count", "created_by", "created_DT", "Lastupdated_by", "Lastupdated_DT", "Model")
VALUES
  ('SPI009', 10000, 10, 'New', 0, 0, 'admin', CURRENT_TIMESTAMP, 'admin', CURRENT_TIMESTAMP, 'SPI-MODEL-A'),
  ('SPI010', 8000, 8, 'New', 0, 0, 'admin', CURRENT_TIMESTAMP, 'admin', CURRENT_TIMESTAMP, 'SPI-MODEL-B'),
  ('SPI011', 12000, 12, 'New', 0, 0, 'admin', CURRENT_TIMESTAMP, 'admin', CURRENT_TIMESTAMP, 'SPI-MODEL-C'),
  ('SPI012', 6000, 6, 'New', 0, 0, 'admin', CURRENT_TIMESTAMP, 'admin', CURRENT_TIMESTAMP, 'SPI-MODEL-D'),
  ('SPI013', 15000, 15, 'New', 0, 0, 'admin', CURRENT_TIMESTAMP, 'admin', CURRENT_TIMESTAMP, 'SPI-MODEL-E')
ON CONFLICT ("Spi_id") DO UPDATE SET
  "totalpcba_allowed" = EXCLUDED."totalpcba_allowed",
  "totalcycle_allowed" = EXCLUDED."totalcycle_allowed",
  "currentstencil_status" = EXCLUDED."currentstencil_status",
  "currentpcba_count" = EXCLUDED."currentpcba_count",
  "currentcycle_count" = EXCLUDED."currentcycle_count",
  "Lastupdated_by" = EXCLUDED."Lastupdated_by",
  "Lastupdated_DT" = EXCLUDED."Lastupdated_DT",
  "Model" = EXCLUDED."Model";

-- ============================================
-- 7. DETAILED STENCIL CHANGE HISTORY
-- ============================================

-- ST001: Complete production cycle with multiple status changes
INSERT INTO "Stencilchangehistory" ("stencil_id", "routeno", "status1", "cyclecount", "totalcycle_count", "pcbacount", "totalpcba_count", "remarks", "created_by", "created_DT", "Lastupdated_by", "Lastupdated_DT")
VALUES
  ('ST001', 1, 'new', 0, 0, 0, 0, 'Initial stencil creation', 'admin', CURRENT_TIMESTAMP - INTERVAL '20 days', 'admin', CURRENT_TIMESTAMP - INTERVAL '20 days'),
  ('ST001', 2, 'In Use', 1, 1, 1000, 1000, 'Loaded to Line 1 - Model A production', 'process1', CURRENT_TIMESTAMP - INTERVAL '19 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '19 days'),
  ('ST001', 3, 'Cleaning', 1, 1, 0, 1000, 'First cleaning cycle after 1000 PCBA', 'operator1', CURRENT_TIMESTAMP - INTERVAL '18 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '18 days'),
  ('ST001', 4, 'Unloading', 2, 2, 0, 1000, 'Unloaded after cycle 1', 'process1', CURRENT_TIMESTAMP - INTERVAL '17 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '17 days'),
  ('ST001', 5, 'In Use', 3, 3, 1500, 2500, 'Re-loaded to Line 1 - Continued production', 'process1', CURRENT_TIMESTAMP - INTERVAL '16 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '16 days'),
  ('ST001', 6, 'Cleaning', 3, 3, 0, 2500, 'Second cleaning cycle', 'operator1', CURRENT_TIMESTAMP - INTERVAL '15 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '15 days'),
  ('ST001', 7, 'Unloading', 4, 4, 0, 2500, 'Unloaded after cycle 2', 'process1', CURRENT_TIMESTAMP - INTERVAL '14 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '14 days'),
  ('ST001', 8, 'In Use', 5, 5, 2000, 4500, 'Re-loaded to Line 1', 'process1', CURRENT_TIMESTAMP - INTERVAL '13 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '13 days'),
  ('ST001', 9, 'Cleaning', 5, 5, 0, 4500, 'Third cleaning cycle', 'operator1', CURRENT_TIMESTAMP - INTERVAL '12 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '12 days'),
  ('ST001', 10, 'Unloading', 6, 6, 0, 4500, 'Unloaded after cycle 3', 'process1', CURRENT_TIMESTAMP - INTERVAL '11 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '11 days'),
  ('ST001', 11, 'In Use', 7, 7, 3000, 7500, 'Re-loaded to Line 1 - Current production', 'process1', CURRENT_TIMESTAMP - INTERVAL '2 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '2 hours')
ON CONFLICT ("Id") DO NOTHING;

-- ST002: Production cycle with quality hold
INSERT INTO "Stencilchangehistory" ("stencil_id", "routeno", "status1", "cyclecount", "totalcycle_count", "pcbacount", "totalpcba_count", "remarks", "created_by", "created_DT", "Lastupdated_by", "Lastupdated_DT")
VALUES
  ('ST002', 1, 'new', 0, 0, 0, 0, 'Initial stencil creation', 'admin', CURRENT_TIMESTAMP - INTERVAL '25 days', 'admin', CURRENT_TIMESTAMP - INTERVAL '25 days'),
  ('ST002', 2, 'In Use', 1, 1, 2000, 2000, 'Loaded to Line 2 - Model B production', 'process1', CURRENT_TIMESTAMP - INTERVAL '24 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '24 days'),
  ('ST002', 3, 'Cleaning', 1, 1, 0, 2000, 'First cleaning cycle', 'operator1', CURRENT_TIMESTAMP - INTERVAL '23 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '23 days'),
  ('ST002', 4, 'Unloading', 2, 2, 0, 2000, 'Unloaded after cycle 1', 'process1', CURRENT_TIMESTAMP - INTERVAL '22 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '22 days'),
  ('ST002', 5, 'In Use', 3, 3, 2000, 4000, 'Re-loaded to Line 2', 'process1', CURRENT_TIMESTAMP - INTERVAL '21 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '21 days'),
  ('ST002', 6, 'Cleaning', 3, 3, 0, 4000, 'Second cleaning cycle', 'operator1', CURRENT_TIMESTAMP - INTERVAL '20 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '20 days'),
  ('ST002', 7, 'Unloading', 4, 4, 0, 4000, 'Unloaded after cycle 2', 'process1', CURRENT_TIMESTAMP - INTERVAL '19 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '19 days'),
  ('ST002', 8, 'In Use', 5, 5, 2000, 6000, 'Re-loaded to Line 2 - Current production', 'process1', CURRENT_TIMESTAMP - INTERVAL '1 hour', 'process1', CURRENT_TIMESTAMP - INTERVAL '1 hour')
ON CONFLICT ("Id") DO NOTHING;

-- ST005: High-volume production with multiple cycles
INSERT INTO "Stencilchangehistory" ("stencil_id", "routeno", "status1", "cyclecount", "totalcycle_count", "pcbacount", "totalpcba_count", "remarks", "created_by", "created_DT", "Lastupdated_by", "Lastupdated_DT")
VALUES
  ('ST005', 1, 'new', 0, 0, 0, 0, 'Initial stencil creation', 'admin', CURRENT_TIMESTAMP - INTERVAL '30 days', 'admin', CURRENT_TIMESTAMP - INTERVAL '30 days'),
  ('ST005', 2, 'In Use', 1, 1, 2000, 2000, 'Loaded to Line 3 - High volume production', 'process1', CURRENT_TIMESTAMP - INTERVAL '29 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '29 days'),
  ('ST005', 3, 'Cleaning', 1, 1, 0, 2000, 'First cleaning cycle', 'operator1', CURRENT_TIMESTAMP - INTERVAL '28 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '28 days'),
  ('ST005', 4, 'Unloading', 2, 2, 0, 2000, 'Unloaded after cycle 1', 'process1', CURRENT_TIMESTAMP - INTERVAL '27 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '27 days'),
  ('ST005', 5, 'In Use', 3, 3, 2500, 4500, 'Re-loaded to Line 3', 'process1', CURRENT_TIMESTAMP - INTERVAL '26 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '26 days'),
  ('ST005', 6, 'Cleaning', 3, 3, 0, 4500, 'Second cleaning cycle', 'operator1', CURRENT_TIMESTAMP - INTERVAL '25 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '25 days'),
  ('ST005', 7, 'Unloading', 4, 4, 0, 4500, 'Unloaded after cycle 2', 'process1', CURRENT_TIMESTAMP - INTERVAL '24 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '24 days'),
  ('ST005', 8, 'In Use', 5, 5, 3000, 7500, 'Re-loaded to Line 3', 'process1', CURRENT_TIMESTAMP - INTERVAL '23 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '23 days'),
  ('ST005', 9, 'Cleaning', 5, 5, 0, 7500, 'Third cleaning cycle', 'operator1', CURRENT_TIMESTAMP - INTERVAL '22 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '22 days'),
  ('ST005', 10, 'Unloading', 6, 6, 0, 7500, 'Unloaded after cycle 3', 'process1', CURRENT_TIMESTAMP - INTERVAL '21 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '21 days'),
  ('ST005', 11, 'In Use', 7, 7, 2500, 10000, 'Re-loaded to Line 3', 'process1', CURRENT_TIMESTAMP - INTERVAL '20 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '20 days'),
  ('ST005', 12, 'Cleaning', 7, 7, 0, 10000, 'Fourth cleaning cycle', 'operator1', CURRENT_TIMESTAMP - INTERVAL '19 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '19 days'),
  ('ST005', 13, 'Unloading', 8, 8, 0, 10000, 'Unloaded after cycle 4', 'process1', CURRENT_TIMESTAMP - INTERVAL '18 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '18 days'),
  ('ST005', 14, 'In Use', 9, 9, 2000, 12000, 'Re-loaded to Line 3 - Current production', 'process1', CURRENT_TIMESTAMP - INTERVAL '3 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '3 hours')
ON CONFLICT ("Id") DO NOTHING;

-- ============================================
-- 8. SPI CHANGE HISTORY (Solder Paste Workflow)
-- ============================================

-- SPI001: Complete solder paste workflow
INSERT INTO "Spichangehistory" ("Spi_id", "routeno", "status1", "cyclecount", "totalcycle_count", "pcbacount", "totalpcba_count", "remarks", "created_by", "created_DT", "Lastupdated_by", "Lastupdated_DT")
VALUES
  ('SPI001', 1, 'new', 0, 0, 0, 0, 'New solder paste container received', 'admin', CURRENT_TIMESTAMP - INTERVAL '10 days', 'admin', CURRENT_TIMESTAMP - INTERVAL '10 days'),
  ('SPI001', 2, 'Thawing in', 1, 1, 0, 0, 'Thawing started - Room temperature', 'process1', CURRENT_TIMESTAMP - INTERVAL '9 days 20 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '9 days 20 hours'),
  ('SPI001', 3, 'Thawing out', 1, 1, 0, 0, 'Thawing completed - Ready for mixing', 'process1', CURRENT_TIMESTAMP - INTERVAL '9 days 18 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '9 days 18 hours'),
  ('SPI001', 4, 'Mixing in', 1, 1, 0, 0, 'Mixing started - Centrifuge process', 'process1', CURRENT_TIMESTAMP - INTERVAL '9 days 16 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '9 days 16 hours'),
  ('SPI001', 5, 'Mixing out', 1, 1, 0, 0, 'Mixing completed - Ready for use', 'process1', CURRENT_TIMESTAMP - INTERVAL '9 days 14 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '9 days 14 hours'),
  ('SPI001', 6, 'Load to machine', 1, 1, 0, 0, 'Loaded to printing machine Line 1', 'process1', CURRENT_TIMESTAMP - INTERVAL '9 days 12 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '9 days 12 hours'),
  ('SPI001', 7, 'In Use', 1, 1, 2000, 2000, 'Production started - Model A', 'process1', CURRENT_TIMESTAMP - INTERVAL '9 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '9 days'),
  ('SPI001', 8, 'Cleaning', 1, 1, 0, 2000, 'First cleaning cycle', 'operator1', CURRENT_TIMESTAMP - INTERVAL '8 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '8 days'),
  ('SPI001', 9, 'In Use', 2, 2, 2500, 4500, 'Re-loaded to machine', 'process1', CURRENT_TIMESTAMP - INTERVAL '7 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '7 days'),
  ('SPI001', 10, 'Cleaning', 2, 2, 0, 4500, 'Second cleaning cycle', 'operator1', CURRENT_TIMESTAMP - INTERVAL '6 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '6 days'),
  ('SPI001', 11, 'In Use', 3, 3, 3000, 7500, 'Re-loaded to machine - Current production', 'process1', CURRENT_TIMESTAMP - INTERVAL '2 hours', 'process1', CURRENT_TIMESTAMP - INTERVAL '2 hours')
ON CONFLICT ("Id") DO NOTHING;

-- ============================================
-- 9. HOLD/RELEASE RECORDS
-- ============================================

INSERT INTO "HoldRelease" ("StencilId", "Status", "CurrentStatus", "Remarks", "HoldDate", "ReleaseDate", "Created_By", "Created_DT")
VALUES
  ('ST032', 'Hold', 1, 'Quality issue: Solder paste bridging detected on 5% of boards', CURRENT_TIMESTAMP - INTERVAL '5 days', NULL, 'quality1', CURRENT_TIMESTAMP - INTERVAL '5 days'),
  ('ST033', 'Hold', 1, 'Maintenance required: Stencil aperture clogging', CURRENT_TIMESTAMP - INTERVAL '3 days', NULL, 'quality1', CURRENT_TIMESTAMP - INTERVAL '3 days'),
  ('ST034', 'Scrap', 0, 'Damaged beyond repair: Physical damage to stencil frame', CURRENT_TIMESTAMP - INTERVAL '10 days', CURRENT_TIMESTAMP - INTERVAL '8 days', 'quality1', CURRENT_TIMESTAMP - INTERVAL '10 days'),
  ('ST035', 'Scrap', 0, 'Obsolete: Model discontinued, no longer in production', CURRENT_TIMESTAMP - INTERVAL '8 days', CURRENT_TIMESTAMP - INTERVAL '6 days', 'quality1', CURRENT_TIMESTAMP - INTERVAL '8 days'),
  ('ST036', 'Hold', 1, 'Calibration pending: Stencil thickness measurement required', CURRENT_TIMESTAMP - INTERVAL '7 days', NULL, 'quality1', CURRENT_TIMESTAMP - INTERVAL '7 days')
ON CONFLICT ("Id") DO NOTHING;

-- ============================================
-- 10. SQG MASTER DATA
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
-- 11. WAVE MASTER DATA
-- ============================================

INSERT INTO "WaveMaster" ("Wave_id", "totalpcba_allowed", "totalcycle_allowed", "currentstencil_status", "currentpcba_count", "currentcycle_count", "created_by", "created_DT", "Lastupdated_by", "Lastupdated_DT")
VALUES
  ('WAVE001', 20000, 20, 'In Use', 15000, 15, 'admin', CURRENT_TIMESTAMP - INTERVAL '10 days', 'process1', CURRENT_TIMESTAMP - INTERVAL '2 days'),
  ('WAVE002', 15000, 15, 'New', 0, 0, 'admin', CURRENT_TIMESTAMP, 'admin', CURRENT_TIMESTAMP),
  ('WAVE003', 18000, 18, 'Cleaning', 12000, 12, 'admin', CURRENT_TIMESTAMP - INTERVAL '7 days', 'operator1', CURRENT_TIMESTAMP - INTERVAL '1 day')
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
-- Total Records Created:
-- - StencilMaster: 36 stencils (10 In Use, 8 New, 7 Cleaning, 6 Unloading, 5 Hold/Scrap)
-- - SpiMaster: 13 containers (8 In Use, 5 New)
-- - Stencilchangehistory: 30+ history records
-- - Spichangehistory: 11+ history records
-- - HoldRelease: 5 records
-- - SQG: 3 records
-- - Wave: 3 records
-- - Models: 7 Stencil models, 5 SPI models
-- ============================================

