#!/bin/bash

# Factory Utility - Complete Setup Script
# This script sets up everything needed to run the application

echo "════════════════════════════════════════════════════════"
echo "  Factory Utility - Complete Setup"
echo "════════════════════════════════════════════════════════"
echo ""

# Check Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js 16+ first."
    echo "   Visit: https://nodejs.org/"
    exit 1
fi

NODE_VERSION=$(node -v)
echo "✅ Node.js found: $NODE_VERSION"
echo ""

# Step 1: Install Backend Dependencies
echo "📦 Step 1: Installing backend dependencies..."
if [ ! -d "node_modules" ]; then
    npm install
    if [ $? -ne 0 ]; then
        echo "❌ Failed to install backend dependencies"
        exit 1
    fi
    echo "✅ Backend dependencies installed"
else
    echo "✅ Backend dependencies already installed"
fi
echo ""

# Step 2: Install Frontend Dependencies
echo "📦 Step 2: Installing frontend dependencies..."
if [ ! -d "client/node_modules" ]; then
    cd client
    npm install
    if [ $? -ne 0 ]; then
        echo "❌ Failed to install frontend dependencies"
        exit 1
    fi
    cd ..
    echo "✅ Frontend dependencies installed"
else
    echo "✅ Frontend dependencies already installed"
fi
echo ""

# Step 3: Create .env file
echo "📝 Step 3: Setting up environment configuration..."
if [ ! -f ".env" ]; then
    if [ -f "env.example" ]; then
        cp env.example .env
        echo "✅ Created .env file from env.example"
    else
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
    echo "⚠️  IMPORTANT: Please review and update .env with your database credentials"
else
    echo "✅ .env file already exists"
fi
echo ""

# Step 4: Make start script executable
echo "🔧 Step 4: Setting up scripts..."
chmod +x start.sh 2>/dev/null
echo "✅ Scripts ready"
echo ""

# Final summary
echo "════════════════════════════════════════════════════════"
echo "  ✅ Setup Complete!"
echo "════════════════════════════════════════════════════════"
echo ""
echo "Next steps:"
echo "  1. Review/edit .env file with your database credentials"
echo "  2. Run: ./start.sh"
echo "     or: npm run dev"
echo ""
echo "The application will be available at:"
echo "  - Frontend: http://localhost:3000"
echo "  - Backend:  http://localhost:5000"
echo ""

