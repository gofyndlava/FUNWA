-- Factory Utility Database Schema
-- Production-ready SQL Server database setup

USE [FactoryUtility];
GO

-- =============================================
-- 1. LoginDetails Table - User Authentication
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LoginDetails]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[LoginDetails] (
        [Userid] NVARCHAR(50) PRIMARY KEY,
        [Username] NVARCHAR(100) NOT NULL,
        [Useremail] NVARCHAR(100),
        [Userpassword] NVARCHAR(100) NOT NULL,
        [Roles] NVARCHAR(100) NOT NULL,
        [Created_DT] DATETIME DEFAULT GETDATE(),
        [Lastupdated_DT] DATETIME DEFAULT GETDATE(),
        [IsActive] BIT DEFAULT 1
    );
    PRINT 'LoginDetails table created successfully.';
END
GO

-- =============================================
-- 2. SPI Tables
-- =============================================

-- SpiModel Table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SpiModel]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[SpiModel] (
        [Model] NVARCHAR(100) PRIMARY KEY,
        [ModelDesc] NVARCHAR(200),
        [Created_By] NVARCHAR(50),
        [Created_Date] DATETIME DEFAULT GETDATE()
    );
    PRINT 'SpiModel table created successfully.';
END
GO

-- SpiMaster Table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SpiMaster]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[SpiMaster] (
        [Spi_id] NVARCHAR(50) PRIMARY KEY,
        [totalpcba_allowed] INT NOT NULL DEFAULT 5000,
        [totalcycle_allowed] INT NOT NULL DEFAULT 5,
        [currentstencil_status] NVARCHAR(50) DEFAULT 'New',
        [currentpcba_count] INT DEFAULT 0,
        [currentcycle_count] INT DEFAULT 0,
        [created_by] NVARCHAR(50),
        [created_DT] DATETIME DEFAULT GETDATE(),
        [Lastupdated_by] NVARCHAR(50),
        [Lastupdated_DT] DATETIME DEFAULT GETDATE()
    );
    PRINT 'SpiMaster table created successfully.';
END
GO

-- Spichangehistory Table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Spichangehistory]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Spichangehistory] (
        [Id] INT IDENTITY(1,1) PRIMARY KEY,
        [Spi_id] NVARCHAR(50) NOT NULL,
        [routeno] INT NOT NULL,
        [status1] NVARCHAR(50),
        [cyclecount] INT DEFAULT 0,
        [totalcycle_count] INT DEFAULT 0,
        [pcbacount] INT DEFAULT 0,
        [totalpcba_count] INT DEFAULT 0,
        [remarks] NVARCHAR(500),
        [created_by] NVARCHAR(50),
        [created_DT] DATETIME DEFAULT GETDATE(),
        [Lastupdated_by] NVARCHAR(50),
        [Lastupdated_DT] DATETIME DEFAULT GETDATE(),
        FOREIGN KEY ([Spi_id]) REFERENCES [SpiMaster]([Spi_id])
    );
    PRINT 'Spichangehistory table created successfully.';
END
GO

-- SpiRoute Table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SpiRoute]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[SpiRoute] (
        [routeno] INT PRIMARY KEY,
        [routedescription] NVARCHAR(100) NOT NULL,
        [previousmandatory] INT DEFAULT 0,
        [roles] NVARCHAR(100) DEFAULT 'OPERATOR',
        [gaptime] INT DEFAULT 0
    );
    
    -- Insert default routes
    INSERT INTO [dbo].[SpiRoute] ([routeno], [routedescription], [previousmandatory], [roles], [gaptime]) VALUES
    (1, 'New', 0, 'ADMIN,PROCESS', 0),
    (2, 'In Use', 1, 'PROCESS,OPERATOR', 0),
    (3, 'Cleaning', 2, 'PROCESS,OPERATOR', 15),
    (4, 'Unloading', 3, 'PROCESS,OPERATOR', 0),
    (5, 'Hold', 0, 'ADMIN,QUALITY', 0),
    (6, 'Scrap', 0, 'ADMIN,QUALITY', 0);
    
    PRINT 'SpiRoute table created with default routes.';
END
GO

-- =============================================
-- 3. Stencil Tables
-- =============================================

-- StencilModel Table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StencilModel]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[StencilModel] (
        [Model] NVARCHAR(100) PRIMARY KEY,
        [ModelDesc] NVARCHAR(200),
        [Created_By] NVARCHAR(50),
        [Created_Date] DATETIME DEFAULT GETDATE()
    );
    PRINT 'StencilModel table created successfully.';
END
GO

-- StencilMaster Table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StencilMaster]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[StencilMaster] (
        [Stencil_id] NVARCHAR(50) PRIMARY KEY,
        [totalpcba_allowed] INT NOT NULL DEFAULT 5000,
        [totalcycle_allowed] INT NOT NULL DEFAULT 5,
        [currentstencil_status] NVARCHAR(50) DEFAULT 'New',
        [currentpcba_count] INT DEFAULT 0,
        [currentcycle_count] INT DEFAULT 0,
        [created_by] NVARCHAR(50),
        [created_DT] DATETIME DEFAULT GETDATE(),
        [Lastupdated_by] NVARCHAR(50),
        [Lastupdated_DT] DATETIME DEFAULT GETDATE()
    );
    PRINT 'StencilMaster table created successfully.';
