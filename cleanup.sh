#!/bin/bash

# Complete cleanup script - kills all processes and clears caches

echo "🧹 Cleaning up all processes and caches..."

# Kill all node processes
pkill -9 -f "node.*server/index.js" 2>/dev/null
pkill -9 -f "nodemon" 2>/dev/null
pkill -9 -f "react-scripts" 2>/dev/null
pkill -9 -f "concurrently" 2>/dev/null

# Kill processes on ports
lsof -ti:5000 | xargs kill -9 2>/dev/null
lsof -ti:3000 | xargs kill -9 2>/dev/null

# Wait a moment
sleep 2

# Verify ports are free
if lsof -Pi :5000 -sTCP:LISTEN -t >/dev/null 2>&1 ; then
    echo "⚠️  Port 5000 still in use. Force killing..."
    lsof -ti:5000 | xargs kill -9 2>/dev/null
    sleep 1
fi

if lsof -Pi :3000 -sTCP:LISTEN -t >/dev/null 2>&1 ; then
    echo "⚠️  Port 3000 still in use. Force killing..."
    lsof -ti:3000 | xargs kill -9 2>/dev/null
    sleep 1
fi

echo "✅ Cleanup complete! Ports should be free now."
echo ""
echo "You can now run: ./start.sh"

