#!/bin/bash

echo "🚀 Starting Local SQL Server Database..."
echo ""

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
        echo ""
        echo "Please start Docker Desktop or use Colima:"
        echo "  1. Install Colima: brew install colima"
        echo "  2. Start Colima: colima start"
        exit 1
    fi
    echo "✅ Docker is installed and running"
else
    echo "❌ Neither Colima nor Docker is available!"
    echo ""
    echo "📥 Please install Colima (recommended):"
    echo "   brew install colima"
    echo "   colima start --runtime docker"
    exit 1
fi

# Verify Docker CLI is accessible
if ! docker ps &> /dev/null; then
    echo "❌ Docker CLI is not accessible!"
    echo ""
    if [ "$HAS_COLIMA" = true ]; then
        echo "Try restarting Colima: colima restart"
    fi
    exit 1
fi
echo ""

# Navigate to database directory
cd "$(dirname "$0")"

# Check if container already exists and is running
if docker ps -a --format '{{.Names}}' | grep -q "^factory-utility-db$"; then
    if docker ps --format '{{.Names}}' | grep -q "^factory-utility-db$"; then
        echo "✅ SQL Server container is already running"
        echo ""
        echo "Container status:"
        docker ps --filter "name=factory-utility-db" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
        echo ""
        echo "To view logs: npm run db:logs"
        echo "To stop: npm run db:stop"
        exit 0
    else
        echo "📦 Starting existing SQL Server container..."
        docker start factory-utility-db
    fi
else
    echo "📦 Creating and starting SQL Server container..."
    docker-compose up -d
fi

echo ""
echo "⏳ Waiting for SQL Server to be ready..."
echo "   This may take 30-60 seconds on first run..."
echo ""

# Wait for SQL Server to be ready
max_attempts=30
attempt=0
while [ $attempt -lt $max_attempts ]; do
    if docker logs factory-utility-db 2>&1 | grep -q "SQL Server is now ready for client connections"; then
        echo ""
        echo "✅ SQL Server is ready!"
        echo ""
        echo "📝 Database Configuration:"
        echo "   Server: localhost:1433"
        echo "   User: sa"
        echo "   Password: FactoryUtility@123"
        echo ""
        echo "Next steps:"
        echo "  1. Update .env file with local database settings"
        echo "  2. Run: npm run db:setup:local"
        exit 0
    fi
    
    attempt=$((attempt + 1))
    echo -n "."
    sleep 2
done

echo ""
echo "⚠️  SQL Server is starting but taking longer than expected"
echo ""
echo "To check status:"
echo "  docker logs factory-utility-db"
echo ""
echo "Once you see 'SQL Server is now ready', you can continue."
exit 0

