# 🚀 Quick Start Guide

## Installation & Run (3 Steps)

### Step 1: Install Dependencies
```bash
# Install backend dependencies
npm install

# Install frontend dependencies
cd client
npm install
cd ..
```

### Step 2: Configure Database
Create a `.env` file in the root directory:
```bash
cp .env.example .env
```

Edit `.env` with your database credentials:
```env
DB_SERVER=20.198.94.108
DB_PORT=49172
DB_NAME=FactoryUtility
DB_USER=wtsqluser
DB_PASSWORD=Password@1
```

### Step 3: Run the Application
```bash
# Start both servers (recommended)
npm run dev

# Or start separately:
# Terminal 1: npm run server
# Terminal 2: npm run client
```

## Access

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:5000/api

## Login

Use your existing database credentials from the `LoginDetails` table.

---

**That's it!** The application is now running on your Mac (or any platform) with the same functionality as the original ASP.NET version.

For detailed documentation, see `MIGRATION_README.md`.