END
GO

-- Stencilchangehistory Table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Stencilchangehistory]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Stencilchangehistory] (
        [Id] INT IDENTITY(1,1) PRIMARY KEY,
        [stencil_id] NVARCHAR(50) NOT NULL,
        [routeno] INT NOT NULL,
        [status1] NVARCHAR(50),
        [cyclecount] INT DEFAULT 0,
        [totalcycle_count] INT DEFAULT 0,
        [pcbacount] INT DEFAULT 0,
        [totalpcba_count] INT DEFAULT 0,
        [remarks] NVARCHAR(500),
        [created_by] NVARCHAR(50),
        [created_DT] DATETIME DEFAULT GETDATE(),
        [Lastupdated_by] NVARCHAR(50),
        [Lastupdated_DT] DATETIME DEFAULT GETDATE(),
        FOREIGN KEY ([stencil_id]) REFERENCES [StencilMaster]([Stencil_id])
    );
    PRINT 'Stencilchangehistory table created successfully.';
END
GO

-- StencilRoute Table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StencilRoute]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[StencilRoute] (
        [routeno] INT PRIMARY KEY,
        [routedescription] NVARCHAR(100) NOT NULL,
        [previousmandatory] INT DEFAULT 0,
        [roles] NVARCHAR(100) DEFAULT 'OPERATOR',
        [gaptime] INT DEFAULT 0
    );
    
    -- Insert default routes
    INSERT INTO [dbo].[StencilRoute] ([routeno], [routedescription], [previousmandatory], [roles], [gaptime]) VALUES
    (1, 'New', 0, 'ADMIN,PROCESS', 0),
    (2, 'In Use', 1, 'PROCESS,OPERATOR', 0),
    (3, 'Cleaning', 2, 'PROCESS,OPERATOR', 15),
    (4, 'Unloading', 3, 'PROCESS,OPERATOR', 0),
    (5, 'Hold', 0, 'ADMIN,QUALITY', 0),
    (6, 'Scrap', 0, 'ADMIN,QUALITY', 0);
    
    PRINT 'StencilRoute table created with default routes.';
END
GO

-- =============================================
-- 4. SQG Tables
-- =============================================

-- SQGMaster Table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SQGMaster]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[SQGMaster] (
        [SQG_id] NVARCHAR(50) PRIMARY KEY,
        [totalpcba_allowed] INT NOT NULL DEFAULT 5000,
        [totalcycle_allowed] INT NOT NULL DEFAULT 5,
        [currentstencil_status] NVARCHAR(50) DEFAULT 'New',
        [currentpcba_count] INT DEFAULT 0,
        [currentcycle_count] INT DEFAULT 0,
        [created_by] NVARCHAR(50),
        [created_DT] DATETIME DEFAULT GETDATE(),
        [Lastupdated_by] NVARCHAR(50),
        [Lastupdated_DT] DATETIME DEFAULT GETDATE()
    );
    PRINT 'SQGMaster table created successfully.';
END
GO

-- SQGchangehistory Table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SQGchangehistory]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[SQGchangehistory] (
        [Id] INT IDENTITY(1,1) PRIMARY KEY,
        [SQG_id] NVARCHAR(50) NOT NULL,
        [routeno] INT NOT NULL,
        [status1] NVARCHAR(50),
        [cyclecount] INT DEFAULT 0,
        [totalcycle_count] INT DEFAULT 0,
        [pcbacount] INT DEFAULT 0,
        [totalpcba_count] INT DEFAULT 0,
        [remarks] NVARCHAR(500),
        [created_by] NVARCHAR(50),
        [created_DT] DATETIME DEFAULT GETDATE(),
        [Lastupdated_by] NVARCHAR(50),
        [Lastupdated_DT] DATETIME DEFAULT GETDATE(),
        FOREIGN KEY ([SQG_id]) REFERENCES [SQGMaster]([SQG_id])
    );
    PRINT 'SQGchangehistory table created successfully.';
END
GO

-- SQGRoute Table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SQGRoute]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[SQGRoute] (
        [routeno] INT PRIMARY KEY,
        [routedescription] NVARCHAR(100) NOT NULL,
        [previousmandatory] INT DEFAULT 0,
        [roles] NVARCHAR(100) DEFAULT 'OPERATOR',
        [gaptime] INT DEFAULT 0
    );
    
    -- Insert default routes
    INSERT INTO [dbo].[SQGRoute] ([routeno], [routedescription], [previousmandatory], [roles], [gaptime]) VALUES
    (1, 'New', 0, 'ADMIN,PROCESS', 0),
    (2, 'In Use', 1, 'PROCESS,OPERATOR', 0),
    (3, 'Cleaning', 2, 'PROCESS,OPERATOR', 15),
    (4, 'Unloading', 3, 'PROCESS,OPERATOR', 0),
    (5, 'Hold', 0, 'ADMIN,QUALITY', 0),
    (6, 'Scrap', 0, 'ADMIN,QUALITY', 0);
    
    PRINT 'SQGRoute table created with default routes.';
