# 🚀 Run the Application NOW

## Quick Steps

### 1. Install Dependencies (if not done already)

```bash
# Install backend dependencies
npm install

# Install frontend dependencies
cd client
npm install
cd ..
```

### 2. Verify .env File Exists

The `.env` file should already be created with default values. If not:
```bash
cp .env.example .env
```

### 3. Start Both Servers

```bash
npm run dev
```

This will start:
- **Backend**: http://localhost:5000
- **Frontend**: http://localhost:3000 (will open automatically)

## Alternative: Start Servers Separately

If `npm run dev` doesn't work, open **two terminal windows**:

**Terminal 1 (Backend):**
```bash
npm run server
```

**Terminal 2 (Frontend):**
```bash
npm run client
```

## If You Get Errors

### Error: "concurrently: command not found"
```bash
npm install
```

### Error: "Cannot find module"
```bash
# Reinstall all dependencies
rm -rf node_modules client/node_modules
npm install
cd client && npm install && cd ..
```

### Error: "Port 3000 already in use"
```bash
# Kill process on port 3000
lsof -ti:3000 | xargs kill -9

# Or change React port (edit client/package.json)
# Add: "start": "PORT=3001 react-scripts start"
```

### Error: "Port 5000 already in use"
```bash
# Kill process on port 5000
lsof -ti:5000 | xargs kill -9

# Or change backend port (edit .env)
# PORT=5001
```

## Verify Everything Works

1. Backend should show: `Server is running on port 5000`
2. Frontend should open in browser at http://localhost:3000
3. You should see the login page

## Need Help?

See `FIX_SETUP.md` for detailed troubleshooting.

