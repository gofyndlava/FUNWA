-- Production Password Update Script
-- IMPORTANT: Update default passwords before production deployment

USE [FactoryUtility];
GO

-- =============================================
-- Update Admin Password
-- =============================================
UPDATE [dbo].[LoginDetails]
SET [Userpassword] = 'YourStrongPassword123!',  -- CHANGE THIS!
    [Lastupdated_DT] = GETDATE()
WHERE [Userid] = 'admin';
GO

-- =============================================
-- Update Process User Password
-- =============================================
UPDATE [dbo].[LoginDetails]
SET [Userpassword] = 'YourProcessPassword123!',  -- CHANGE THIS!
    [Lastupdated_DT] = GETDATE()
WHERE [Userid] = 'process';
GO

-- =============================================
-- Update Quality User Password
-- =============================================
UPDATE [dbo].[LoginDetails]
SET [Userpassword] = 'YourQualityPassword123!',  -- CHANGE THIS!
    [Lastupdated_DT] = GETDATE()
WHERE [Userid] = 'quality';
GO

-- =============================================
-- Update Operator User Password
-- =============================================
UPDATE [dbo].[LoginDetails]
SET [Userpassword] = 'YourOperatorPassword123!',  -- CHANGE THIS!
    [Lastupdated_DT] = GETDATE()
WHERE [Userid] = 'operator';
GO

-- =============================================
-- Create Custom Production Admin User
-- =============================================
-- Example: Uncomment and customize as needed
/*
IF NOT EXISTS (SELECT * FROM [dbo].[LoginDetails] WHERE [Userid] = 'prodadmin')
BEGIN
    INSERT INTO [dbo].[LoginDetails] 
    ([Userid], [Username], [Useremail], [Userpassword], [Roles], [IsActive], [Created_DT], [Lastupdated_DT])
    VALUES 
    (
        'prodadmin',
        'Production Administrator',
        'admin@yourcompany.com',
        'VeryStrongPassword123!@#',
        'ADMIN,PROCESS,QUALITY,OPERATOR',
        1,
        GETDATE(),
        GETDATE()
    );
END
GO
*/

PRINT '========================================';
PRINT 'Passwords updated successfully!';
PRINT '========================================';
PRINT '';
PRINT 'IMPORTANT SECURITY REMINDERS:';
PRINT '1. Use strong passwords (min 12 characters, mix of letters, numbers, symbols)';
PRINT '2. Never use default passwords in production';
PRINT '3. Regularly rotate passwords';
PRINT '4. Use different passwords for each user';
PRINT '5. Consider implementing password hashing in the application';
PRINT '========================================';
GO

