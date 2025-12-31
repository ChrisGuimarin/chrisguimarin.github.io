#!/bin/bash

# Image Optimization Verification Script
# Tests that all image optimizations are properly implemented

echo "🔍 Verifying Image Optimizations..."
echo ""

PASS=0
FAIL=0

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test 1: Check lazy loading on book covers
echo "📚 Test 1: Book covers have lazy loading..."
if grep -q 'loading="lazy"' docs/shelf/index.html; then
    echo -e "${GREEN}✓ PASS${NC} - Lazy loading found on shelf page"
    ((PASS++))
else
    echo -e "${RED}✗ FAIL${NC} - No lazy loading found on shelf page"
    ((FAIL++))
fi

# Test 2: Check async decoding
echo "📚 Test 2: Images have async decoding..."
if grep -q 'decoding="async"' docs/shelf/index.html; then
    echo -e "${GREEN}✓ PASS${NC} - Async decoding found"
    ((PASS++))
else
    echo -e "${RED}✗ FAIL${NC} - No async decoding found"
    ((FAIL++))
fi

# Test 3: Check profile photo uses optimized JPG instead of PNG
echo "👤 Test 3: Profile photo uses optimized JPG..."
if grep -q 'chris-guimarin-600.jpg' docs/about/index.html; then
    echo -e "${GREEN}✓ PASS${NC} - Profile photo uses optimized JPG"
    ((PASS++))
else
    echo -e "${RED}✗ FAIL${NC} - Profile photo still uses PNG"
    ((FAIL++))
fi

# Test 4: Check responsive images with srcset
echo "👤 Test 4: Profile photo has responsive srcset..."
if grep -q 'srcset=' docs/about/index.html; then
    echo -e "${GREEN}✓ PASS${NC} - Responsive images configured"
    ((PASS++))
else
    echo -e "${RED}✗ FAIL${NC} - No srcset found"
    ((FAIL++))
fi

# Test 5: Check eager loading on above-fold images
echo "👤 Test 5: Profile photo has eager loading..."
if grep -q 'loading="eager"' docs/about/index.html; then
    echo -e "${GREEN}✓ PASS${NC} - Eager loading on above-fold image"
    ((PASS++))
else
    echo -e "${RED}✗ FAIL${NC} - No eager loading found"
    ((FAIL++))
fi

# Test 6: Check theater image has lazy loading
echo "🎭 Test 6: Theater image has lazy loading..."
if grep -q 'loading="lazy"' docs/theater/index.html; then
    echo -e "${GREEN}✓ PASS${NC} - Theater image has lazy loading"
    ((PASS++))
else
    echo -e "${RED}✗ FAIL${NC} - Theater image missing lazy loading"
    ((FAIL++))
fi

# Test 7: Verify optimized images exist
echo "📁 Test 7: Optimized image files exist..."
MISSING=0
if [ ! -f "src/assets/images/chris-guimarin-300.jpg" ]; then
    echo -e "${RED}  ✗ Missing chris-guimarin-300.jpg${NC}"
    ((MISSING++))
fi
if [ ! -f "src/assets/images/chris-guimarin-600.jpg" ]; then
    echo -e "${RED}  ✗ Missing chris-guimarin-600.jpg${NC}"
    ((MISSING++))
fi
if [ ! -f "src/assets/images/chris-guimarin-900.jpg" ]; then
    echo -e "${RED}  ✗ Missing chris-guimarin-900.jpg${NC}"
    ((MISSING++))
fi

if [ $MISSING -eq 0 ]; then
    echo -e "${GREEN}✓ PASS${NC} - All optimized image files exist"
    ((PASS++))
else
    echo -e "${RED}✗ FAIL${NC} - Missing $MISSING optimized image files"
    ((FAIL++))
fi

# Test 8: Check file sizes
echo "📊 Test 8: Checking file sizes..."
PROFILE_SIZE=$(stat -f%z "src/assets/images/chris-guimarin-600.jpg" 2>/dev/null || echo 0)
THEATER_SIZE=$(stat -f%z "src/assets/images/theater/Real-Women-Have-Curves-Playbill-2025-04-01_Web.jpg" 2>/dev/null || echo 0)

if [ $PROFILE_SIZE -lt 500000 ]; then
    echo -e "${GREEN}✓ PASS${NC} - Profile photo is < 500KB ($((PROFILE_SIZE / 1024))KB)"
    ((PASS++))
else
    echo -e "${RED}✗ FAIL${NC} - Profile photo is too large ($((PROFILE_SIZE / 1024))KB)"
    ((FAIL++))
fi

# Test 9: CSS has image placeholders
echo "🎨 Test 9: CSS has image placeholders..."
if grep -q 'background-color: var(--color-border)' src/assets/css/main.css; then
    echo -e "${GREEN}✓ PASS${NC} - CSS placeholders configured"
    ((PASS++))
else
    echo -e "${RED}✗ FAIL${NC} - No CSS placeholders found"
    ((FAIL++))
fi

# Test 10: Image component exists
echo "🧩 Test 10: Reusable image component exists..."
if [ -f "src/_includes/image.njk" ]; then
    echo -e "${GREEN}✓ PASS${NC} - Image component created"
    ((PASS++))
else
    echo -e "${RED}✗ FAIL${NC} - Image component missing"
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
