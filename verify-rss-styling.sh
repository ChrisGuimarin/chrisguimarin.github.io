#!/bin/bash

# RSS Styling Verification Script
# Tests that RSS feed styling is properly implemented

echo "🎨 Verifying RSS Styling Implementation..."
echo ""

PASS=0
FAIL=0

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test 1: Check XSLT file exists
echo "📄 Test 1: XSLT stylesheet exists..."
if [ -f "src/assets/feed.xsl" ]; then
    echo -e "${GREEN}✓ PASS${NC} - src/assets/feed.xsl exists"
    ((PASS++))
else
    echo -e "${RED}✗ FAIL${NC} - src/assets/feed.xsl not found"
    ((FAIL++))
fi

# Test 2: Check XSLT is copied to docs
echo "📄 Test 2: XSLT copied to build output..."
if [ -f "docs/assets/feed.xsl" ]; then
    echo -e "${GREEN}✓ PASS${NC} - docs/assets/feed.xsl exists"
    ((PASS++))
else
    echo -e "${RED}✗ FAIL${NC} - docs/assets/feed.xsl not found (run npm run build)"
    ((FAIL++))
fi

# Test 3: Check main feed references XSLT
echo "🔗 Test 3: Main feed references XSLT stylesheet..."
if grep -q 'xml-stylesheet.*feed.xsl' docs/feed.xml 2>/dev/null; then
    echo -e "${GREEN}✓ PASS${NC} - Main feed has XSLT reference"
    ((PASS++))
else
    echo -e "${RED}✗ FAIL${NC} - Main feed missing XSLT reference"
    ((FAIL++))
fi

# Test 4: Check writing feed references XSLT
echo "🔗 Test 4: Writing feed references XSLT stylesheet..."
if grep -q 'xml-stylesheet.*feed.xsl' docs/writing/feed.xml 2>/dev/null; then
    echo -e "${GREEN}✓ PASS${NC} - Writing feed has XSLT reference"
    ((PASS++))
else
    echo -e "${RED}✗ FAIL${NC} - Writing feed missing XSLT reference"
    ((FAIL++))
fi

# Test 5: Check RSS icon component exists
echo "🔧 Test 5: RSS icon component exists..."
if [ -f "src/_includes/rss-icon.njk" ]; then
    echo -e "${GREEN}✓ PASS${NC} - rss-icon.njk component exists"
    ((PASS++))
else
    echo -e "${RED}✗ FAIL${NC} - rss-icon.njk component not found"
    ((FAIL++))
fi

# Test 6: Check page header component exists
echo "🔧 Test 6: Page header component exists..."
if [ -f "src/_includes/page-header.njk" ]; then
    echo -e "${GREEN}✓ PASS${NC} - page-header.njk component exists"
    ((PASS++))
else
    echo -e "${RED}✗ FAIL${NC} - page-header.njk component not found"
    ((FAIL++))
fi

# Test 7: Check RSS CSS exists
echo "🎨 Test 7: RSS CSS component exists..."
if [ -f "src/assets/css/components/rss.css" ]; then
    echo -e "${GREEN}✓ PASS${NC} - rss.css exists"
    ((PASS++))
else
    echo -e "${RED}✗ FAIL${NC} - rss.css not found"
    ((FAIL++))
fi

# Test 8: Check RSS CSS is imported in main.css
echo "🔗 Test 8: RSS CSS is imported in main.css..."
if grep -q 'rss.css' src/assets/css/main.css; then
    echo -e "${GREEN}✓ PASS${NC} - rss.css is imported"
    ((PASS++))
else
    echo -e "${RED}✗ FAIL${NC} - rss.css not imported in main.css"
    ((FAIL++))
fi

# Test 9: Check shelf page has RSS icon
echo "📖 Test 9: Shelf page has RSS icon..."
if grep -q 'rss-link' docs/shelf/index.html 2>/dev/null && grep -q '/feed.xml' docs/shelf/index.html 2>/dev/null; then
    echo -e "${GREEN}✓ PASS${NC} - Shelf page has RSS icon linking to /feed.xml"
    ((PASS++))
else
    echo -e "${RED}✗ FAIL${NC} - Shelf page missing RSS icon"
    ((FAIL++))
fi

# Test 10: Check writing page has RSS icon
echo "📝 Test 10: Writing page has RSS icon..."
if grep -q 'rss-link' docs/writing/index.html 2>/dev/null && grep -q '/writing/feed.xml' docs/writing/index.html 2>/dev/null; then
    echo -e "${GREEN}✓ PASS${NC} - Writing page has RSS icon linking to /writing/feed.xml"
    ((PASS++))
else
    echo -e "${RED}✗ FAIL${NC} - Writing page missing RSS icon"
    ((FAIL++))
fi

# Test 11: Check XSLT has educational banner
echo "📚 Test 11: XSLT has educational banner with aboutfeeds.com link..."
if grep -q 'aboutfeeds.com' src/assets/feed.xsl; then
    echo -e "${GREEN}✓ PASS${NC} - XSLT has aboutfeeds.com link"
    ((PASS++))
else
    echo -e "${RED}✗ FAIL${NC} - XSLT missing aboutfeeds.com link"
    ((FAIL++))
fi

# Test 12: Check XSLT has dark mode support
echo "🌙 Test 12: XSLT has dark mode support..."
if grep -q 'prefers-color-scheme: dark' src/assets/feed.xsl; then
    echo -e "${GREEN}✓ PASS${NC} - XSLT has dark mode CSS"
    ((PASS++))
else
    echo -e "${RED}✗ FAIL${NC} - XSLT missing dark mode support"
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
    echo -e "${GREEN}🎉 All RSS styling tests passed!${NC}"
    exit 0
else
    echo -e "${RED}❌ Some tests failed. Please review.${NC}"
    exit 1
fi
