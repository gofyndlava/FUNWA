#!/bin/bash

echo "🚀 Setting up Local Database for Factory Utility"
echo "================================================"
echo ""

# Navigate to FUMI directory
cd "$(dirname "$0")"

# Check if Colima is available (preferred) or Docker
HAS_COLIMA=false
HAS_DOCKER=false

if command -v colima &> /dev/null; then
    HAS_COLIMA=true
    if colima status &> /dev/null; then
        STATUS=$(colima status 2>/dev/null | grep -i "status" | awk '{print $2}')
        if [ "$STATUS" = "Running" ]; then
            echo "✅ Colima is installed and running"
        else
            echo "📦 Starting Colima..."
            colima start --runtime docker
            echo "✅ Colima started"
        fi
    else
        echo "📦 Starting Colima (this may take a few minutes)..."
        colima start --runtime docker
        echo "✅ Colima started"
    fi
elif command -v docker &> /dev/null; then
    HAS_DOCKER=true
    if docker info &> /dev/null; then
        echo "✅ Docker is installed and running"
    else
        echo "❌ Docker is not running!"
        echo ""
        echo "Please start Docker or use Colima:"
        echo "  1. Install Colima: brew install colima"
        echo "  2. Start Colima: colima start"
        echo "  3. Run this script again"
        exit 1
    fi
else
    echo "❌ Neither Colima nor Docker is available!"
    echo ""
    echo "📥 Please install Colima (recommended):"
    echo "   brew install colima"
    echo "   colima start --runtime docker"
    echo ""
    echo "Or install Docker Desktop:"
    echo "   https://www.docker.com/products/docker-desktop"
    echo ""
    echo "After installing, run this script again"
    exit 1
fi

# Verify Docker is accessible (either through Colima or native)
if ! docker ps &> /dev/null; then
    echo "❌ Docker is not accessible!"
    echo ""
    if [ "$HAS_COLIMA" = true ]; then
        echo "Colima may need to be restarted:"
        echo "  colima restart"
    else
        echo "Please start Docker Desktop or install Colima"
    fi
    exit 1
fi
echo ""

# Create .env file for local database if it doesn't exist
if [ ! -f ".env" ]; then
    echo "📝 Creating .env file for local database..."
    cat > .env << 'EOF'
PORT=5000
NODE_ENV=development

# Local SQL Server (Docker)
DB_SERVER=localhost
DB_PORT=1433
DB_NAME=FactoryUtility
DB_USER=sa
DB_PASSWORD=FactoryUtility@123

# JWT Configuration
JWT_SECRET=factory-utility-secret-key-change-in-production
SESSION_SECRET=factory-utility-session-secret-change-in-production

# Client URL
CLIENT_URL=http://localhost:3000
EOF
    echo "✅ Created .env file"
else
    echo "📝 .env file already exists"
    echo "   Make sure it has local database settings:"
    echo "   DB_SERVER=localhost"
    echo "   DB_USER=sa"
    echo "   DB_PASSWORD=FactoryUtility@123"
fi

echo ""

# Start SQL Server
echo "📦 Starting SQL Server container..."
cd database
docker-compose up -d

echo ""
echo "⏳ Waiting for SQL Server to be ready (30-60 seconds)..."
echo ""

# Wait for SQL Server to be ready
max_attempts=30
attempt=0
while [ $attempt -lt $max_attempts ]; do
    if docker logs factory-utility-db 2>&1 | grep -q "SQL Server is now ready for client connections"; then
        echo ""
        echo "✅ SQL Server is ready!"
        break
    fi
    
    attempt=$((attempt + 1))
    echo -n "."
    sleep 2
done

if [ $attempt -eq $max_attempts ]; then
    echo ""
    echo "⚠️  SQL Server is starting but taking longer than expected"
    echo "   You can check logs with: docker logs factory-utility-db"
    echo ""
    read -p "Continue with database setup? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

echo ""
cd ..

# Setup database
echo "🔧 Setting up database (creating tables and users)..."
echo ""
npm run db:setup:local

echo ""
echo "================================================"
echo "✅ Local Database Setup Complete!"
echo "================================================"
echo ""
echo "Default Admin Credentials:"
echo "  Username: admin"
echo "  Password: Admin@123"
echo ""
echo "Next steps:"
echo "  1. Start the application: npm run dev"
echo "  2. Open: http://localhost:3000"
echo "  3. Login with admin credentials above"
echo ""
echo "Database commands:"
echo "  Start: npm run db:start"
echo "  Stop: npm run db:stop"
echo "  Logs: npm run db:logs"
echo ""

