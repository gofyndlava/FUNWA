#!/bin/bash

echo "🚀 Setting up Colima for Factory Utility Database"
echo "=================================================="
echo ""

# Check if Colima is installed
if ! command -v colima &> /dev/null; then
    echo "❌ Colima is not installed!"
    echo ""
    echo "📥 Install Colima using Homebrew:"
    echo "   brew install colima"
    echo ""
    echo "Or download from: https://github.com/abiosoft/colima/releases"
    exit 1
fi

echo "✅ Colima is installed"
echo ""

# Check if Colima is running
if ! colima status &> /dev/null; then
    echo "📦 Starting Colima (this may take a few minutes on first run)..."
    echo ""
    
    # Start Colima with Docker runtime
    colima start --runtime docker
    
    echo ""
    echo "✅ Colima started successfully"
else
    STATUS=$(colima status 2>/dev/null | grep -i "status" | awk '{print $2}')
    if [ "$STATUS" = "Running" ]; then
        echo "✅ Colima is already running"
    else
        echo "📦 Starting Colima..."
        colima start --runtime docker
        echo "✅ Colima started successfully"
    fi
fi

echo ""
echo "🔍 Verifying Docker is available through Colima..."
if docker ps &> /dev/null; then
    echo "✅ Docker is working through Colima"
    echo ""
    echo "Colima is ready! You can now:"
    echo "  1. Run: npm run db:start"
    echo "  2. Or run: ./setup-local-db.sh"
else
    echo "❌ Docker is not available through Colima"
    echo "   Try restarting Colima: colima restart"
    exit 1
fi

echo ""

