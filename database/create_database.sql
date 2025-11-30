-- Database Creation Script
-- Run this first to create the FactoryUtility database

-- Check if database exists, create if not
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'FactoryUtility')
BEGIN
    CREATE DATABASE [FactoryUtility]
    ON 
    ( NAME = 'FactoryUtility',
      FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\FactoryUtility.mdf',
      SIZE = 100MB,
      MAXSIZE = 1GB,
      FILEGROWTH = 10MB )
    LOG ON 
    ( NAME = 'FactoryUtility_Log',
      FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\FactoryUtility_Log.ldf',
      SIZE = 10MB,
      MAXSIZE = 500MB,
      FILEGROWTH = 5MB );
    
    PRINT 'Database FactoryUtility created successfully.';
END
ELSE
BEGIN
    PRINT 'Database FactoryUtility already exists.';
END
GO

-- Set database options
USE [FactoryUtility];
GO

ALTER DATABASE [FactoryUtility] SET RECOVERY SIMPLE;
GO

ALTER DATABASE [FactoryUtility] SET AUTO_CLOSE OFF;
GO

ALTER DATABASE [FactoryUtility] SET AUTO_SHRINK OFF;
GO

PRINT 'Database FactoryUtility is ready for schema setup.';
PRINT 'Next step: Run schema.sql to create all tables.';
GO

