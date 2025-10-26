#!/bin/bash

# ==================================================================
# Deploy Login Page to Spaceship Hosting
# ==================================================================
# This script deploys the /empresas login page to production
# Usage: ./deploy-login-page.sh

set -e  # Exit on error

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Deploying Login Page to Spaceship Hosting${NC}"
echo ""

# ==================================================================
# Configuration
# ==================================================================
FTP_HOST="ftp.imagemia.com"
FTP_USER="imagemiadeploy@imagemia.com"
FTP_PASS="zydGeb-jajrec-3fipgu"
REMOTE_DIR="/home/fwrikwglvd/imagemia.com/empresas"

# Local paths
PROJECT_ROOT="../../../"
LOGIN_PAGE_DIR="${PROJECT_ROOT}web/empresas"

# ==================================================================
# Pre-flight checks
# ==================================================================
echo -e "${YELLOW}📋 Pre-flight checks...${NC}"

# Check if lftp is installed
if ! command -v lftp &> /dev/null; then
    echo -e "${RED}❌ lftp is not installed${NC}"
    echo "Install with: brew install lftp"
    exit 1
fi

# Check if login page directory exists
if [ ! -d "$LOGIN_PAGE_DIR" ]; then
    echo -e "${RED}❌ Login page directory not found: ${LOGIN_PAGE_DIR}${NC}"
    echo "Have you copied the template yet?"
    echo "Run: cp -r assets/login-template/ ../../web/empresas/"
    exit 1
fi

# Check if index.html exists
if [ ! -f "${LOGIN_PAGE_DIR}/index.html" ]; then
    echo -e "${RED}❌ index.html not found in ${LOGIN_PAGE_DIR}${NC}"
    exit 1
fi

# Check if Supabase credentials are configured
if grep -q "YOUR_SUPABASE_URL" "${LOGIN_PAGE_DIR}/index.html"; then
    echo -e "${YELLOW}⚠️  WARNING: Supabase URL not configured in index.html${NC}"
    echo "Please update the SUPABASE_URL and SUPABASE_ANON_KEY in index.html"
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

echo -e "${GREEN}✅ Pre-flight checks passed${NC}"
echo ""

# ==================================================================
# Upload files via FTP
# ==================================================================
echo -e "${BLUE}📤 Uploading files to ${FTP_HOST}...${NC}"

lftp -c "
set ftp:ssl-allow no
set net:timeout 30
set net:max-retries 3
open ftp://${FTP_USER}:${FTP_PASS}@${FTP_HOST}

echo '📍 Current directory:'
pwd

echo ''
echo '📂 Creating /empresas directory if needed...'
mkdir -p ${REMOTE_DIR}

echo ''
echo '📤 Uploading files...'
cd ${REMOTE_DIR}
lcd ${LOGIN_PAGE_DIR}

# Upload all files
mirror --reverse --delete --verbose --parallel=2 ./ ./

echo ''
echo '✅ Files uploaded successfully'
echo ''
echo '📂 Remote directory contents:'
ls -la

bye
"

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✅ Login page deployed successfully!${NC}"
    echo ""
    echo -e "${BLUE}🌐 Your login page is now live at:${NC}"
    echo -e "${GREEN}   https://imagemia.com/empresas${NC}"
    echo ""
    echo -e "${YELLOW}📝 Next steps:${NC}"
    echo "   1. Test the login page in your browser"
    echo "   2. Try logging in with a test user"
    echo "   3. Verify redirection to dashboard works"
    echo "   4. Test on mobile devices"
    echo ""
else
    echo ""
    echo -e "${RED}❌ Deployment failed${NC}"
    echo "Check the error messages above and try again"
    exit 1
fi
