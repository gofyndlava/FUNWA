-- Default Admin User Setup
-- Creates a default admin user with full access for production deployment

USE [FactoryUtility];
GO

-- =============================================
-- Create Default Admin User
-- =============================================

-- Check if admin user exists, if not create it
IF NOT EXISTS (SELECT * FROM [dbo].[LoginDetails] WHERE [Userid] = 'admin')
BEGIN
    INSERT INTO [dbo].[LoginDetails] 
    ([Userid], [Username], [Useremail], [Userpassword], [Roles], [IsActive], [Created_DT], [Lastupdated_DT])
    VALUES 
    (
        'admin',                                    -- Userid
        'Administrator',                            -- Username
        'admin@factory.com',                        -- Useremail
        'Admin@123',                                -- Userpassword (CHANGE THIS IN PRODUCTION!)
        'ADMIN,PROCESS,QUALITY,OPERATOR',          -- Roles (Full access)
        1,                                          -- IsActive
        GETDATE(),                                  -- Created_DT
        GETDATE()                                   -- Lastupdated_DT
    );
    PRINT 'Default admin user created successfully.';
    PRINT 'Username: admin';
    PRINT 'Password: Admin@123';
    PRINT 'WARNING: Change the default password in production!';
END
ELSE
BEGIN
    PRINT 'Admin user already exists. Skipping creation.';
END
GO

-- =============================================
-- Create Default Process User
-- =============================================

IF NOT EXISTS (SELECT * FROM [dbo].[LoginDetails] WHERE [Userid] = 'process')
BEGIN
    INSERT INTO [dbo].[LoginDetails] 
    ([Userid], [Username], [Useremail], [Userpassword], [Roles], [IsActive], [Created_DT], [Lastupdated_DT])
    VALUES 
    (
        'process',
        'Process User',
        'process@factory.com',
        'Process@123',
        'PROCESS,OPERATOR',
        1,
        GETDATE(),
        GETDATE()
    );
    PRINT 'Default process user created successfully.';
END
GO

-- =============================================
-- Create Default Quality User
-- =============================================

IF NOT EXISTS (SELECT * FROM [dbo].[LoginDetails] WHERE [Userid] = 'quality')
BEGIN
    INSERT INTO [dbo].[LoginDetails] 
    ([Userid], [Username], [Useremail], [Userpassword], [Roles], [IsActive], [Created_DT], [Lastupdated_DT])
    VALUES 
    (
        'quality',
        'Quality User',
        'quality@factory.com',
        'Quality@123',
        'QUALITY,OPERATOR',
        1,
        GETDATE(),
        GETDATE()
    );
    PRINT 'Default quality user created successfully.';
END
GO

-- =============================================
-- Create Default Operator User
-- =============================================

IF NOT EXISTS (SELECT * FROM [dbo].[LoginDetails] WHERE [Userid] = 'operator')
BEGIN
    INSERT INTO [dbo].[LoginDetails] 
    ([Userid], [Username], [Useremail], [Userpassword], [Roles], [IsActive], [Created_DT], [Lastupdated_DT])
    VALUES 
    (
        'operator',
        'Operator User',
        'operator@factory.com',
        'Operator@123',
        'OPERATOR',
        1,
        GETDATE(),
        GETDATE()
    );
    PRINT 'Default operator user created successfully.';
END
GO

PRINT '========================================';
PRINT 'Default users created successfully!';
PRINT '========================================';
PRINT '';
PRINT 'Default Credentials:';
PRINT '-------------------';
PRINT 'Admin:    admin / Admin@123 (Full Access)';
PRINT 'Process:  process / Process@123';
PRINT 'Quality:  quality / Quality@123';
PRINT 'Operator: operator / Operator@123';
PRINT '';
PRINT 'IMPORTANT: Change all default passwords in production!';
PRINT '========================================';
GO

