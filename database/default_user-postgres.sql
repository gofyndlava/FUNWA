-- Default Admin User Setup (PostgreSQL)
-- Creates default users with full access for production deployment

-- =============================================
-- Create Default Admin User
-- =============================================

-- Check if admin user exists, if not create it
INSERT INTO "LoginDetails" ("Userid", "Username", "Useremail", "Userpassword", "Roles", "IsActive", "Created_DT", "Lastupdated_DT")
SELECT 'admin', 'Administrator', 'admin@factory.com', 'Admin@123', 'ADMIN,PROCESS,QUALITY,OPERATOR', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM "LoginDetails" WHERE "Userid" = 'admin');

-- =============================================
-- Create Default Process User
-- =============================================

INSERT INTO "LoginDetails" ("Userid", "Username", "Useremail", "Userpassword", "Roles", "IsActive", "Created_DT", "Lastupdated_DT")
SELECT 'process', 'Process User', 'process@factory.com', 'Process@123', 'PROCESS,OPERATOR', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM "LoginDetails" WHERE "Userid" = 'process');

-- =============================================
-- Create Default Quality User
-- =============================================

INSERT INTO "LoginDetails" ("Userid", "Username", "Useremail", "Userpassword", "Roles", "IsActive", "Created_DT", "Lastupdated_DT")
SELECT 'quality', 'Quality User', 'quality@factory.com', 'Quality@123', 'QUALITY,OPERATOR', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM "LoginDetails" WHERE "Userid" = 'quality');

-- =============================================
-- Create Default Operator User
-- =============================================

INSERT INTO "LoginDetails" ("Userid", "Username", "Useremail", "Userpassword", "Roles", "IsActive", "Created_DT", "Lastupdated_DT")
SELECT 'operator', 'Operator User', 'operator@factory.com', 'Operator@123', 'OPERATOR', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM "LoginDetails" WHERE "Userid" = 'operator');

