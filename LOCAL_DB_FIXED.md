# ✅ Local Database Setup - Fixed!

Your database is now configured to run **locally** using Docker.

## 🚀 Quick Start (3 Commands)

### 1. Setup Everything Automatically
```bash
cd FUMI
./setup-local-db.sh
```

This will:
- ✅ Check Docker is installed and running
- ✅ Create `.env` file with local database settings
- ✅ Start SQL Server in Docker
- ✅ Create database, tables, and default users
- ✅ Show you the admin credentials

### 2. Or Do It Step by Step

**Start SQL Server:**
```bash
npm run db:start
```
Wait 30-60 seconds for it to start.

**Setup Database:**
```bash
npm run db:setup:local
```

### 3. Start Application
```bash
npm run dev
```

## 📝 What Was Fixed

1. ✅ Created **local database setup script** (`setup-local.js`)
2. ✅ Created **Docker configuration** (`database/docker-compose.yml`)
3. ✅ Created **local .env file** with localhost settings
4. ✅ Added **npm commands** for database management
5. ✅ Created **automated setup script** (`setup-local-db.sh`)

## 🗄️ Local Database Configuration

**Server:** `localhost:1433`  
**Database:** `FactoryUtility`  
**User:** `sa`  
**Password:** `FactoryUtility@123`

## 👤 Default Admin Login

After setup:
- **Username:** `admin`
- **Password:** `Admin@123`
- **Access:** Full (Admin, Process, Quality, Operator)

## 📋 Available Commands

```bash
# Database commands
npm run db:start          # Start SQL Server (Docker)
npm run db:stop           # Stop SQL Server
npm run db:logs           # View database logs
npm run db:setup:local    # Setup database (tables & users)

# Full automated setup
./setup-local-db.sh       # Everything in one command!

# Application
npm run dev               # Start frontend + backend
```

## 🐳 Docker Commands

```bash
# Start SQL Server
docker-compose -f database/docker-compose.yml up -d

# Stop SQL Server
docker-compose -f database/docker-compose.yml down

# View logs
docker logs factory-utility-db

# Check if running
docker ps
```

## ⚠️ Prerequisites

**Colima must be installed and running!**

1. Install Colima: `brew install colima`
2. Start Colima: `colima start --runtime docker`
3. Wait for it to fully start (first time takes 2-5 minutes)
4. Verify: `docker ps` should work
5. Run setup: `./setup-local-db.sh`

**Note:** Colima is our company-standard container runtime. See `database/COLIMA_SETUP.md` for details.

## 🔧 Troubleshooting

### Docker Not Running
```bash
# Check if Docker is running
docker ps

# If error, start Docker Desktop application first
```

### Port 1433 Already in Use
```bash
# Check what's using the port
lsof -i :1433

# Stop other SQL Server or change port in docker-compose.yml
```

### Connection Timeout
- Wait 30-60 seconds after starting container
- Check logs: `npm run db:logs`
- Verify Docker container is running: `docker ps`

### Database Setup Fails
- Make sure SQL Server is fully started (wait 60 seconds)
- Check `.env` file has correct settings
- Verify Docker container logs: `npm run db:logs`

## 📚 More Information

- **[QUICK_LOCAL_SETUP.md](QUICK_LOCAL_SETUP.md)** - Quick reference
- **[database/LOCAL_SETUP.md](database/LOCAL_SETUP.md)** - Detailed guide
- **[database/README.md](database/README.md)** - Database documentation

---

**Your database is now ready to run locally!** 🎉

Just run: `./setup-local-db.sh`

