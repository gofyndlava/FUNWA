# Database Setup Guide

This folder contains all database setup scripts for the Factory Utility application.

## 📁 Files

- **`schema.sql`** - Complete database schema with all tables
- **`default_user.sql`** - Default users creation (admin, process, quality, operator)
- **`setup.js`** - Automated database setup script (Node.js)

## 🚀 Quick Setup

### Option 1: Automated Setup (Recommended)

```bash
cd FUMI
npm install  # If not already installed
node database/setup.js
```

This will:
- ✅ Create the database if it doesn't exist
- ✅ Create all tables
- ✅ Create default users with proper roles
- ✅ Verify the setup

### Option 2: Manual SQL Server Setup

1. **Connect to SQL Server** using SQL Server Management Studio or sqlcmd

2. **Create Database** (if needed):
```sql
CREATE DATABASE [FactoryUtility];
GO
```

3. **Run Schema Script**:
```sql
USE [FactoryUtility];
GO
-- Copy and paste contents of schema.sql
```

4. **Create Default Users**:
```sql
USE [FactoryUtility];
GO
-- Copy and paste contents of default_user.sql
```

## 👤 Default Users

After setup, the following default users will be available:

| Username | Password | Roles | Access Level |
|----------|----------|-------|--------------|
| `admin` | `Admin@123` | ADMIN, PROCESS, QUALITY, OPERATOR | Full Access |
| `process` | `Process@123` | PROCESS, OPERATOR | Process Management |
| `quality` | `Quality@123` | QUALITY, OPERATOR | Quality Control |
| `operator` | `Operator@123` | OPERATOR | Basic Operations |

**⚠️ IMPORTANT**: Change all default passwords in production!

## 📊 Database Tables

The schema creates the following tables:

### Authentication
- `LoginDetails` - User accounts and authentication

### SPI Management
- `SpiMaster` - SPI records
- `Spichangehistory` - SPI change history
- `SpiModel` - SPI models catalog
- `SpiRoute` - SPI status routes

### Stencil Management
- `StencilMaster` - Stencil records
- `Stencilchangehistory` - Stencil change history
- `StencilModel` - Stencil models catalog
- `StencilRoute` - Stencil status routes

### SQG Management
- `SQGMaster` - SQG records
- `SQGchangehistory` - SQG change history

### Wave Management
- `WaveMaster` - Wave records
- `Wavechangehistory` - Wave change history
- `WaveModel` - Wave models catalog

### Scrap Management
- `HoldRelease` - Hold/Scrap records

### Monitoring
- `LastUpdated` - In-process stencil monitoring

## 🔧 Configuration

Update your `.env` file with database credentials:

```env
DB_SERVER=your_server
DB_PORT=49172
DB_NAME=FactoryUtility
DB_USER=your_user
DB_PASSWORD=your_password
```

## ✅ Verification

After setup, verify by logging in:
- Open the application: http://localhost:3000
- Login with: `admin` / `Admin@123`
- You should have full access to all features

## 🔐 Production Deployment

### Before Production:

1. **Change Default Passwords**:
```sql
USE [FactoryUtility];
GO

-- Update admin password
UPDATE LoginDetails 
SET Userpassword = 'YourStrongPasswordHere'
WHERE Userid = 'admin';

-- Update other default passwords
```

2. **Review Security Settings**:
- Use strong passwords
- Enable SQL Server authentication encryption
- Configure firewall rules
- Set up proper database backups

3. **Create Production Users**:
```sql
-- Example: Create production admin
INSERT INTO LoginDetails 
(Userid, Username, Useremail, Userpassword, Roles, IsActive)
VALUES 
('prodadmin', 'Production Admin', 'admin@company.com', 'StrongPassword123!', 'ADMIN,PROCESS,QUALITY,OPERATOR', 1);
```

## 🐛 Troubleshooting

**Database connection failed?**
- Verify SQL Server is running
- Check firewall settings
- Verify credentials in `.env`

**Tables already exist?**
- The script will skip existing tables
- To recreate, drop and recreate database (WARNING: This deletes all data!)

**User already exists?**
- The script will skip existing users
- To update, use UPDATE statement instead

---

**Database setup is production-ready!** ✅

