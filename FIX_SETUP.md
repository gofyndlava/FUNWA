# Fix Setup Issues

## Problem
The `npm run dev` command might fail if dependencies aren't installed or configuration is missing.

## Solution

### Option 1: Use the Setup Script (Recommended)
```bash
# First time setup - installs everything
npm run setup

# Then start the app
npm run dev
```

### Option 2: Manual Setup

1. **Install Backend Dependencies:**
   ```bash
   npm install
   ```

2. **Install Frontend Dependencies:**
   ```bash
   cd client
   npm install
   cd ..
   ```

3. **Create .env File:**
   ```bash
   cp .env.example .env
   # Edit .env with your database credentials
   ```

4. **Start Both Servers:**
   ```bash
   npm run dev
   ```

### Option 3: Use the Start Script
```bash
# Make script executable (first time only)
chmod +x start.sh

# Run the script
./start.sh
```

## Troubleshooting

### Issue: "concurrently: command not found"
**Fix:** Install dependencies first
```bash
npm install
```

### Issue: "Cannot find module" errors
**Fix:** Make sure all dependencies are installed
```bash
npm install
cd client && npm install && cd ..
```

### Issue: Port already in use
**Fix:** Kill the process using the port or change ports
```bash
# Kill process on port 5000
lsof -ti:5000 | xargs kill -9

# Kill process on port 3000
lsof -ti:3000 | xargs kill -9
```

### Issue: Database connection errors
**Fix:** Check your .env file has correct database credentials
```bash
# Verify .env exists and has correct values
cat .env
```

### Issue: React app won't start
**Fix:** Make sure you're in the client directory when running npm install
```bash
cd client
rm -rf node_modules package-lock.json
npm install
cd ..
```

## Verify Installation

Run these commands to verify everything is set up:

```bash
# Check backend dependencies
ls node_modules | head -5

# Check frontend dependencies  
ls client/node_modules | head -5

# Check .env file exists
test -f .env && echo ".env exists" || echo ".env missing"
```

## Quick Fix All Command

Run this single command to fix everything:

```bash
npm install && cd client && npm install && cd .. && cp .env.example .env 2>/dev/null || echo "Please create .env manually" && npm run dev
```

