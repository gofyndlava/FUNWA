# PostgreSQL Setup Guide - Complete

This guide will help you set up PostgreSQL locally and migrate from SQL Server seamlessly.

## 🎯 Why PostgreSQL?

- ✅ **Native ARM64 support** - Works perfectly on Apple Silicon
- ✅ **No emulation needed** - Faster and more efficient
- ✅ **Same functionality** - All features preserved
- ✅ **Easy migration** - Automatic query conversion
- ✅ **Production ready** - Can switch to SQL Server anytime

## 🚀 Quick Setup (Recommended)

### Single Command Setup

```bash
cd FUMI
./setup-postgres-local.sh
```

This will:
- ✅ Start Colima (if needed)
- ✅ Start PostgreSQL container
- ✅ Create database
- ✅ Create all tables
- ✅ Create default users
- ✅ Configure `.env` file

**That's it!** Your database is ready.

## 📋 Manual Setup

### Step 1: Start PostgreSQL

```bash
cd FUMI
npm run db:start:postgres
```

Wait 10-20 seconds for PostgreSQL to start.

### Step 2: Configure Environment

Copy PostgreSQL environment file:
```bash
cp env.postgres.example .env
```

Or manually edit `.env`:
```env
DB_TYPE=postgres
DB_SERVER=localhost
DB_PORT=5432
DB_NAME=FactoryUtility
DB_USER=postgres
DB_PASSWORD=FactoryUtility@123
```

### Step 3: Setup Database

```bash
npm run db:setup:postgres
```

This creates:
- ✅ Database: `FactoryUtility`
- ✅ All 20+ tables
- ✅ Default users (admin, process, quality, operator)

### Step 4: Start Application

```bash
npm run dev
```

Open http://localhost:3000 and login with `admin` / `Admin@123`

## ✅ Verification

Check everything is working:

```bash
# 1. Check PostgreSQL container
docker ps | grep postgres
# Should show: factory-utility-postgres

# 2. Check database connection
cd FUMI
node -e "require('./server/config/database-postgres').testConnection()"
# Should show: PostgreSQL connection successful

# 3. Check tables were created
docker exec factory-utility-postgres psql -U postgres -d FactoryUtility -c "\dt"
# Should list all tables
```

## 📊 Database Structure

All tables are created with the same structure:

### Authentication
- `LoginDetails` - User accounts

### SPI Management
- `SpiMaster`, `Spichangehistory`, `SpiModel`, `SpiRoute`

### Stencil Management
- `StencilMaster`, `Stencilchangehistory`, `StencilModel`, `StencilRoute`

### SQG Management
- `SQGMaster`, `SQGchangehistory`, `SQGRoute`

### Wave Management
- `WaveMaster`, `Wavechangehistory`, `WaveModel`, `WaveRoute`

### Other
- `HoldRelease` - Hold/Scrap tracking
- `LastUpdated` - Monitoring

**Total: 20+ tables** with proper relationships!

## 🔄 How Query Translation Works

The system automatically converts SQL Server syntax to PostgreSQL:

| SQL Server | PostgreSQL |
|------------|------------|
| `@param` | `$1, $2, ...` |
| `GETDATE()` | `CURRENT_TIMESTAMP` |
| `ISNULL()` | `COALESCE()` |
| `TOP 10` | `LIMIT 10` |
| `[TableName]` | `"TableName"` |
| Error 2627 | Error 23505 (mapped) |

**Your routes work without changes!**

## 👤 Default Users

| Username | Password | Roles |
|----------|----------|-------|
| `admin` | `Admin@123` | Full Access |
| `process` | `Process@123` | Process Management |
| `quality` | `Quality@123` | Quality Control |
| `operator` | `Operator@123` | Basic Operations |

## 🔧 Available Commands

```bash
# PostgreSQL Database
npm run db:start:postgres      # Start PostgreSQL
npm run db:stop:postgres       # Stop PostgreSQL
npm run db:logs:postgres       # View logs
npm run db:setup:postgres      # Setup database

# Application
npm run dev                    # Start frontend + backend
```

## 🐛 Troubleshooting

### PostgreSQL won't start

```bash
# Check Colima is running
colima status

# Check Docker is accessible
docker ps

# View PostgreSQL logs
npm run db:logs:postgres
```

### Connection refused

```bash
# Wait 20-30 seconds after starting container
# PostgreSQL takes time to initialize

# Check if container is running
docker ps | grep postgres

# Check logs for errors
docker logs factory-utility-postgres
```

### Database setup fails

```bash
# Make sure PostgreSQL is fully started
docker logs factory-utility-postgres | grep "ready to accept"

# Check .env file has correct settings
cat .env | grep DB_

# Try setup again
npm run db:setup:postgres
```

### Tables not found

```bash
# Verify tables were created
docker exec factory-utility-postgres psql -U postgres -d FactoryUtility -c "\dt"

# If empty, run setup again
npm run db:setup:postgres
```

## 🔄 Switching Between Databases

### Use PostgreSQL (Local)
```env
DB_TYPE=postgres
DB_SERVER=localhost
DB_PORT=5432
```

### Use SQL Server (Production/Remote)
```env
DB_SERVER=20.198.94.108
DB_PORT=49172
# Remove DB_TYPE or set DB_TYPE=sqlserver
```

The application automatically detects which database to use!

## 📝 PostgreSQL vs SQL Server

### Differences Handled Automatically

1. **Parameter syntax**: `@param` → `$1` (auto-converted)
2. **Date functions**: `GETDATE()` → `CURRENT_TIMESTAMP` (auto-converted)
3. **Null handling**: `ISNULL()` → `COALESCE()` (auto-converted)
4. **Case sensitivity**: Tables quoted automatically
5. **Error codes**: Mapped to match SQL Server codes

### Same Functionality

- ✅ All CRUD operations
- ✅ Transactions
- ✅ Foreign keys
- ✅ Indexes
- ✅ All business logic

## 🎯 Next Steps

1. ✅ Run setup: `./setup-postgres-local.sh`
2. ✅ Start app: `npm run dev`
3. ✅ Login: `admin` / `Admin@123`
4. ✅ Test all features
5. ✅ Ready for development!

---

**PostgreSQL is now your local database!** 🎉

All functionality remains the same, but now you have:
- ✅ Native ARM64 support
- ✅ Faster local development
- ✅ No compatibility issues
- ✅ Seamless production deployment (SQL Server still works)

