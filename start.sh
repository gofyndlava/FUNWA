#!/bin/bash

# Factory Utility - Robust Start Script
# This script ensures clean startup by killing conflicting processes first

echo "🚀 Starting Factory Utility Application..."
echo ""

# Step 1: Kill any existing processes
echo "🧹 Step 1: Cleaning up existing processes..."
pkill -9 -f "node.*server/index.js" 2>/dev/null
pkill -9 -f "nodemon" 2>/dev/null
pkill -9 -f "react-scripts" 2>/dev/null
pkill -9 -f "concurrently" 2>/dev/null

# Kill processes on ports
lsof -ti:5000 | xargs kill -9 2>/dev/null
lsof -ti:3000 | xargs kill -9 2>/dev/null

# Wait for processes to die
sleep 2

echo "✅ Cleanup complete"
echo ""

# Step 2: Check if backend dependencies are installed
if [ ! -d "node_modules" ]; then
    echo "📦 Step 2: Installing backend dependencies..."
    npm install
    if [ $? -ne 0 ]; then
        echo "❌ Failed to install backend dependencies"
        exit 1
    fi
    echo ""
else
    echo "✅ Backend dependencies already installed"
fi

# Step 3: Check if frontend dependencies are installed
if [ ! -d "client/node_modules" ]; then
    echo "📦 Step 3: Installing frontend dependencies..."
    cd client
    npm install
    if [ $? -ne 0 ]; then
        echo "❌ Failed to install frontend dependencies"
        exit 1
    fi
    cd ..
    echo ""
else
    echo "✅ Frontend dependencies already installed"
fi

# Step 4: Check if .env file exists
if [ ! -f ".env" ]; then
    echo "📝 Step 4: Creating .env file..."
    if [ -f "env.example" ]; then
        cp env.example .env
        echo "✅ Created .env file from env.example"
        echo "   Please edit .env with your database credentials if needed."
    else
        echo "⚠️  env.example not found. Creating default .env file..."
        cat > .env << 'EOF'
PORT=5000
NODE_ENV=development
DB_SERVER=20.198.94.108
DB_PORT=49172
DB_NAME=FactoryUtility
DB_USER=wtsqluser
DB_PASSWORD=Password@1
JWT_SECRET=factory-utility-secret-key-change-in-production
SESSION_SECRET=factory-utility-session-secret-change-in-production
CLIENT_URL=http://localhost:3000
EOF
        echo "✅ Created default .env file"
    fi
    echo ""
fi

# Step 5: Verify ports are free
echo "🔍 Step 5: Verifying ports are free..."
PORT_5000_IN_USE=$(lsof -Pi :5000 -sTCP:LISTEN -t 2>/dev/null)
PORT_3000_IN_USE=$(lsof -Pi :3000 -sTCP:LISTEN -t 2>/dev/null)

if [ ! -z "$PORT_5000_IN_USE" ]; then
    echo "⚠️  Port 5000 is still in use. Attempting to kill process $PORT_5000_IN_USE..."
    kill -9 $PORT_5000_IN_USE 2>/dev/null
    sleep 1
    if lsof -Pi :5000 -sTCP:LISTEN -t >/dev/null 2>&1 ; then
        echo "❌ Could not free port 5000. Please run: ./cleanup.sh"
        exit 1
    fi
fi

if [ ! -z "$PORT_3000_IN_USE" ]; then
    echo "⚠️  Port 3000 is still in use. Attempting to kill process $PORT_3000_IN_USE..."
    kill -9 $PORT_3000_IN_USE 2>/dev/null
    sleep 1
    if lsof -Pi :3000 -sTCP:LISTEN -t >/dev/null 2>&1 ; then
        echo "❌ Could not free port 3000. Please run: ./cleanup.sh"
        exit 1
    fi
fi

echo "✅ Ports are free"
echo ""

# Step 6: Start both servers
echo "✅ Starting backend and frontend servers..."
echo "   Backend:  http://localhost:5000"
echo "   Frontend: http://localhost:3000"
echo ""
echo "Press Ctrl+C to stop both servers"
echo ""

npm run dev
