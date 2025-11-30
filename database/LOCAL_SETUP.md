# Local Database Setup Guide

This guide helps you set up SQL Server to run locally on your machine.

## 🐳 Option 1: Colima (Company Standard - Recommended)

**Colima** is the company-standard container runtime for macOS/Linux. It's lightweight and provides Docker API compatibility.

### Prerequisites

1. **Install Colima**
   ```bash
   brew install colima
   ```

2. **Start Colima**
   ```bash
   colima start --runtime docker
   ```

3. **Verify Installation**
   ```bash
   colima status
   docker ps  # Should work through Colima
   ```

**For detailed Colima setup, see: [COLIMA_SETUP.md](COLIMA_SETUP.md)**

---

## 🐳 Option 2: Docker Desktop (Alternative)

If you prefer Docker Desktop (not company standard):

### Prerequisites

1. **Install Docker Desktop**
   - Download from: https://www.docker.com/products/docker-desktop
   - Install and start Docker Desktop
   - Verify: `docker --version`

**Note:** Company standard is Colima. Use Docker Desktop only if Colima is not available.

### Quick Setup (Colima)

1. **Ensure Colima is running**:
   ```bash
   colima status
   # If not running: colima start --runtime docker
   ```

2. **Start SQL Server**:
   ```bash
   cd FUMI/database
   docker-compose up -d
   ```

2. **Wait for SQL Server to be ready** (about 30 seconds):
   ```bash
   docker logs factory-utility-db -f
   # Wait for: "SQL Server is now ready for client connections"
   # Press Ctrl+C to exit
   ```

3. **Update .env file** (in FUMI root):
   ```env
   DB_SERVER=localhost
   DB_PORT=1433
   DB_NAME=FactoryUtility
   DB_USER=sa
   DB_PASSWORD=FactoryUtility@123
   ```

4. **Run database setup**:
   ```bash
   cd FUMI
   npm run db:setup:local
   ```

### Docker Commands

```bash
# Start SQL Server
docker-compose up -d

# Stop SQL Server
docker-compose down

# View logs
docker logs factory-utility-db

# Check if running
docker ps

# Remove everything (WARNING: Deletes data)
docker-compose down -v
```

### Default Docker Credentials

- **Server**: `localhost:1433`
- **Username**: `sa`
- **Password**: `FactoryUtility@123`
- **Database**: `FactoryUtility` (will be created)

---

## 🪟 Option 2: SQL Server Express (Windows Only)

If you're on Windows and prefer native SQL Server:

1. **Download SQL Server Express**:
   - https://www.microsoft.com/en-us/sql-server/sql-server-downloads
   - Install SQL Server Express with default settings

2. **Enable SQL Server Authentication**:
   - Open SQL Server Configuration Manager
   - Enable "Mixed Mode Authentication"

3. **Update .env file**:
   ```env
   DB_SERVER=localhost\\SQLEXPRESS
   DB_PORT=1433
   DB_NAME=FactoryUtility
   DB_USER=sa
   DB_PASSWORD=YourPasswordHere
   ```

4. **Run database setup**:
   ```bash
   npm run db:setup:local
   ```

---

## 🐘 Option 3: Azure SQL Edge (Lightweight)

For a lighter alternative:

```bash
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=FactoryUtility@123" \
  -p 1433:1433 --name sql-edge \
  -d mcr.microsoft.com/azure-sql-edge:latest
```

Then update `.env` and run setup.

---

## ✅ Verify Setup

After starting SQL Server, verify it's running:

### Docker
```bash
docker ps
# Should show factory-utility-db container
```

### Test Connection
```bash
cd FUMI
npm run db:setup:local
```

If successful, you'll see:
```
✅ Connected to SQL Server
✅ Database created
✅ Tables created
✅ Users created
```

---

## 🔧 Troubleshooting

### Docker Issues

**Docker not running?**
```bash
# Start Docker Desktop application first
# Then verify:
docker ps
```

**Port 1433 already in use?**
```bash
# Find what's using port 1433
lsof -i :1433

# Or change port in docker-compose.yml:
# ports:
#   - "1434:1433"  # Use 1434 instead
```

**Container won't start?**
```bash
# Check logs
docker logs factory-utility-db

# Remove and recreate
docker-compose down -v
docker-compose up -d
```

### Connection Issues

**Connection timeout?**
- Wait 30-60 seconds after starting container
- SQL Server takes time to initialize
- Check logs: `docker logs factory-utility-db`

**Authentication failed?**
- Verify password in `.env` matches docker-compose.yml
- Default password: `FactoryUtility@123`
- Make sure `.env` has correct credentials

**Database not found?**
- Run setup script: `npm run db:setup:local`
- It will create the database automatically

---

## 📝 Quick Reference

### Start Local Database
```bash
cd FUMI/database
docker-compose up -d
```

### Setup Database
```bash
cd FUMI
npm run db:setup:local
```

### Stop Database
```bash
cd FUMI/database
docker-compose down
```

### Default Credentials
- Server: `localhost:1433`
- User: `sa`
- Password: `FactoryUtility@123`

---

## 🎯 Next Steps

1. ✅ Start Docker SQL Server
2. ✅ Run database setup
3. ✅ Update `.env` file
4. ✅ Start application: `npm run dev`
5. ✅ Login with: `admin` / `Admin@123`

---

**Your database is now running locally!** 🎉

