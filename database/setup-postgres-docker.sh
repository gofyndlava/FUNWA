#!/bin/bash

echo "🔧 Setting up PostgreSQL database using Docker exec..."
echo ""

# Check if container is running
if ! docker ps | grep -q factory-utility-postgres; then
    echo "❌ PostgreSQL container is not running!"
    echo "   Start it with: npm run db:start:postgres"
    exit 1
fi

echo "✅ PostgreSQL container is running"
echo ""

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Check if database already has tables
TABLE_COUNT=$(docker exec factory-utility-postgres psql -U postgres -d FactoryUtility -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';" 2>/dev/null | tr -d ' ')

if [ "$TABLE_COUNT" -gt "0" ]; then
    echo "✅ Database already has $TABLE_COUNT tables"
    echo "   Skipping schema creation"
else
    echo "📋 Creating database tables..."
    docker exec -i factory-utility-postgres psql -U postgres -d FactoryUtility < "$SCRIPT_DIR/schema-postgres.sql"
    echo "✅ Tables created"
fi

# Check if users already exist
USER_COUNT=$(docker exec factory-utility-postgres psql -U postgres -d FactoryUtility -t -c "SELECT COUNT(*) FROM \"LoginDetails\";" 2>/dev/null | tr -d ' ')

if [ "$USER_COUNT" -gt "0" ]; then
    echo "✅ Database already has $USER_COUNT users"
    echo "   Skipping user creation"
else
    echo "👤 Creating default users..."
    docker exec -i factory-utility-postgres psql -U postgres -d FactoryUtility < "$SCRIPT_DIR/default_user-postgres.sql"
    echo "✅ Users created"
fi

echo ""
echo "=========================================="
echo "✅ Database setup completed!"
echo "=========================================="
echo ""
echo "Default Admin Credentials:"
echo "  Username: admin"
echo "  Password: Admin@123"
echo ""

