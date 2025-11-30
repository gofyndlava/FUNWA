# Production Deployment Guide

This guide provides step-by-step instructions for deploying the Factory Utility database to production.

## 📋 Pre-Deployment Checklist

- [ ] SQL Server instance is available and accessible
- [ ] Database credentials have been secured
- [ ] Backup strategy is in place
- [ ] Firewall rules configured
- [ ] SSL/TLS certificates configured (recommended)
- [ ] All default passwords will be changed

## 🚀 Step-by-Step Deployment

### Step 1: Connect to SQL Server

Connect to your SQL Server instance using:
- **SQL Server Management Studio (SSMS)** - Recommended
- **sqlcmd** - Command line tool
- **Azure Data Studio** - Cross-platform alternative

### Step 2: Create Database

**Option A: Using SQL Script**
```sql
-- Run create_database.sql
-- Or manually:
CREATE DATABASE [FactoryUtility];
GO
```

**Option B: Using Automated Script**
```bash
cd FUMI/database
node setup.js
```

### Step 3: Create Schema

Run the schema script to create all tables:

```sql
USE [FactoryUtility];
GO

-- Copy and paste contents of schema.sql
-- Or run via command line:
sqlcmd -S your_server -d FactoryUtility -i schema.sql
```

### Step 4: Create Default Users

Create initial users with default passwords:

```sql
USE [FactoryUtility];
GO

-- Copy and paste contents of default_user.sql
```

**Default Credentials Created:**
- `admin` / `Admin@123` (Full Access)
- `process` / `Process@123` (Process Management)
- `quality` / `Quality@123` (Quality Control)
- `operator` / `Operator@123` (Basic Operations)

### Step 5: Update Passwords ⚠️ CRITICAL

**BEFORE GOING LIVE, update all passwords:**

```sql
USE [FactoryUtility];
GO

-- Update admin password
UPDATE LoginDetails 
SET Userpassword = 'YourVeryStrongPassword123!@#'
WHERE Userid = 'admin';

-- Update other user passwords similarly
-- Or run update_passwords.sql and customize
```

### Step 6: Verify Setup

Run verification queries:

```sql
-- Check tables
SELECT COUNT(*) as TableCount 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_TYPE = 'BASE TABLE';

-- Check users
SELECT Userid, Username, Roles, IsActive 
FROM LoginDetails;

-- Check routes
SELECT * FROM SpiRoute;
SELECT * FROM StencilRoute;
SELECT * FROM SQGRoute;
SELECT * FROM WaveRoute;
```

### Step 7: Configure Application

Update `.env` file in the application:

```env
DB_SERVER=your_production_server
DB_PORT=1433
DB_NAME=FactoryUtility
DB_USER=your_db_user
DB_PASSWORD=your_secure_password
```

## 🔐 Security Best Practices

### 1. Password Policy

- **Minimum Length**: 12 characters
- **Complexity**: Mix of uppercase, lowercase, numbers, and symbols
- **Rotation**: Change passwords every 90 days
- **No Defaults**: Never use default passwords in production

### 2. Database Security

- Use **Windows Authentication** when possible
- If using SQL Authentication, use **strong passwords**
- Enable **SSL/TLS encryption** for connections
- Restrict **network access** using firewall rules
- Use **least privilege** principle for database users

### 3. Backup Strategy

Set up regular backups:

```sql
-- Full backup daily
BACKUP DATABASE [FactoryUtility]
TO DISK = 'C:\Backups\FactoryUtility_Full.bak'
WITH COMPRESSION, CHECKSUM;

-- Transaction log backup every hour (if using FULL recovery)
BACKUP LOG [FactoryUtility]
TO DISK = 'C:\Backups\FactoryUtility_Log.trn'
WITH COMPRESSION, CHECKSUM;
```

### 4. Monitoring

- Set up **SQL Server alerts** for errors
- Monitor **database size** and growth
- Track **failed login attempts**
- Review **audit logs** regularly

## 📊 Database Maintenance

### Regular Tasks

1. **Index Maintenance**
   ```sql
   -- Rebuild indexes weekly
   ALTER INDEX ALL ON SpiMaster REBUILD;
   ALTER INDEX ALL ON StencilMaster REBUILD;
   ```

2. **Statistics Update**
   ```sql
   -- Update statistics weekly
   UPDATE STATISTICS SpiMaster;
   UPDATE STATISTICS StencilMaster;
   ```

3. **Database Cleanup**
   ```sql
   -- Archive old history records (example)
   -- DELETE FROM Spichangehistory 
   -- WHERE created_DT < DATEADD(year, -1, GETDATE());
   ```

## 🧪 Testing Checklist

Before going live:

- [ ] All tables created successfully
- [ ] Default users can log in
- [ ] Passwords changed from defaults
- [ ] Application can connect to database
- [ ] CRUD operations work correctly
- [ ] Role-based access control works
- [ ] History tracking works
- [ ] Backup/restore tested

## 🔄 Migration from Existing Database

If migrating from an existing database:

1. **Backup existing database**
   ```sql
   BACKUP DATABASE [FactoryUtility_Old]
   TO DISK = 'C:\Backups\FactoryUtility_Old.bak';
   ```

2. **Export data** (if needed)
   - Use SQL Server Import/Export Wizard
   - Or write custom migration scripts

3. **Import to new database**
   - Match column names and types
   - Verify data integrity

## 🆘 Troubleshooting

### Connection Issues

**Error: Cannot connect to server**
- Check firewall rules
- Verify SQL Server is running
- Check network connectivity
- Verify credentials

**Error: Login failed**
- Verify username and password
- Check SQL Server authentication mode
- Verify user has access to database

### Database Issues

**Error: Table already exists**
- The script uses `IF NOT EXISTS` checks
- Safe to re-run, will skip existing objects

**Error: Foreign key violation**
- Check data integrity
- Verify referenced records exist

### Performance Issues

- Check for missing indexes
- Review query execution plans
- Monitor resource usage
- Consider partitioning large tables

## 📞 Support

For issues or questions:
1. Check the application logs
2. Review SQL Server error logs
3. Consult the README.md in this folder
4. Review application documentation

## ✅ Post-Deployment

After successful deployment:

1. **Document credentials** securely
2. **Test all features** thoroughly
3. **Monitor performance** for first week
4. **Set up automated backups**
5. **Configure alerts**
6. **Train users** on new system

---

**🎉 Your database is production-ready!**

Remember: Security is an ongoing process, not a one-time setup.

