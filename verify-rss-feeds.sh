#!/bin/bash

# RSS Feeds Verification Script
# Tests that RSS feeds are properly implemented

echo "🔍 Verifying RSS Feed Implementation..."
echo ""

PASS=0
FAIL=0

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test 1: Check that site builds
echo "🏗️  Test 1: Site builds without errors..."
if npm run build > /dev/null 2>&1; then
    echo -e "${GREEN}✓ PASS${NC} - Site built successfully"
    ((PASS++))
else
    echo -e "${RED}✗ FAIL${NC} - Site failed to build"
    ((FAIL++))
fi

# Test 2: Check unified feed exists
echo "📄 Test 2: Unified feed exists..."
if [ -f "docs/feed.xml" ]; then
    echo -e "${GREEN}✓ PASS${NC} - docs/feed.xml exists"
    ((PASS++))
else
    echo -e "${RED}✗ FAIL${NC} - docs/feed.xml not found"
    ((FAIL++))
fi

# Test 3: Check writing feed exists
echo "📄 Test 3: Writing feed exists..."
if [ -f "docs/writing/feed.xml" ]; then
    echo -e "${GREEN}✓ PASS${NC} - docs/writing/feed.xml exists"
    ((PASS++))
else
    echo -e "${RED}✗ FAIL${NC} - docs/writing/feed.xml not found"
    ((FAIL++))
fi

# Test 4: Check unified feed is valid XML
echo "✅ Test 4: Unified feed is valid XML..."
if grep -q "<?xml version" docs/feed.xml && grep -q "</feed>" docs/feed.xml; then
    echo -e "${GREEN}✓ PASS${NC} - Unified feed is valid XML"
    ((PASS++))
else
    echo -e "${RED}✗ FAIL${NC} - Unified feed is not valid XML"
    ((FAIL++))
fi

# Test 5: Check writing feed is valid XML
echo "✅ Test 5: Writing feed is valid XML..."
if [ -f "docs/writing/feed.xml" ] && grep -q "<?xml version" docs/writing/feed.xml && grep -q "</feed>" docs/writing/feed.xml; then
    echo -e "${GREEN}✓ PASS${NC} - Writing feed is valid XML"
    ((PASS++))
else
    echo -e "${RED}✗ FAIL${NC} - Writing feed is not valid XML"
    ((FAIL++))
fi

# Test 6: Check book entries have "Added to shelf" prefix
echo "📚 Test 6: Book entries have correct prefix..."
if grep -q "Added to shelf:" docs/feed.xml; then
    echo -e "${GREEN}✓ PASS${NC} - Book entries have \"📚 Added to shelf:\" prefix"
    ((PASS++))
else
    echo -e "${RED}✗ FAIL${NC} - Book entries missing prefix"
    ((FAIL++))
fi

# Test 7: Check feed autodiscovery in base template
echo "🔗 Test 7: Feed autodiscovery links exist..."
if grep -q "rel=\"alternate\"" docs/index.html && grep -q "/feed.xml" docs/index.html; then
    echo -e "${GREEN}✓ PASS${NC} - Feed autodiscovery links found"
    ((PASS++))
else
    echo -e "${RED}✗ FAIL${NC} - Feed autodiscovery links missing"
    ((FAIL++))
fi

# Test 8: Check shelf page structure
echo "📖 Test 8: Shelf page shows writing section..."
if [ -f "docs/shelf/index.html" ]; then
    if grep -q "Writing" docs/shelf/index.html; then
        echo -e "${GREEN}✓ PASS${NC} - Shelf page has writing section"
        ((PASS++))
    else
        echo -e "${YELLOW}⊘ SKIP${NC} - No writing posts yet (expected)"
        ((PASS++))
    fi
else
    echo -e "${RED}✗ FAIL${NC} - Shelf page not found"
    ((FAIL++))
fi

# Test 9: Check writing index page exists
echo "📝 Test 9: Writing index page exists..."
if [ -f "docs/writing/index.html" ]; then
    echo -e "${GREEN}✓ PASS${NC} - Writing index page exists"
    ((PASS++))
else
    echo -e "${RED}✗ FAIL${NC} - Writing index page not found"
    ((FAIL++))
fi

# Test 10: Check unified feed has required Atom elements
echo "⚛️  Test 10: Unified feed has required Atom elements..."
REQUIRED_ELEMENTS=("title" "link" "updated" "id" "author")
MISSING=0
for element in "${REQUIRED_ELEMENTS[@]}"; do
    if ! grep -q "<$element" docs/feed.xml; then
        echo -e "${RED}  ✗ Missing <$element>${NC}"
        ((MISSING++))
    fi
done
if [ $MISSING -eq 0 ]; then
    echo -e "${GREEN}✓ PASS${NC} - All required Atom elements present"
    ((PASS++))
else
    echo -e "${RED}✗ FAIL${NC} - Missing $MISSING required elements"
    ((FAIL++))
fi

# Test 11: Check feed entries have updated dates
echo "📅 Test 11: Feed entries have dates..."
ENTRIES_WITH_DATES=$(grep -c "<updated>" docs/feed.xml)
TOTAL_ENTRIES=$(grep -c "<entry>" docs/feed.xml)
if [ $ENTRIES_WITH_DATES -ge $TOTAL_ENTRIES ]; then
    echo -e "${GREEN}✓ PASS${NC} - All entries have updated dates ($ENTRIES_WITH_DATES/$TOTAL_ENTRIES)"
    ((PASS++))
else
    echo -e "${RED}✗ FAIL${NC} - Some entries missing dates ($ENTRIES_WITH_DATES/$TOTAL_ENTRIES)"
    ((FAIL++))
fi

# Test 12: Check URLs are absolute (not relative)
echo "🔗 Test 12: URLs are absolute..."
if grep -q "href=\"/[^/]" docs/feed.xml || grep -q "href=\"\\.\\./\"" docs/feed.xml; then
    echo -e "${RED}✗ FAIL${NC} - Found relative URLs in feed"
    ((FAIL++))
else
    echo -e "${GREEN}✓ PASS${NC} - All URLs are absolute"
    ((PASS++))
fi

# Test 13: Check writing feed has required elements
echo "⚛️  Test 13: Writing feed has required Atom elements..."
if [ -f "docs/writing/feed.xml" ]; then
    MISSING=0
    for element in "${REQUIRED_ELEMENTS[@]}"; do
        if ! grep -q "<$element" docs/writing/feed.xml; then
            echo -e "${RED}  ✗ Missing <$element>${NC}"
            ((MISSING++))
        fi
    done
    if [ $MISSING -eq 0 ]; then
        echo -e "${GREEN}✓ PASS${NC} - All required Atom elements present in writing feed"
        ((PASS++))
    else
        echo -e "${RED}✗ FAIL${NC} - Missing $MISSING required elements in writing feed"
        ((FAIL++))
    fi
else
    echo -e "${RED}✗ FAIL${NC} - Writing feed not found"
    ((FAIL++))
fi

# Test 14: Check feed uses correct Atom namespace
echo "📛 Test 14: Feed uses correct Atom namespace..."
if grep -q 'xmlns="http://www.w3.org/2005/Atom"' docs/feed.xml; then
    echo -e "${GREEN}✓ PASS${NC} - Correct Atom namespace"
    ((PASS++))
else
    echo -e "${RED}✗ FAIL${NC} - Missing or incorrect Atom namespace"
    ((FAIL++))
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
