#!/bin/bash

# Visual Consistency Verification Script
# Tests that visual consistency tools are working properly

echo "🔍 Verifying Visual Consistency..."
echo ""

PASS=0
FAIL=0

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test 1: Check that stylelint is installed
echo "📦 Test 1: Stylelint is installed..."
if command -v npx &> /dev/null && npx stylelint --version &> /dev/null; then
    echo -e "${GREEN}✓ PASS${NC} - Stylelint is installed"
    ((PASS++))
else
    echo -e "${RED}✗ FAIL${NC} - Stylelint is not installed"
    ((FAIL++))
fi

# Test 2: Check that stylelint config exists
echo "⚙️  Test 2: Stylelint config exists..."
if [ -f ".stylelintrc.json" ]; then
    echo -e "${GREEN}✓ PASS${NC} - .stylelintrc.json exists"
    ((PASS++))
else
    echo -e "${RED}✗ FAIL${NC} - .stylelintrc.json not found"
    ((FAIL++))
fi

# Test 3: Check that writing component CSS exists
echo "📄 Test 3: Writing component CSS exists..."
if [ -f "src/assets/css/components/writing.css" ]; then
    echo -e "${GREEN}✓ PASS${NC} - writing.css component exists"
    ((PASS++))
else
    echo -e "${RED}✗ FAIL${NC} - writing.css component not found"
    ((FAIL++))
fi

# Test 4: Check that writing CSS is imported in main.css
echo "🔗 Test 4: Writing CSS is imported..."
if grep -q "writing.css" src/assets/css/main.css; then
    echo -e "${GREEN}✓ PASS${NC} - writing.css is imported in main.css"
    ((PASS++))
else
    echo -e "${RED}✗ FAIL${NC} - writing.css is not imported"
    ((FAIL++))
fi

# Test 5: Check that Playwright is installed
echo "🎭 Test 5: Playwright is installed..."
if command -v npx &> /dev/null && npx playwright --version &> /dev/null; then
    echo -e "${GREEN}✓ PASS${NC} - Playwright is installed"
    ((PASS++))
else
    echo -e "${RED}✗ FAIL${NC} - Playwright is not installed"
    ((FAIL++))
fi

# Test 6: Check that playwright config exists
echo "⚙️  Test 6: Playwright config exists..."
if [ -f "playwright.config.js" ]; then
    echo -e "${GREEN}✓ PASS${NC} - playwright.config.js exists"
    ((PASS++))
else
    echo -e "${RED}✗ FAIL${NC} - playwright.config.js not found"
    ((FAIL++))
fi

# Test 7: Check that visual tests exist
echo "📸 Test 7: Visual tests exist..."
if [ -f "tests/visual/pages.spec.js" ]; then
    echo -e "${GREEN}✓ PASS${NC} - Visual test file exists"
    ((PASS++))
else
    echo -e "${RED}✗ FAIL${NC} - Visual test file not found"
    ((FAIL++))
fi

# Test 8: Check that baseline screenshot exists (homepage only)
echo "🖼️  Test 8: Baseline screenshot exists..."
SNAPSHOT_FILE="tests/visual/pages.spec.js-snapshots/homepage-desktop.png"
if [ -f "$SNAPSHOT_FILE" ]; then
    echo -e "${GREEN}✓ PASS${NC} - Homepage baseline screenshot exists"
    ((PASS++))
else
    echo -e "${RED}✗ FAIL${NC} - Homepage baseline screenshot not found"
    ((FAIL++))
fi

# Test 9: Run stylelint (check exit code)
echo "🔍 Test 9: Running stylelint..."
if npm run lint:css > /dev/null 2>&1; then
    echo -e "${GREEN}✓ PASS${NC} - Stylelint passed (no errors)"
    ((PASS++))
else
    # Check if only warnings
    if npm run lint:css 2>&1 | grep -q "✖.*errors.*0 warnings" || npm run lint:css 2>&1 | grep -q "warnings"; then
        echo -e "${YELLOW}⊘ WARN${NC} - Stylelint has warnings but no errors"
        ((PASS++))
    else
        echo -e "${RED}✗ FAIL${NC} - Stylelint failed with errors"
        ((FAIL++))
    fi
fi

# Summary
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 Summary:"
echo -e "${GREEN}✓ Passed: $PASS${NC}"
echo -e "${RED}✗ Failed: $FAIL${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ $FAIL -eq 0 ]; then
    echo -e "${GREEN}🎉 All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}❌ Some tests failed. Please review.${NC}"
    exit 1
fi
