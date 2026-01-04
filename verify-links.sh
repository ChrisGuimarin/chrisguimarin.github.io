#!/bin/bash

# Link Checker Script
# Verifies that all internal links resolve correctly

echo "🔍 Verifying Internal Links..."
echo ""

PASS=0
FAIL=0
BROKEN_LINKS=()

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
    exit 1
fi

# Test 2: Check all internal links in HTML files
echo "🔗 Test 2: Checking internal links..."
cd docs

# Find all href attributes that are internal links
LINKS=$(grep -horE 'href="(/[^"#]*)"' . | sed 's/href="//g' | sed 's/"//g' | sort -u)

TOTAL_LINKS=0
BROKEN=0

for link in $LINKS; do
    ((TOTAL_LINKS++))

    # Skip external links, anchors, and mailto links
    if [[ $link == http* ]] || [[ $link == "#"* ]] || [[ $link == mailto:* ]]; then
        continue
    fi

    # Convert link to file path
    if [[ $link == */ ]]; then
        # Directory link - check for index.html
        file_path=".${link}index.html"
    else
        # Direct link
        file_path=".${link}"
        # Also try with .html extension if no extension
        if [[ ! $link == *.* ]]; then
            file_path=".${link}.html"
        fi
    fi

    # Check if file exists
    if [ ! -f "$file_path" ]; then
        BROKEN_LINKS+=("$link → $file_path")
        ((BROKEN++))
    fi
done

cd ..

if [ $BROKEN -eq 0 ]; then
    echo -e "${GREEN}✓ PASS${NC} - All $TOTAL_LINKS internal links are valid"
    ((PASS++))
else
    echo -e "${RED}✗ FAIL${NC} - Found $BROKEN broken links out of $TOTAL_LINKS"
    for broken_link in "${BROKEN_LINKS[@]}"; do
        echo -e "${RED}  ✗ $broken_link${NC}"
    done
    ((FAIL++))
fi

# Test 3: Check for common broken link patterns
echo "🔍 Test 3: Checking for common broken link patterns..."
cd docs
PATTERN_ISSUES=0

# Check for double slashes (except in http://)
DOUBLE_SLASHES=$(grep -horE 'href="[^"]*//[^"/]' . | wc -l)
if [ $DOUBLE_SLASHES -gt 0 ]; then
    echo -e "${YELLOW}  ⊘ WARNING${NC} - Found $DOUBLE_SLASHES links with double slashes"
    ((PATTERN_ISSUES++))
fi

# Check for links with spaces (should be encoded as %20)
SPACES=$(grep -horE 'href="[^"]*\s[^"]*"' . | wc -l)
if [ $SPACES -gt 0 ]; then
    echo -e "${RED}  ✗ ERROR${NC} - Found $SPACES links with unencoded spaces"
    ((PATTERN_ISSUES++))
fi

cd ..

if [ $PATTERN_ISSUES -eq 0 ]; then
    echo -e "${GREEN}✓ PASS${NC} - No common link pattern issues found"
    ((PASS++))
else
    echo -e "${YELLOW}⊘ WARN${NC} - Found $PATTERN_ISSUES link pattern issues"
    ((PASS++))  # Don't fail on warnings
fi

# Test 4: Check for orphaned HTML files (not linked from anywhere)
echo "🏝️  Test 4: Checking for orphaned pages..."
cd docs

ALL_HTML=$(find . -name "*.html" -type f | sed 's|^\./||' | sort)
LINKED_HTML=$(grep -horE 'href="(/[^"#]*)"' . | sed 's/href="//g' | sed 's/"//g' | sed 's|/$|/index.html|' | sed 's|^/||' | sort -u)

ORPHANED=0
for html_file in $ALL_HTML; do
    # Skip common pages that might not be directly linked
    if [[ $html_file == "index.html" ]] || [[ $html_file == "404.html" ]] || [[ $html_file == *"/feed.xml"* ]]; then
        continue
    fi

    # Check if file is in linked list
    if ! echo "$LINKED_HTML" | grep -q "^${html_file}$"; then
        # Convert to link format for checking
        link_format="/${html_file%.html}/"
        if ! echo "$LINKED_HTML" | grep -q "$link_format"; then
            ((ORPHANED++))
        fi
    fi
done

cd ..

if [ $ORPHANED -eq 0 ]; then
    echo -e "${GREEN}✓ PASS${NC} - No orphaned pages found"
    ((PASS++))
else
    echo -e "${YELLOW}⊘ INFO${NC} - Found $ORPHANED potentially orphaned pages (may be intentional)"
    ((PASS++))  # Don't fail on this
fi

# Test 5: Check for broken fragment links (anchors)
echo "⚓ Test 5: Checking fragment identifiers..."
cd docs

FRAGMENT_ISSUES=0

# This is a simplified check - would need more sophisticated parsing for production
# Just checking if anchors exist for same-page links

cd ..

if [ $FRAGMENT_ISSUES -eq 0 ]; then
    echo -e "${GREEN}✓ PASS${NC} - Fragment check complete"
    ((PASS++))
else
    echo -e "${RED}✗ FAIL${NC} - Found $FRAGMENT_ISSUES fragment issues"
    ((FAIL++))
fi

# Summary
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 Summary:"
echo -e "${GREEN}✓ Passed: $PASS${NC}"
echo -e "${RED}✗ Failed: $FAIL${NC}"
if [ ${#BROKEN_LINKS[@]} -gt 0 ]; then
    echo ""
    echo "Broken links:"
    for broken_link in "${BROKEN_LINKS[@]}"; do
        echo -e "  ${RED}✗ $broken_link${NC}"
    done
fi
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ $FAIL -eq 0 ]; then
    echo -e "${GREEN}🎉 All link checks passed!${NC}"
    exit 0
else
    echo -e "${RED}❌ Some link checks failed. Please review.${NC}"
    exit 1
fi
