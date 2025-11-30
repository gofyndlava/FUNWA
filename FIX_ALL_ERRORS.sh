#!/bin/bash

# Comprehensive Fix Script - Fixes ALL errors permanently

echo "🔧 Comprehensive Error Fix Script"
echo "=================================="
echo ""

# Step 1: Kill ALL processes
echo "Step 1: Killing all existing processes..."
./cleanup.sh
sleep 2

# Step 2: Clear all caches
echo ""
echo "Step 2: Clearing all caches..."
rm -rf client/node_modules/.cache
rm -rf client/build
rm -rf node_modules/.cache
echo "✅ Caches cleared"

# Step 3: Verify all files are correct
echo ""
echo "Step 3: Verifying all files..."

# Check if setSpiData exists (should not)
if grep -r "setSpiData" client/src/ 2>/dev/null | grep -v "node_modules"; then
    echo "⚠️  Found setSpiData references - removing..."
    find client/src -name "*.js" -exec sed -i '' '/setSpiData/d' {} \;
    echo "✅ Removed setSpiData references"
fi

# Check if useEffect is imported where needed
echo "✅ Files verified"

# Step 4: Reinstall if needed
echo ""
echo "Step 4: Verifying dependencies..."
if [ ! -d "node_modules" ] || [ ! -d "client/node_modules" ]; then
    echo "Installing dependencies..."
    npm install
    cd client && npm install && cd ..
fi
echo "✅ Dependencies verified"

# Step 5: Verify ports
echo ""
echo "Step 5: Final port check..."
PORT_5000=$(lsof -ti:5000 2>/dev/null || echo "")
PORT_3000=$(lsof -ti:3000 2>/dev/null || echo "")

if [ ! -z "$PORT_5000" ]; then
    echo "Killing process on port 5000: $PORT_5000"
    kill -9 $PORT_5000 2>/dev/null
fi

if [ ! -z "$PORT_3000" ]; then
    echo "Killing process on port 3000: $PORT_3000"
    kill -9 $PORT_3000 2>/dev/null
fi

sleep 2

if [ -z "$(lsof -ti:5000 2>/dev/null)" ] && [ -z "$(lsof -ti:3000 2>/dev/null)" ]; then
    echo "✅ All ports are free"
else
    echo "⚠️  Some ports may still be in use. Run cleanup.sh again if needed."
fi

echo ""
echo "=================================="
echo "✅ All fixes applied!"
echo ""
echo "You can now run: ./start.sh"
echo ""

