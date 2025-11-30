-- Factory Utility Database Schema
-- PostgreSQL version - Production-ready

-- =============================================
-- 1. LoginDetails Table - User Authentication
-- =============================================
CREATE TABLE IF NOT EXISTS "LoginDetails" (
    "Userid" VARCHAR(50) PRIMARY KEY,
    "Username" VARCHAR(100) NOT NULL,
    "Useremail" VARCHAR(100),
    "Userpassword" VARCHAR(100) NOT NULL,
    "Roles" VARCHAR(100) NOT NULL,
    "Created_DT" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "Lastupdated_DT" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "IsActive" BOOLEAN DEFAULT TRUE
);

-- =============================================
-- 2. SPI Tables
-- =============================================

-- SpiModel Table
CREATE TABLE IF NOT EXISTS "SpiModel" (
    "Model" VARCHAR(100) PRIMARY KEY,
    "ModelDesc" VARCHAR(200),
    "Created_By" VARCHAR(50),
    "Created_Date" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- SpiMaster Table
CREATE TABLE IF NOT EXISTS "SpiMaster" (
    "Spi_id" VARCHAR(50) PRIMARY KEY,
    "totalpcba_allowed" INTEGER NOT NULL DEFAULT 5000,
    "totalcycle_allowed" INTEGER NOT NULL DEFAULT 5,
    "currentstencil_status" VARCHAR(50) DEFAULT 'New',
    "currentpcba_count" INTEGER DEFAULT 0,
    "currentcycle_count" INTEGER DEFAULT 0,
    "created_by" VARCHAR(50),
    "created_DT" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "Lastupdated_by" VARCHAR(50),
    "Lastupdated_DT" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Spichangehistory Table
CREATE TABLE IF NOT EXISTS "Spichangehistory" (
    "Id" SERIAL PRIMARY KEY,
    "Spi_id" VARCHAR(50) NOT NULL,
    "routeno" INTEGER NOT NULL,
    "status1" VARCHAR(50),
    "cyclecount" INTEGER DEFAULT 0,
    "totalcycle_count" INTEGER DEFAULT 0,
    "pcbacount" INTEGER DEFAULT 0,
    "totalpcba_count" INTEGER DEFAULT 0,
    "remarks" VARCHAR(500),
    "created_by" VARCHAR(50),
    "created_DT" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "Lastupdated_by" VARCHAR(50),
    "Lastupdated_DT" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY ("Spi_id") REFERENCES "SpiMaster"("Spi_id")
);

-- SpiRoute Table
CREATE TABLE IF NOT EXISTS "SpiRoute" (
    "routeno" INTEGER PRIMARY KEY,
    "routedescription" VARCHAR(100) NOT NULL,
    "previousmandatory" INTEGER DEFAULT 0,
    "roles" VARCHAR(100) DEFAULT 'OPERATOR',
    "gaptime" INTEGER DEFAULT 0
);

-- Insert default SPI routes (SP Workflow)
-- SP Workflow: New → Thawing in → Thawing out → Mixing in → Mixing out → Load to machine → Unload from machine
INSERT INTO "SpiRoute" ("routeno", "routedescription", "previousmandatory", "roles", "gaptime")
SELECT 1, 'New', 0, 'ADMIN,PROCESS', 0
WHERE NOT EXISTS (SELECT 1 FROM "SpiRoute" WHERE "routeno" = 1);

INSERT INTO "SpiRoute" ("routeno", "routedescription", "previousmandatory", "roles", "gaptime")
SELECT 2, 'Thawing in', 1, 'PROCESS,OPERATOR', 0
WHERE NOT EXISTS (SELECT 1 FROM "SpiRoute" WHERE "routeno" = 2);

INSERT INTO "SpiRoute" ("routeno", "routedescription", "previousmandatory", "roles", "gaptime")
SELECT 3, 'Thawing out', 2, 'PROCESS,OPERATOR', 30
WHERE NOT EXISTS (SELECT 1 FROM "SpiRoute" WHERE "routeno" = 3);

INSERT INTO "SpiRoute" ("routeno", "routedescription", "previousmandatory", "roles", "gaptime")
SELECT 4, 'Mixing in', 3, 'PROCESS,OPERATOR', 0
WHERE NOT EXISTS (SELECT 1 FROM "SpiRoute" WHERE "routeno" = 4);

INSERT INTO "SpiRoute" ("routeno", "routedescription", "previousmandatory", "roles", "gaptime")
SELECT 5, 'Mixing out', 4, 'PROCESS,OPERATOR', 15
WHERE NOT EXISTS (SELECT 1 FROM "SpiRoute" WHERE "routeno" = 5);

INSERT INTO "SpiRoute" ("routeno", "routedescription", "previousmandatory", "roles", "gaptime")
SELECT 6, 'Load to machine', 5, 'PROCESS,OPERATOR', 0
WHERE NOT EXISTS (SELECT 1 FROM "SpiRoute" WHERE "routeno" = 6);

INSERT INTO "SpiRoute" ("routeno", "routedescription", "previousmandatory", "roles", "gaptime")
SELECT 8, 'Unload from machine', 6, 'PROCESS,OPERATOR', 0
WHERE NOT EXISTS (SELECT 1 FROM "SpiRoute" WHERE "routeno" = 8);

INSERT INTO "SpiRoute" ("routeno", "routedescription", "previousmandatory", "roles", "gaptime")
SELECT 9, 'Hold', 0, 'ADMIN,QUALITY', 0
WHERE NOT EXISTS (SELECT 1 FROM "SpiRoute" WHERE "routeno" = 9);

INSERT INTO "SpiRoute" ("routeno", "routedescription", "previousmandatory", "roles", "gaptime")
SELECT 10, 'Scrap', 0, 'ADMIN,QUALITY', 0
WHERE NOT EXISTS (SELECT 1 FROM "SpiRoute" WHERE "routeno" = 10);

-- =============================================
-- 3. Stencil Tables
-- =============================================

-- StencilModel Table
CREATE TABLE IF NOT EXISTS "StencilModel" (
    "Model" VARCHAR(100) PRIMARY KEY,
    "ModelDesc" VARCHAR(200),
    "Created_By" VARCHAR(50),
    "Created_Date" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- StencilMaster Table
CREATE TABLE IF NOT EXISTS "StencilMaster" (
    "Stencil_id" VARCHAR(50) PRIMARY KEY,
    "totalpcba_allowed" INTEGER NOT NULL DEFAULT 5000,
    "totalcycle_allowed" INTEGER NOT NULL DEFAULT 5,
    "currentstencil_status" VARCHAR(50) DEFAULT 'New',
    "currentpcba_count" INTEGER DEFAULT 0,
    "currentcycle_count" INTEGER DEFAULT 0,
    "created_by" VARCHAR(50),
    "created_DT" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "Lastupdated_by" VARCHAR(50),
    "Lastupdated_DT" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Stencilchangehistory Table
CREATE TABLE IF NOT EXISTS "Stencilchangehistory" (
    "Id" SERIAL PRIMARY KEY,
    "stencil_id" VARCHAR(50) NOT NULL,
    "routeno" INTEGER NOT NULL,
    "status1" VARCHAR(50),
    "cyclecount" INTEGER DEFAULT 0,
    "totalcycle_count" INTEGER DEFAULT 0,
    "pcbacount" INTEGER DEFAULT 0,
    "totalpcba_count" INTEGER DEFAULT 0,
    "remarks" VARCHAR(500),
    "created_by" VARCHAR(50),
    "created_DT" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "Lastupdated_by" VARCHAR(50),
    "Lastupdated_DT" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY ("stencil_id") REFERENCES "StencilMaster"("Stencil_id")
);

-- StencilRoute Table
CREATE TABLE IF NOT EXISTS "StencilRoute" (
    "routeno" INTEGER PRIMARY KEY,
    "routedescription" VARCHAR(100) NOT NULL,
    "previousmandatory" INTEGER DEFAULT 0,
    "roles" VARCHAR(100) DEFAULT 'OPERATOR',
    "gaptime" INTEGER DEFAULT 0
);

-- Insert default routes
INSERT INTO "StencilRoute" ("routeno", "routedescription", "previousmandatory", "roles", "gaptime")
SELECT 1, 'New', 0, 'ADMIN,PROCESS', 0
WHERE NOT EXISTS (SELECT 1 FROM "StencilRoute" WHERE "routeno" = 1);

INSERT INTO "StencilRoute" ("routeno", "routedescription", "previousmandatory", "roles", "gaptime")
SELECT 2, 'In Use', 1, 'PROCESS,OPERATOR', 0
WHERE NOT EXISTS (SELECT 1 FROM "StencilRoute" WHERE "routeno" = 2);

INSERT INTO "StencilRoute" ("routeno", "routedescription", "previousmandatory", "roles", "gaptime")
SELECT 3, 'Cleaning', 2, 'PROCESS,OPERATOR', 15
WHERE NOT EXISTS (SELECT 1 FROM "StencilRoute" WHERE "routeno" = 3);

INSERT INTO "StencilRoute" ("routeno", "routedescription", "previousmandatory", "roles", "gaptime")
SELECT 4, 'Unloading', 3, 'PROCESS,OPERATOR', 0
WHERE NOT EXISTS (SELECT 1 FROM "StencilRoute" WHERE "routeno" = 4);

INSERT INTO "StencilRoute" ("routeno", "routedescription", "previousmandatory", "roles", "gaptime")
SELECT 5, 'Hold', 0, 'ADMIN,QUALITY', 0
WHERE NOT EXISTS (SELECT 1 FROM "StencilRoute" WHERE "routeno" = 5);

INSERT INTO "StencilRoute" ("routeno", "routedescription", "previousmandatory", "roles", "gaptime")
SELECT 6, 'Scrap', 0, 'ADMIN,QUALITY', 0
WHERE NOT EXISTS (SELECT 1 FROM "StencilRoute" WHERE "routeno" = 6);

-- =============================================
-- 4. SQG Tables
-- =============================================

-- SQGMaster Table
CREATE TABLE IF NOT EXISTS "SQGMaster" (
    "SQG_id" VARCHAR(50) PRIMARY KEY,
    "totalpcba_allowed" INTEGER NOT NULL DEFAULT 5000,
    "totalcycle_allowed" INTEGER NOT NULL DEFAULT 5,
    "currentstencil_status" VARCHAR(50) DEFAULT 'New',
    "currentpcba_count" INTEGER DEFAULT 0,
    "currentcycle_count" INTEGER DEFAULT 0,
    "created_by" VARCHAR(50),
    "created_DT" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "Lastupdated_by" VARCHAR(50),
    "Lastupdated_DT" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- SQGchangehistory Table
CREATE TABLE IF NOT EXISTS "SQGchangehistory" (
    "Id" SERIAL PRIMARY KEY,
    "SQG_id" VARCHAR(50) NOT NULL,
    "routeno" INTEGER NOT NULL,
    "status1" VARCHAR(50),
    "cyclecount" INTEGER DEFAULT 0,
    "totalcycle_count" INTEGER DEFAULT 0,
    "pcbacount" INTEGER DEFAULT 0,
    "totalpcba_count" INTEGER DEFAULT 0,
    "remarks" VARCHAR(500),
    "created_by" VARCHAR(50),
    "created_DT" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "Lastupdated_by" VARCHAR(50),
    "Lastupdated_DT" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY ("SQG_id") REFERENCES "SQGMaster"("SQG_id")
);

-- SQGRoute Table
CREATE TABLE IF NOT EXISTS "SQGRoute" (
    "routeno" INTEGER PRIMARY KEY,
    "routedescription" VARCHAR(100) NOT NULL,
    "previousmandatory" INTEGER DEFAULT 0,
    "roles" VARCHAR(100) DEFAULT 'OPERATOR',
    "gaptime" INTEGER DEFAULT 0
);

-- Insert default routes
INSERT INTO "SQGRoute" ("routeno", "routedescription", "previousmandatory", "roles", "gaptime")
SELECT 1, 'New', 0, 'ADMIN,PROCESS', 0
WHERE NOT EXISTS (SELECT 1 FROM "SQGRoute" WHERE "routeno" = 1);

INSERT INTO "SQGRoute" ("routeno", "routedescription", "previousmandatory", "roles", "gaptime")
SELECT 2, 'In Use', 1, 'PROCESS,OPERATOR', 0
WHERE NOT EXISTS (SELECT 1 FROM "SQGRoute" WHERE "routeno" = 2);

INSERT INTO "SQGRoute" ("routeno", "routedescription", "previousmandatory", "roles", "gaptime")
SELECT 3, 'Cleaning', 2, 'PROCESS,OPERATOR', 15
WHERE NOT EXISTS (SELECT 1 FROM "SQGRoute" WHERE "routeno" = 3);

INSERT INTO "SQGRoute" ("routeno", "routedescription", "previousmandatory", "roles", "gaptime")
SELECT 4, 'Unloading', 3, 'PROCESS,OPERATOR', 0
WHERE NOT EXISTS (SELECT 1 FROM "SQGRoute" WHERE "routeno" = 4);

INSERT INTO "SQGRoute" ("routeno", "routedescription", "previousmandatory", "roles", "gaptime")
SELECT 5, 'Hold', 0, 'ADMIN,QUALITY', 0
WHERE NOT EXISTS (SELECT 1 FROM "SQGRoute" WHERE "routeno" = 5);

INSERT INTO "SQGRoute" ("routeno", "routedescription", "previousmandatory", "roles", "gaptime")
SELECT 6, 'Scrap', 0, 'ADMIN,QUALITY', 0
WHERE NOT EXISTS (SELECT 1 FROM "SQGRoute" WHERE "routeno" = 6);

-- =============================================
-- 5. Wave Tables
-- =============================================

-- WaveModel Table
CREATE TABLE IF NOT EXISTS "WaveModel" (
    "Model" VARCHAR(100) PRIMARY KEY,
    "ModelDesc" VARCHAR(200),
    "Created_By" VARCHAR(50),
    "Created_Date" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- WaveMaster Table
CREATE TABLE IF NOT EXISTS "WaveMaster" (
    "Wave_id" VARCHAR(50) PRIMARY KEY,
    "Model" VARCHAR(100),
    "totalpcba_allowed" INTEGER NOT NULL DEFAULT 5000,
    "totalcycle_allowed" INTEGER NOT NULL DEFAULT 5,
    "currentstencil_status" VARCHAR(50) DEFAULT 'New',
    "currentpcba_count" INTEGER DEFAULT 0,
    "currentcycle_count" INTEGER DEFAULT 0,
    "created_by" VARCHAR(50),
    "created_DT" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "Lastupdated_by" VARCHAR(50),
    "Lastupdated_DT" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Wavechangehistory Table
CREATE TABLE IF NOT EXISTS "Wavechangehistory" (
    "Id" SERIAL PRIMARY KEY,
    "Wave_id" VARCHAR(50) NOT NULL,
    "routeno" INTEGER NOT NULL,
    "status1" VARCHAR(50),
    "cyclecount" INTEGER DEFAULT 0,
    "totalcycle_count" INTEGER DEFAULT 0,
    "pcbacount" INTEGER DEFAULT 0,
    "totalpcba_count" INTEGER DEFAULT 0,
    "Model" VARCHAR(100),
    "remarks" VARCHAR(500),
    "created_by" VARCHAR(50),
    "created_DT" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "Lastupdated_by" VARCHAR(50),
    "Lastupdated_DT" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY ("Wave_id") REFERENCES "WaveMaster"("Wave_id")
);

-- WaveRoute Table
CREATE TABLE IF NOT EXISTS "WaveRoute" (
    "routeno" INTEGER PRIMARY KEY,
    "routedescription" VARCHAR(100) NOT NULL,
    "previousmandatory" INTEGER DEFAULT 0,
    "roles" VARCHAR(100) DEFAULT 'OPERATOR',
    "gaptime" INTEGER DEFAULT 0
);

-- Insert default routes
INSERT INTO "WaveRoute" ("routeno", "routedescription", "previousmandatory", "roles", "gaptime")
SELECT 1, 'New', 0, 'ADMIN,PROCESS', 0
WHERE NOT EXISTS (SELECT 1 FROM "WaveRoute" WHERE "routeno" = 1);

INSERT INTO "WaveRoute" ("routeno", "routedescription", "previousmandatory", "roles", "gaptime")
SELECT 2, 'In Use', 1, 'PROCESS,OPERATOR', 0
WHERE NOT EXISTS (SELECT 1 FROM "WaveRoute" WHERE "routeno" = 2);

INSERT INTO "WaveRoute" ("routeno", "routedescription", "previousmandatory", "roles", "gaptime")
SELECT 3, 'Cleaning', 2, 'PROCESS,OPERATOR', 15
WHERE NOT EXISTS (SELECT 1 FROM "WaveRoute" WHERE "routeno" = 3);

INSERT INTO "WaveRoute" ("routeno", "routedescription", "previousmandatory", "roles", "gaptime")
SELECT 4, 'Unloading', 3, 'PROCESS,OPERATOR', 0
WHERE NOT EXISTS (SELECT 1 FROM "WaveRoute" WHERE "routeno" = 4);

INSERT INTO "WaveRoute" ("routeno", "routedescription", "previousmandatory", "roles", "gaptime")
SELECT 5, 'Hold', 0, 'ADMIN,QUALITY', 0
WHERE NOT EXISTS (SELECT 1 FROM "WaveRoute" WHERE "routeno" = 5);

INSERT INTO "WaveRoute" ("routeno", "routedescription", "previousmandatory", "roles", "gaptime")
SELECT 6, 'Scrap', 0, 'ADMIN,QUALITY', 0
WHERE NOT EXISTS (SELECT 1 FROM "WaveRoute" WHERE "routeno" = 6);

-- =============================================
-- 6. Hold/Scrap Table
-- =============================================

-- HoldRelease Table
CREATE TABLE IF NOT EXISTS "HoldRelease" (
    "Id" SERIAL PRIMARY KEY,
    "StencilId" VARCHAR(50),
    "Status" VARCHAR(50),
    "CurrentStatus" INTEGER DEFAULT 1,
    "Remarks" VARCHAR(500),
    "HoldDate" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "ReleaseDate" TIMESTAMP NULL,
    "Created_By" VARCHAR(50),
    "Created_DT" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- 7. LastUpdated Table (for InProcessStencil)
-- =============================================

CREATE TABLE IF NOT EXISTS "LastUpdated" (
    "Id" SERIAL PRIMARY KEY,
    "StencilId" VARCHAR(50),
    "ComputerName" VARCHAR(100),
    "StartDate" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "IsActive" BOOLEAN DEFAULT TRUE
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_spichangehistory_spi_id ON "Spichangehistory"("Spi_id");
CREATE INDEX IF NOT EXISTS idx_stencilchangehistory_stencil_id ON "Stencilchangehistory"("stencil_id");
CREATE INDEX IF NOT EXISTS idx_sqgchangehistory_sqg_id ON "SQGchangehistory"("SQG_id");
CREATE INDEX IF NOT EXISTS idx_wavechangehistory_wave_id ON "Wavechangehistory"("Wave_id");
CREATE INDEX IF NOT EXISTS idx_holdrelease_stencilid ON "HoldRelease"("StencilId");
CREATE INDEX IF NOT EXISTS idx_lastupdated_stencilid ON "LastUpdated"("StencilId");

