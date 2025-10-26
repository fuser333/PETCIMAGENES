#!/bin/bash

# ==================================================================
# Create Supabase Environment Configuration
# ==================================================================
# This script helps create .env files with Supabase credentials
# Usage: ./create-supabase-env.sh

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}🔧 Supabase Environment Configuration${NC}"
echo ""

# ==================================================================
# Collect Supabase credentials
# ==================================================================
echo -e "${YELLOW}Please enter your Supabase credentials:${NC}"
echo "(You can find these in Supabase Dashboard → Settings → API)"
echo ""

read -p "Supabase URL (https://xxxxx.supabase.co): " SUPABASE_URL
read -p "Supabase Anon Key: " SUPABASE_ANON_KEY
read -p "Supabase Service Role Key (optional, for backend): " SUPABASE_SERVICE_KEY

echo ""

# ==================================================================
# Validate inputs
# ==================================================================
if [ -z "$SUPABASE_URL" ] || [ -z "$SUPABASE_ANON_KEY" ]; then
    echo -e "${RED}❌ URL and Anon Key are required${NC}"
    exit 1
fi

# ==================================================================
# Create backend .env file
# ==================================================================
BACKEND_ENV="../../../backend/.env"

echo -e "${BLUE}📝 Creating backend .env file...${NC}"

cat > "$BACKEND_ENV" << EOF
# Supabase Configuration
# Generated: $(date)

SUPABASE_URL=${SUPABASE_URL}
SUPABASE_ANON_KEY=${SUPABASE_ANON_KEY}
EOF

if [ -n "$SUPABASE_SERVICE_KEY" ]; then
    echo "SUPABASE_SERVICE_ROLE_KEY=${SUPABASE_SERVICE_KEY}" >> "$BACKEND_ENV"
fi

echo -e "${GREEN}✅ Created: ${BACKEND_ENV}${NC}"

# ==================================================================
# Update login page HTML with credentials
# ==================================================================
LOGIN_PAGE="../../../web/empresas/index.html"

if [ -f "$LOGIN_PAGE" ]; then
    echo ""
    echo -e "${BLUE}📝 Updating login page with Supabase credentials...${NC}"

    # Create backup
    cp "$LOGIN_PAGE" "${LOGIN_PAGE}.backup"

    # Replace placeholders
    sed -i '' "s|const SUPABASE_URL = 'YOUR_SUPABASE_URL'|const SUPABASE_URL = '${SUPABASE_URL}'|g" "$LOGIN_PAGE"
    sed -i '' "s|const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY'|const SUPABASE_ANON_KEY = '${SUPABASE_ANON_KEY}'|g" "$LOGIN_PAGE"

    echo -e "${GREEN}✅ Updated: ${LOGIN_PAGE}${NC}"
    echo -e "${YELLOW}   Backup saved: ${LOGIN_PAGE}.backup${NC}"
else
    echo ""
    echo -e "${YELLOW}⚠️  Login page not found at ${LOGIN_PAGE}${NC}"
    echo "You'll need to manually update the credentials in your login page"
fi

# ==================================================================
# Create .env.example for reference
# ==================================================================
EXAMPLE_FILE="../../../.env.example"

cat > "$EXAMPLE_FILE" << 'EOF'
# Supabase Configuration
# Copy this file to .env and fill in your actual values

SUPABASE_URL=https://xxxxxxxxxxxxx.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
EOF

echo ""
echo -e "${GREEN}✅ Configuration complete!${NC}"
echo ""
echo -e "${BLUE}📄 Files created:${NC}"
echo "   - ${BACKEND_ENV}"
echo "   - ${EXAMPLE_FILE}"
if [ -f "$LOGIN_PAGE" ]; then
    echo "   - ${LOGIN_PAGE} (updated)"
fi
echo ""
echo -e "${YELLOW}🔒 Security reminders:${NC}"
echo "   - NEVER commit .env files to git"
echo "   - NEVER expose Service Role Key in frontend"
echo "   - Use different credentials for dev/staging/production"
echo ""
echo -e "${BLUE}🚀 Next steps:${NC}"
echo "   1. Verify credentials in ${BACKEND_ENV}"
echo "   2. Test login page locally"
echo "   3. Deploy login page: ./deploy-login-page.sh"
echo ""
