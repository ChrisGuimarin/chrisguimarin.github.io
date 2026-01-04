# Testing Guide

This document explains how to run tests locally and in CI, update baselines, and understand platform-specific considerations.

## Table of Contents

- [Test Types](#test-types)
- [Running Tests Locally](#running-tests-locally)
- [Updating Baselines](#updating-baselines)
- [CI/CD Pipeline](#cicd-pipeline)
- [Platform Considerations](#platform-considerations)
- [Troubleshooting](#troubleshooting)

## Test Types

### 1. CSS Linting

Ensures CSS follows consistent style guidelines and best practices.

```bash
# Run CSS linting
npm run lint:css

# Auto-fix issues where possible
npm run lint:css:fix
```

**What it checks:**
- Selector specificity ordering
- No duplicate properties
- No deprecated properties
- Consistent formatting

### 2. Visual Regression Tests

Automated screenshot comparison tests using Playwright to catch unintended visual changes.

```bash
# Run visual tests
npm run test:visual

# Update baselines
npm run test:visual:update
```

**Pages tested (3 viewports each: desktop, tablet, mobile):**
- Homepage (/)
- Shelf (/shelf/)
- Writing index (/writing/)
- Writing post detail (/writing/marks-on-blank-pages/)
- About (/about/)
- Theater (/theater/)
- Projects (/projects/)

### 3. Accessibility Tests

Automated accessibility checks to ensure the site is usable for all visitors.

**What it checks:**
- Page titles exist
- Main landmarks present
- Skip links available
- Images have alt text
- Form inputs have labels
- Heading hierarchy is proper
- Links have discernible text
- Buttons have discernible text or aria-label

### 4. RSS Feed Validation

Shell script that validates RSS/Atom feed structure and content.

```bash
./verify-rss-feeds.sh
```

**What it checks:**
- Site builds successfully
- Feed files exist (unified and writing-specific)
- Valid XML structure
- Book entries have correct prefixes
- Feed autodiscovery links present
- Writing section structure

### 5. Image Optimization Verification

Shell script that validates image optimization implementation.

```bash
./verify-image-optimization.sh
```

**What it checks:**
- Lazy loading on book covers
- Async decoding on images
- Profile photo uses optimized JPG
- Responsive images with srcset
- Eager loading on above-fold images
- Optimized image files exist
- File sizes are reasonable
- CSS placeholders configured

### 6. Visual Consistency Verification

Shell script that validates visual consistency tooling.

```bash
./verify-visual-consistency.sh
```

**What it checks:**
- Stylelint is installed
- Stylelint config exists
- Component CSS files exist and are imported
- Playwright is installed
- Playwright config exists
- Visual test files exist
- Baseline screenshots exist

## Running Tests Locally

### Prerequisites

```bash
# Install dependencies
npm ci

# Build the site
npm run build
```

### Run All Tests

```bash
# CSS linting
npm run lint:css

# Visual regression tests
npm run test:visual

# Verification scripts
./verify-rss-feeds.sh
./verify-image-optimization.sh
./verify-visual-consistency.sh
```

### Run Specific Tests

```bash
# Run only visual tests for a specific page
npx playwright test --grep "homepage"

# Run only accessibility tests
npx playwright test accessibility.spec.js

# Run tests in UI mode for debugging
npx playwright test --ui
```

## Updating Baselines

Visual regression baselines need to be updated when intentional visual changes are made.

### Local Update (macOS/Windows)

⚠️ **Warning:** Local baselines may differ from CI baselines due to platform rendering differences.

```bash
# Update all baselines
npm run test:visual:update

# Update specific test
npx playwright test --update-snapshots --grep "homepage"
```

### CI Update (Recommended)

To ensure baselines match the CI environment:

1. Make your visual changes
2. Run the "Update Visual Baselines" workflow manually
   - Go to GitHub Actions
   - Select "Update Visual Baselines"
   - Click "Run workflow"
   - Choose branch: your current branch
3. The workflow will commit updated baselines to your branch

## CI/CD Pipeline

### Automated Checks (`.github/workflows/visual-consistency.yml`)

Runs on every push and pull request to `main`:

1. **Build site** - `npm run build`
2. **CSS linting** - `npm run lint:css` (must pass, no continue-on-error)
3. **Visual regression tests** - `npm run test:visual`
4. **RSS feed verification** - `./verify-rss-feeds.sh`
5. **Image optimization verification** - `./verify-image-optimization.sh`
6. **Visual consistency verification** - `./verify-visual-consistency.sh`

### Manual Workflows

#### Generate Visual Baselines (`.github/workflows/generate-visual-baselines.yml`)

One-time workflow to generate initial baselines on Linux/CI environment.

#### Update Visual Baselines (`.github/workflows/update-visual-baselines.yml`)

Update baselines when visual changes are intentional:
- Manual trigger only
- Specify branch to update
- Commits changes back to the branch

## Platform Considerations

### Rendering Differences

Different operating systems render fonts and UI elements slightly differently:

- **macOS**: Uses native font rendering
- **Linux (CI)**: Uses different font rendering engine
- **Windows**: Uses ClearType

**Recommendation:** Always use Linux (CI)-generated baselines for consistency.

### Playwright Browser

Tests use Chromium in headless mode for consistency across environments.

### Viewport Sizes

Tests cover three standard breakpoints:
- **Desktop**: 1400x900
- **Tablet**: 800x1024
- **Mobile**: 375x667

## Troubleshooting

### Visual tests failing locally but passing in CI

**Cause:** Platform rendering differences

**Solution:**
1. Pull latest baselines from CI
2. Don't update baselines locally
3. Use CI workflow to update baselines

### CSS linting failures

**Cause:** Code style violations

**Solution:**
```bash
# Auto-fix what can be fixed
npm run lint:css:fix

# Manually fix remaining issues
npm run lint:css
```

### Playwright browser not found

**Cause:** Playwright browsers not installed

**Solution:**
```bash
npx playwright install --with-deps chromium
```

### Tests timing out

**Cause:** Slow network or heavy page load

**Solution:**
- Increase timeout in playwright.config.js
- Check network connection
- Ensure dev server is running

### RSS feed validation failures

**Cause:** Feed structure or content issues

**Solution:**
1. Check feed XML syntax
2. Verify all required fields are present
3. Ensure feed files are generated during build

## Best Practices

1. **Always run tests before committing** - Catch issues early
2. **Update baselines on CI** - Avoid platform inconsistencies
3. **Review visual diffs carefully** - Ensure changes are intentional
4. **Write descriptive test names** - Make failures easier to understand
5. **Keep tests fast** - Use appropriate timeouts and waits
6. **Test accessibility** - Ensure site is usable for all visitors

## Adding New Tests

### Add a new page to visual tests

Edit `tests/visual/pages.spec.js`:

```javascript
const pages = [
  // ... existing pages
  { name: 'new-page', path: '/new-page/' },
];
```

### Add a new accessibility check

Edit `tests/visual/accessibility.spec.js` and add checks to the test loop.

### Add a new verification script

1. Create `.sh` file in project root
2. Make it executable: `chmod +x script.sh`
3. Add to CI workflow
4. Document in this file

## Resources

- [Playwright Documentation](https://playwright.dev/)
- [Stylelint Documentation](https://stylelint.io/)
- [Web Content Accessibility Guidelines (WCAG)](https://www.w3.org/WAI/WCAG21/quickref/)