END
GO

-- =============================================
-- 5. Wave Tables
-- =============================================

-- WaveModel Table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WaveModel]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[WaveModel] (
        [Model] NVARCHAR(100) PRIMARY KEY,
        [ModelDesc] NVARCHAR(200),
        [Created_By] NVARCHAR(50),
        [Created_Date] DATETIME DEFAULT GETDATE()
    );
    PRINT 'WaveModel table created successfully.';
END
GO

-- WaveMaster Table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WaveMaster]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[WaveMaster] (
        [Wave_id] NVARCHAR(50) PRIMARY KEY,
        [Model] NVARCHAR(100),
        [totalpcba_allowed] INT NOT NULL DEFAULT 5000,
        [totalcycle_allowed] INT NOT NULL DEFAULT 5,
        [currentstencil_status] NVARCHAR(50) DEFAULT 'New',
        [currentpcba_count] INT DEFAULT 0,
        [currentcycle_count] INT DEFAULT 0,
        [created_by] NVARCHAR(50),
        [created_DT] DATETIME DEFAULT GETDATE(),
        [Lastupdated_by] NVARCHAR(50),
        [Lastupdated_DT] DATETIME DEFAULT GETDATE()
    );
    PRINT 'WaveMaster table created successfully.';
END
GO

-- Wavechangehistory Table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Wavechangehistory]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Wavechangehistory] (
        [Id] INT IDENTITY(1,1) PRIMARY KEY,
        [Wave_id] NVARCHAR(50) NOT NULL,
        [routeno] INT NOT NULL,
        [status1] NVARCHAR(50),
        [cyclecount] INT DEFAULT 0,
        [totalcycle_count] INT DEFAULT 0,
        [pcbacount] INT DEFAULT 0,
        [totalpcba_count] INT DEFAULT 0,
        [Model] NVARCHAR(100),
        [remarks] NVARCHAR(500),
        [created_by] NVARCHAR(50),
        [created_DT] DATETIME DEFAULT GETDATE(),
        [Lastupdated_by] NVARCHAR(50),
        [Lastupdated_DT] DATETIME DEFAULT GETDATE(),
        FOREIGN KEY ([Wave_id]) REFERENCES [WaveMaster]([Wave_id])
    );
    PRINT 'Wavechangehistory table created successfully.';
END
GO

-- WaveRoute Table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WaveRoute]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[WaveRoute] (
        [routeno] INT PRIMARY KEY,
        [routedescription] NVARCHAR(100) NOT NULL,
        [previousmandatory] INT DEFAULT 0,
        [roles] NVARCHAR(100) DEFAULT 'OPERATOR',
        [gaptime] INT DEFAULT 0
    );
    
    -- Insert default routes
    INSERT INTO [dbo].[WaveRoute] ([routeno], [routedescription], [previousmandatory], [roles], [gaptime]) VALUES
    (1, 'New', 0, 'ADMIN,PROCESS', 0),
    (2, 'In Use', 1, 'PROCESS,OPERATOR', 0),
    (3, 'Cleaning', 2, 'PROCESS,OPERATOR', 15),
    (4, 'Unloading', 3, 'PROCESS,OPERATOR', 0),
    (5, 'Hold', 0, 'ADMIN,QUALITY', 0),
    (6, 'Scrap', 0, 'ADMIN,QUALITY', 0);
    
    PRINT 'WaveRoute table created with default routes.';
END
GO

-- =============================================
-- 6. Hold/Scrap Table
-- =============================================

-- HoldRelease Table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HoldRelease]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[HoldRelease] (
        [Id] INT IDENTITY(1,1) PRIMARY KEY,
        [StencilId] NVARCHAR(50),
        [Status] NVARCHAR(50),
        [CurrentStatus] INT DEFAULT 1,
        [Remarks] NVARCHAR(500),
        [HoldDate] DATETIME DEFAULT GETDATE(),
        [ReleaseDate] DATETIME NULL,
        [Created_By] NVARCHAR(50),
        [Created_DT] DATETIME DEFAULT GETDATE()
    );
    PRINT 'HoldRelease table created successfully.';
END
GO

-- =============================================
-- 7. LastUpdated Table (for InProcessStencil)
-- =============================================

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LastUpdated]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[LastUpdated] (
        [Id] INT IDENTITY(1,1) PRIMARY KEY,
        [StencilId] NVARCHAR(50),
        [ComputerName] NVARCHAR(100),
        [StartDate] DATETIME DEFAULT GETDATE(),
        [IsActive] BIT DEFAULT 1
    );
    PRINT 'LastUpdated table created successfully.';
END
GO

PRINT '========================================';
PRINT 'All database tables created successfully!';
PRINT '========================================';
GO

