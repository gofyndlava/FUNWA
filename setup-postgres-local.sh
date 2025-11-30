#!/bin/bash

echo "🚀 Setting up PostgreSQL Local Database for Factory Utility"
echo "=========================================================="
echo ""

# Navigate to FUMI directory
cd "$(dirname "$0")"

# Check if Colima or Docker is available
HAS_COLIMA=false
HAS_DOCKER=false

if command -v colima &> /dev/null; then
    HAS_COLIMA=true
    if ! colima status &> /dev/null; then
        echo "📦 Starting Colima (this may take a few minutes)..."
        colima start --runtime docker
    else
        STATUS=$(colima status 2>/dev/null | grep -i "status" | awk '{print $2}')
        if [ "$STATUS" != "Running" ]; then
            echo "📦 Starting Colima..."
            colima start --runtime docker
        fi
    fi
    echo "✅ Colima is installed and running"
elif command -v docker &> /dev/null; then
    HAS_DOCKER=true
    if ! docker info &> /dev/null; then
        echo "❌ Docker is not running!"
        echo "Please start Docker Desktop or install Colima: brew install colima"
        exit 1
    fi
    echo "✅ Docker is installed and running"
else
    echo "❌ Neither Colima nor Docker is available!"
    echo "Please install Colima: brew install colima"
    exit 1
fi

# Verify Docker CLI is accessible
if ! docker ps &> /dev/null; then
    echo "❌ Docker CLI is not accessible!"
    if [ "$HAS_COLIMA" = true ]; then
        echo "Try restarting Colima: colima restart"
    fi
    exit 1
fi

# Create .env file for PostgreSQL if it doesn't exist
if [ ! -f ".env" ]; then
    echo "📝 Creating .env file for PostgreSQL..."
    cat > .env << 'EOF'
PORT=5000
NODE_ENV=development

# PostgreSQL Database (Local)
DB_TYPE=postgres
DB_SERVER=localhost
DB_PORT=5432
DB_NAME=FactoryUtility
DB_USER=postgres
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
    echo "   Make sure it has PostgreSQL settings:"
    echo "   DB_TYPE=postgres"
    echo "   DB_SERVER=localhost"
    echo "   DB_PORT=5432"
    echo "   DB_USER=postgres"
    echo "   DB_PASSWORD=FactoryUtility@123"
fi

echo ""

# Start PostgreSQL
echo "📦 Starting PostgreSQL container..."
cd database
/opt/homebrew/bin/docker-compose -f docker-compose-postgres.yml up -d

echo ""
echo "⏳ Waiting for PostgreSQL to be ready (10-20 seconds)..."
echo ""

# Wait for PostgreSQL to be ready
max_attempts=15
attempt=0
while [ $attempt -lt $max_attempts ]; do
    if docker logs factory-utility-postgres 2>&1 | grep -q "database system is ready to accept connections"; then
        echo ""
        echo "✅ PostgreSQL is ready!"
        break
    fi
    
    attempt=$((attempt + 1))
    echo -n "."
    sleep 2
done

if [ $attempt -eq $max_attempts ]; then
    echo ""
    echo "⚠️  PostgreSQL is starting but taking longer than expected"
    echo "   You can check logs with: docker logs factory-utility-postgres"
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
npm run db:setup:postgres

echo ""
echo "=========================================================="
echo "✅ PostgreSQL Local Database Setup Complete!"
echo "=========================================================="
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
echo "  Start: npm run db:start:postgres"
echo "  Stop: npm run db:stop:postgres"
echo "  Logs: npm run db:logs:postgres"
echo ""

