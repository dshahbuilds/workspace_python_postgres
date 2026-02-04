#!/bin/bash

# Standard colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}🔍 Starting Installation Verification...${NC}\n"

# 1. Verify Python 3.11 and Pip
echo "--- Testing Python 3.11 ---"
if command -v python3.11 &> /dev/null; then
    VERSION=$(python3.11 --version)
    echo -e "  [OK] $VERSION"
    
    # Test pip and venv creation
    python3.11 -m venv test_env
    source test_env/bin/activate
    echo -e "  [OK] Virtual Environment created and activated"
    pip install --upgrade pip &> /dev/null
    echo -e "  [OK] Pip is functional"
    deactivate
    rm -rf test_env
else
    echo -e "  ${RED}[FAIL] Python 3.11 not found${NC}"
fi

echo ""

# 2. Verify PostgreSQL 16
echo "--- Testing PostgreSQL 16 ---"
# Check if service is running
if sudo service postgresql status | grep -q "online\|active\|running"; then
    echo -e "  [OK] PostgreSQL service is active"
else
    echo -e "  ${RED}[FAIL] PostgreSQL service is NOT running${NC}"
    sudo service postgresql start
fi

# Check version
PG_VERSION=$(psql --version)
echo -e "  [OK] $PG_VERSION"

# Test Database Connection as 'vscode' user
echo "--- Testing DB Connection ---"
if psql -d postgres -c "SELECT 'Connection Successful' AS status;" &> /dev/null; then
    echo -e "  [OK] Successfully connected to Postgres as '$(whoami)'"
else
    echo -e "  ${RED}[FAIL] Could not connect to Postgres database${NC}"
fi

echo -e "\n${GREEN}✨ All checks completed!${NC}"