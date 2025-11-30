# FUMI - Project Structure

## 📁 Complete File Structure

```
FUMI/
│
├── 📄 README.md                    # Main documentation
├── 📄 GET_STARTED.md              # Quick start guide (3 steps)
├── 📄 QUICK_START.md              # Alternative quick start
├── 📄 FIX_SETUP.md                # Troubleshooting guide
├── 📄 MIGRATION_README.md         # Complete migration details
├── 📄 RUN_NOW.md                  # Immediate run instructions
├── 📄 STRUCTURE.md                # This file
│
├── 🔧 SETUP.sh                    # Complete setup script (executable)
├── 🚀 start.sh                    # Start script (executable)
├── 📄 env.example                 # Environment variables template
├── 📄 .env                        # Your configuration (created from env.example)
├── 📄 .gitignore                  # Git ignore file
│
├── 📦 package.json                # Backend dependencies & scripts
├── 📦 package-lock.json           # Dependency lock file
├── 📁 node_modules/               # Backend dependencies
│
├── 📁 server/                     # Node.js/Express Backend
│   ├── 📁 config/
│   │   └── database.js           # SQL Server connection
│   ├── 📁 middleware/
│   │   └── auth.js               # JWT authentication
│   ├── 📁 routes/
│   │   ├── auth.js               # Login/Logout routes
│   │   ├── spi.js                # SPI management routes
│   │   ├── stencil.js            # Stencil management routes
│   │   ├── sqg.js                # SQG management routes
│   │   ├── wave.js               # Wave management routes
│   │   └── scrap.js              # Scrap management routes
│   └── index.js                  # Server entry point
│
└── 📁 client/                     # React Frontend
    ├── 📦 package.json            # Frontend dependencies
    ├── 📁 node_modules/           # Frontend dependencies
    ├── 📁 public/
    │   └── index.html            # HTML template
    └── 📁 src/
        ├── index.js              # React entry point
        ├── index.css             # Global styles
        ├── App.js                # Main app component
        ├── 📁 components/
        │   ├── MasterLayout.js   # Main layout with navigation
        │   └── MasterLayout.css  # Layout styles
        ├── 📁 context/
        │   └── AuthContext.js    # Authentication context
        └── 📁 pages/
            ├── Login.js          # Login page
            ├── Login.css         # Login styles
            ├── Home.js           # Home page
            ├── UserAccess.js     # Access denied page
            ├── UserAccess.css    # Access denied styles
            ├── FormStyles.css    # Shared form styles
            ├── 📁 spi/
            │   ├── NewSPI.js
            │   ├── ChangeSPI.js
            │   ├── SPIHistory.js
            │   └── HistoryStyles.css
            ├── 📁 stencil/
            │   ├── NewStencil.js
            │   ├── ChangeStencil.js
            │   └── StencilHistory.js
            ├── 📁 sqg/
            │   ├── NewSQG.js
            │   ├── ChangeSQG.js
            │   └── SQGHistory.js
            ├── 📁 wave/
            │   ├── NewWave.js
            │   └── ChangeWave.js
            └── 📁 scrap/
                ├── HoldScrap.js
                └── HoldScrapReport.js
```

## 🔑 Key Files

### Setup & Configuration
- **SETUP.sh** - Complete automated setup (install deps, create .env)
- **start.sh** - Smart startup script (checks deps, creates .env if needed)
- **env.example** - Template for environment variables
- **.env** - Your actual configuration (create from env.example)

### Documentation
- **README.md** - Complete documentation
- **GET_STARTED.md** - Quick start (3 steps)
- **FIX_SETUP.md** - Troubleshooting guide

### Backend (server/)
- **index.js** - Main server file, sets up Express, routes, middleware
- **config/database.js** - SQL Server connection configuration
- **middleware/auth.js** - JWT authentication & authorization
- **routes/*.js** - API endpoints for each module

### Frontend (client/)
- **src/App.js** - Main React app with routing
- **src/pages/Login.js** - Login page
- **src/pages/*/***.js** - All feature pages (SPI, Stencil, SQG, Wave, Scrap)
- **src/components/MasterLayout.js** - Main layout with navigation menu

## 🎯 Entry Points

1. **Setup**: Run `./SETUP.sh`
2. **Start**: Run `./start.sh` or `npm run dev`
3. **Backend**: `server/index.js` starts on port 5000
4. **Frontend**: `client/src/index.js` starts React app on port 3000

## 📝 Quick Reference

| File/Folder | Purpose |
|-------------|---------|
| `SETUP.sh` | Complete setup automation |
| `start.sh` | Smart startup script |
| `server/index.js` | Backend server entry point |
| `client/src/index.js` | Frontend React entry point |
| `server/routes/` | All API endpoints |
| `client/src/pages/` | All React page components |
| `.env` | Environment configuration |

