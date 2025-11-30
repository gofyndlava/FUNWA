# 🚀 Quick Local Database Setup

Get your database running locally in 3 steps!

## Step 0: Setup Colima (First Time Only)

**Colima is our company-standard container runtime.**

```bash
# Install Colima
brew install colima

# Start Colima (first time takes 2-5 minutes)
colima start --runtime docker

# Verify it's working
docker ps
```

**For detailed Colima setup, see: [database/COLIMA_SETUP.md](database/COLIMA_SETUP.md)**

## Step 1: Start SQL Server

```bash
cd FUMI
npm run db:start
```

Or manually:
```bash
cd FUMI/database
docker-compose up -d
```

Wait 30-60 seconds for SQL Server to start.

## Step 2: Configure Local Database

Copy the local environment file:
```bash
cd FUMI
cp env.local.example .env
```

This sets up:
- Server: `localhost:1433`
- User: `sa`
- Password: `FactoryUtility@123`

## Step 3: Setup Database

```bash
npm run db:setup:local
```

This creates:
- ✅ Database
- ✅ All tables
- ✅ Default users

## ✅ Done!

Your local database is ready!

**Default Admin Login:**
- Username: `admin`
- Password: `Admin@123`

## Start Application

```bash
npm run dev
```

Then login at: http://localhost:3000

---

## 📝 Useful Commands

```bash
# Start database
npm run db:start

# Stop database
npm run db:stop

# View database logs
npm run db:logs

# Setup database
npm run db:setup:local

# Check if database is running
docker ps
```

---

## ⚠️ Prerequisites

**Colima must be installed and running!**

```bash
# Install Colima (one-time)
brew install colima

# Start Colima (first time takes a few minutes)
colima start --runtime docker

# Verify
colima status
docker ps
```

**Note:** Colima is our company-standard container runtime. Docker Desktop is also supported but not recommended.

---

**Need help?** 
- Colima setup: `database/COLIMA_SETUP.md`
- General setup: `database/LOCAL_SETUP.md`

