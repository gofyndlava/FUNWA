# ⚠️ SQL Server ARM64 Compatibility Issue

## Problem

SQL Server (and Azure SQL Edge) have compatibility issues running on **Apple Silicon (ARM64)** through Colima. The container starts but SQL Server crashes due to memory mapping issues.

## Solutions

### Option 1: Use x86_64 Emulation (Recommended for SQL Server)

Start Colima with x86_64 (Intel) architecture emulation:

```bash
# Stop current Colima
colima stop

# Delete current instance
colima delete

# Start Colima with x86_64 architecture
colima start --arch x86_64 --runtime docker

# Now try starting SQL Server again
cd FUMI
npm run db:start
```

**Note:** This will be slower due to emulation, but SQL Server should work.

### Option 2: Use Remote SQL Server

Connect to your existing remote SQL Server:

1. Update `.env` file:
```env
DB_SERVER=20.198.94.108
DB_PORT=49172
DB_NAME=FactoryUtility
DB_USER=wtsqluser
DB_PASSWORD=Password@1
```

2. Skip local database setup:
```bash
cd FUMI
npm run dev
```

### Option 3: Use SQLite for Local Development (Alternative)

For local development, we could migrate to SQLite which works natively on ARM64. This would require schema changes.

## Current Status

- ✅ Colima is installed and running
- ✅ Docker is working
- ✅ docker-compose is installed
- ❌ SQL Server container starts but crashes on ARM64

## Recommended Next Step

**Try Option 1** (x86_64 emulation):

```bash
colima stop
colima delete
colima start --arch x86_64 --runtime docker
cd FUMI/database
/opt/homebrew/bin/docker-compose up -d
```

Wait 60 seconds, then check logs:
```bash
docker logs factory-utility-db
```

If SQL Server starts successfully, you should see: "SQL Server is now ready for client connections"

---

**For now, you can use the remote SQL Server connection while we resolve the ARM64 issue.**

