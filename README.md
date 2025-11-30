# Factory Utility Management System - React/Node.js Version

**FUMI** = **F**actory **U**tility **M**anagement **I**mplementation

This is a complete migration of the ASP.NET Web Forms application to a modern React + Node.js stack. All functionality is preserved with the same business logic and UI/UX.

---

## 🚀 Quick Start (3 Steps)

### Step 1: Run Setup
```bash
./SETUP.sh
```
This installs all dependencies and creates the `.env` file.

### Step 2: Setup Local PostgreSQL Database
```bash
# Automated setup (recommended)
./setup-postgres-local.sh

# Or manual setup
npm run db:start:postgres
npm run db:setup:postgres
```

PostgreSQL works natively on ARM64 (Apple Silicon) - no emulation needed! See [POSTGRES_SETUP_GUIDE.md](POSTGRES_SETUP_GUIDE.md) for details.

**For remote SQL Server**: Configure `.env` with your remote server credentials and use `npm run db:setup`.

### Step 3: Start the Application
```bash
./start.sh
```
Or simply: `npm run dev`

**That's it!** The app will be available at:
- **Frontend**: http://localhost:3000
- **Backend**: http://localhost:5000

For detailed instructions, see **[GET_STARTED.md](GET_STARTED.md)**

---

## 📁 Project Structure

```
FUMI/
├── server/              # Node.js/Express Backend
│   ├── config/         # Database configuration
│   ├── middleware/     # Authentication middleware
│   ├── routes/         # API routes (auth, spi, stencil, sqg, wave, scrap)
│   └── index.js        # Server entry point
├── client/             # React Frontend
│   ├── src/
│   │   ├── components/ # Reusable components (MasterLayout)
│   │   ├── context/    # React Context (Auth)
│   │   ├── pages/      # Page components (Login, SPI, Stencil, etc.)
│   │   └── App.js      # Main app component
│   └── public/
├── package.json        # Backend dependencies & scripts
├── env.example         # Environment variables template
├── .env               # Your configuration (create from env.example)
├── SETUP.sh           # Complete setup script
└── start.sh           # Startup script
```

---

## 🔧 Available Commands

| Command | Description |
|---------|-------------|
| `./SETUP.sh` | Complete setup (installs everything) |
| `./start.sh` | Start both servers (checks dependencies first) |
| `npm run dev` | Start both backend and frontend |
| `npm run server` | Start only backend server |
| `npm run client` | Start only frontend (React app) |
| `npm run install-all` | Install all dependencies |
| `npm run build` | Build React app for production |
| `npm run db:setup` | Setup database (create tables and default users) |

---

## 📋 Features

✅ **User Authentication** - Login/Logout with JWT tokens  
✅ **Role-based Access Control** - Admin, Process, Quality, Operator roles  
✅ **SPI Management** - Create, Change Status, View History  
✅ **Stencil Management** - Create, Change Status, View History  
✅ **SQG Management** - Create, View History  
✅ **Wave Management** - Create new waves  
✅ **Scrap Management** - Hold/Scrap operations  
✅ **Same UI/UX** - Identical to original ASP.NET application  

---

## ⚙️ Configuration

### Environment Variables (.env)

The application uses these environment variables (defaults provided):

```env
PORT=5000                    # Backend server port
NODE_ENV=development         # Environment mode
DB_SERVER=20.198.94.108      # SQL Server address
DB_PORT=49172                # SQL Server port
DB_NAME=FactoryUtility       # Database name
DB_USER=wtsqluser            # Database user
DB_PASSWORD=Password@1       # Database password
JWT_SECRET=...               # JWT token secret
SESSION_SECRET=...           # Session secret
CLIENT_URL=http://localhost:3000  # Frontend URL (for CORS)
```

---

## 🐛 Troubleshooting

### Port Already in Use
```bash
# Kill process on port 5000 (backend)
lsof -ti:5000 | xargs kill -9

# Kill process on port 3000 (frontend)
lsof -ti:3000 | xargs kill -9
```

### Database Connection Error
- Verify `.env` file has correct database credentials
- Check SQL Server is accessible from your network
- Verify firewall settings allow SQL Server connections

### Dependencies Not Found
```bash
# Clean and reinstall
rm -rf node_modules client/node_modules
npm install
cd client && npm install && cd ..
```

For more troubleshooting, see **[FIX_SETUP.md](FIX_SETUP.md)**

---

## 🔄 Migration Notes

This is a complete migration from ASP.NET Web Forms to React/Node.js:

### Preserved
- ✅ Same database schema (no changes needed)
- ✅ Same business logic
- ✅ Same UI/UX appearance  
- ✅ All features and functionality

### Improved
- ✅ Cross-platform (Windows, macOS, Linux)
- ✅ Modern React UI with better state management
- ✅ RESTful API architecture
- ✅ JWT-based authentication
- ✅ Better error handling
- ✅ Modular code structure

---

## 📚 Documentation

- **[GET_STARTED.md](GET_STARTED.md)** - Quick start guide (3 steps) ⭐ Start here!
- **[STRUCTURE.md](STRUCTURE.md)** - Complete file structure
- **[QUICK_START.md](QUICK_START.md)** - Alternative quick start
- **[FIX_SETUP.md](FIX_SETUP.md)** - Troubleshooting guide
- **[MIGRATION_README.md](MIGRATION_README.md)** - Complete migration documentation

---

## 🎯 Getting Started

1. **Run setup**: `./SETUP.sh`
2. **Configure database**: Edit `.env` if needed
3. **Start application**: `./start.sh` or `npm run dev`

That's it! The application is ready to use.

---

**Ready to run!** 🚀
