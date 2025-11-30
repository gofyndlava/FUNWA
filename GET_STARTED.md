# 🚀 Get Started in 3 Steps

## Step 1: Run Setup

```bash
./SETUP.sh
```

This will:
- Install all backend dependencies
- Install all frontend dependencies  
- Create `.env` file with default configuration

## Step 2: Configure Database (Optional)

Edit `.env` file if your database credentials are different:

```bash
nano .env
# or
open .env
```

Update these values if needed:
```
DB_SERVER=your_server
DB_PORT=49172
DB_NAME=FactoryUtility
DB_USER=your_user
DB_PASSWORD=your_password
```

## Step 3: Start the Application

```bash
./start.sh
```

Or simply:
```bash
npm run dev
```

## That's It! 🎉

The application will start:
- **Backend**: http://localhost:5000
- **Frontend**: http://localhost:3000 (opens automatically)

---

## Alternative: Manual Setup

If you prefer manual setup:

```bash
# 1. Install dependencies
npm install
cd client && npm install && cd ..

# 2. Create .env file
cp env.example .env

# 3. Start application
npm run dev
```

## Troubleshooting

**Port already in use?**
```bash
lsof -ti:5000 | xargs kill -9  # Kill backend
lsof -ti:3000 | xargs kill -9  # Kill frontend
```

**Database connection error?**
- Check your `.env` file has correct database credentials
- Verify SQL Server is accessible

**Dependencies not found?**
```bash
rm -rf node_modules client/node_modules
npm install
cd client && npm install && cd ..
```

For more help, see `FIX_SETUP.md`

