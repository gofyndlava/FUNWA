# Colima Setup Guide

This guide helps you set up SQL Server to run locally using **Colima** (company-standard container runtime).

## 🎯 What is Colima?

Colima is a lightweight, open-source alternative to Docker Desktop that provides Docker API compatibility. It's perfect for running containers on macOS and Linux.

## 📋 Prerequisites

- **Homebrew** installed on macOS
- Terminal access

## 🚀 Quick Setup

### Step 1: Install Colima

```bash
brew install colima
```

### Step 2: Start Colima

```bash
colima start --runtime docker
```

**First time setup takes 2-5 minutes** - be patient!

### Step 3: Verify Setup

```bash
# Check Colima status
colima status

# Verify Docker is working
docker ps
```

### Step 4: Start SQL Server

```bash
cd FUMI
npm run db:start
```

### Step 5: Setup Database

```bash
npm run db:setup:local
```

## 📝 Automated Setup Script

We provide an automated script that checks and starts Colima:

```bash
cd FUMI
./database/colima-setup.sh
```

Or use the full setup:

```bash
./setup-local-db.sh
```

## 🔧 Colima Commands

### Start/Stop Colima

```bash
# Start Colima
colima start --runtime docker

# Stop Colima
colima stop

# Restart Colima
colima restart

# Check status
colima status

# View logs
colima logs
```

### Delete and Recreate (if needed)

```bash
colima delete
colima start --runtime docker
```

## ✅ Verify Everything Works

After starting Colima:

1. **Check Colima is running:**
   ```bash
   colima status
   ```
   Should show: `Status: Running`

2. **Check Docker is accessible:**
   ```bash
   docker ps
   ```
   Should show: `CONTAINER ID   IMAGE   COMMAND   CREATED   STATUS   PORTS   NAMES`

3. **Start SQL Server:**
   ```bash
   cd FUMI
   npm run db:start
   ```

4. **Check SQL Server container:**
   ```bash
   docker ps
   ```
   Should show `factory-utility-db` container

## 🐛 Troubleshooting

### Colima won't start

**Error: "colima: command not found"**
```bash
# Install Colima
brew install colima

# Verify installation
colima version
```

**Error: "Cannot connect to Docker daemon"**
```bash
# Restart Colima
colima restart

# Wait 30 seconds, then check
docker ps
```

### SQL Server won't start

**Error: "Port 1433 already in use"**
```bash
# Find what's using the port
lsof -i :1433

# Stop the process or change port in docker-compose.yml
```

**Error: "Container won't start"**
```bash
# Check Colima is running
colima status

# Check Docker is accessible
docker ps

# View container logs
docker logs factory-utility-db
```

### Docker commands not working

**Error: "Cannot connect to Docker daemon"**
```bash
# Restart Colima
colima restart

# Verify environment
docker context ls

# Should show: colima (current)
```

## 🔄 Migration from Docker Desktop

If you were using Docker Desktop before:

1. **Stop Docker Desktop** (if running)
   - Quit Docker Desktop application

2. **Install Colima:**
   ```bash
   brew install colima
   ```

3. **Start Colima:**
   ```bash
   colima start --runtime docker
   ```

4. **Verify migration:**
   ```bash
   docker ps  # Should work with Colima now
   ```

5. **Start SQL Server:**
   ```bash
   cd FUMI
   npm run db:start
   ```

**Note:** Your existing containers and volumes will work with Colima. No data migration needed!

## 📊 Colima vs Docker Desktop

| Feature | Colima | Docker Desktop |
|---------|--------|----------------|
| **License** | Open Source | Commercial |
| **Resource Usage** | Lighter | Heavier |
| **Setup** | Command-line | GUI + CLI |
| **Docker CLI** | ✅ Compatible | ✅ Native |
| **docker-compose** | ✅ Works | ✅ Works |
| **Company Standard** | ✅ Yes | ❌ No |

## 🎯 Quick Reference

```bash
# Install Colima
brew install colima

# Start Colima (first time - takes a few minutes)
colima start --runtime docker

# Check status
colima status

# Start SQL Server
cd FUMI && npm run db:start

# Setup database
npm run db:setup:local

# Stop SQL Server
npm run db:stop

# Stop Colima (when done)
colima stop
```

## 📚 Additional Resources

- **Colima GitHub:** https://github.com/abiosoft/colima
- **Colima Documentation:** https://github.com/abiosoft/colima/blob/main/docs/README.md
- **Company SOP:** [Link from your company]

---

**Colima is now your standard container runtime!** ✅

All Docker commands work the same way with Colima. No changes needed to your workflow.

