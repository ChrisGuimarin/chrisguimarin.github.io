# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

This is a personal website for Chris Guimarin built with [Eleventy](https://www.11ty.dev/) (11ty) static site generator. The site features sections for design work, theater involvement, projects, a book shelf, and personal information. The site is deployed at chrisguimarin.com (via GitHub Pages/Cloudflare Pages).

## Development Commands

```bash
npm start    # Start development server with live reload
npm run build    # Build for production (outputs to /docs directory)
```

The development server runs with Eleventy's `--serve` flag, providing live reload functionality for rapid development.

## Architecture Overview

### Build System
- **Static Site Generator**: Eleventy (11ty) v3.1.0
- **CSS Processing**: PostCSS with postcss-import for CSS file imports
- **Template Engine**: Nunjucks (.njk files) for layouts and includes
- **Output Directory**: `/docs` (configured for GitHub Pages)
- **Input Directory**: `/src`

### Content Structure
The site follows a collection-based architecture:

- **Collections**: Defined in `.eleventy.js` - `work`, `writing`, and `books` collections
- **Content Types**:
  - Books: Individual markdown files in `/src/books/` with frontmatter (title, author, category, cover, link)
  - Work: Portfolio pieces in `/src/work/`
  - Writing: Blog-style content in `/src/writing/`
  - Pages: Static pages (about, design, theater, projects, shelf) in respective directories

### Template System
- **Base Layout**: `src/_includes/base.njk` - Main HTML structure with navigation, theme toggle, and footer
- **Specialized Templates**: `book.njk`, `work.njk`, `post.njk`, `book-grid.njk` for different content types
- **Navigation**: Automatically highlights current page using `aria-current="page"`

### Styling Architecture
- **CSS Organization**: Modular CSS with imports in `main.css`
- **Component Structure**: Separate CSS files for components (nav, book, theater)
- **Design System**: CSS custom properties for consistent theming
- **Responsive Design**: Mobile-first approach with detailed breakpoint management
- **Theme System**: Light/dark mode toggle with system preference detection and localStorage persistence

### Key Features
1. **Book Shelf System**: Grid-based book display with category filtering using the `byCategory` filter
2. **Responsive Book Grid**: Adaptive columns (1-4 columns) based on viewport width
3. **Theme Toggle**: Manual override with system preference fallback and reset option
4. **Accessibility**: Skip links, ARIA labels, keyboard navigation, descriptive alt text

## File Organization

```
src/
├── _includes/          # Nunjucks templates and layouts
├── assets/
│   └── css/           # Modular CSS files
├── books/             # Individual book markdown files
├── work/              # Portfolio/work items
├── writing/           # Blog posts and articles
├── about/             # About page
├── design/            # Design work showcase
├── theater/           # Theater-related content
├── projects/          # Projects showcase
├── shelf/             # Book shelf page
└── index.md           # Homepage content
```

## Content Management

### Adding Books
Create new markdown files in `src/books/` with this frontmatter structure:
```yaml
---
title: "Book Title"
author: "Author Name"
category: "Category Name"
cover: /assets/images/shelf/book-cover.jpg
link: https://bookshop.org/link
dateAdded: 2025-01-15
---
```
Note: `dateAdded` is required for RSS feed sorting.

### Adding Writing Posts
Create markdown files in `src/writing/` with frontmatter:
```yaml
---
title: "Post Title"
date: 2025-01-20
excerpt: "Brief summary for feeds and listings"
---
```
The `writing.json` file applies defaults (layout: post.njk, tags: writing, permalink).

### Adding Work Items
Create markdown files in `src/work/` with frontmatter including `title`, `layout`, `date`, and `type`.

### Theme and Styling
- CSS custom properties defined in `:root` for easy theming
- Dark mode handled via `prefers-color-scheme` and `data-theme` attributes
- Book grid uses CSS Grid with `auto-fill` and responsive book widths

## Eleventy Configuration Notes

The `.eleventy.js` configuration includes:
- PassthroughCopy for assets
- CSS template format with PostCSS processing for main.css
- Date filters (`dateIso`, `dateReadable`)
- Collections for content organization
- Custom `byCategory` filter for book categorization

## Development Best Practices

### Pre-Implementation Checklist

Before starting any new feature or significant change:

**1. Version Control Setup**
- Check git status for uncommitted changes: `git status`
- Clean or commit any untracked/modified files
- Create feature branch with descriptive name: `git checkout -b feature/descriptive-name`
- Branch naming conventions:
  - Features: `feature/feature-name`
  - Bug fixes: `fix/bug-description`
  - Documentation: `docs/what-changed`
  - Refactoring: `refactor/what-changed`

**2. Test Strategy Planning**

Identify test cases before implementing:
- **Build Tests**: Site builds without errors (`npm run build`)
- **Visual Tests**: Pages render correctly, styles apply properly
- **Content Tests**: Collections populate, templates render correctly
- **Integration Tests**: Third-party integrations work (Buttondown, etc.)
- **Cross-browser/Device Tests**: Responsive design works across breakpoints

**3. Implementation Phases**
- Break work into logical phases/commits
- Test after each phase before proceeding
- Keep commits atomic (one logical change per commit)
- Write descriptive commit messages:
  ```
  feat: add RSS feed support for writing and books
  fix: correct book date sorting in feed
  docs: update WARP.md with RSS feed info
  ```

**4. Commit Message Format**
- Use conventional commits format: `type: description`
- Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`
- Include co-author line: `Co-Authored-By: Warp <agent@warp.dev>`
- Example:
  ```
  feat: implement RSS feeds for writing and books
  
  - Add dateAdded field to book frontmatter
  - Create unified feed at /feed.xml
  - Create writing-only feed at /writing/feed.xml for Buttondown
  - Add feed autodiscovery links to base template
  
  Co-Authored-By: Warp <agent@warp.dev>
  ```

**5. Testing Workflow**
- Test locally before pushing: `npm run build && npm start`
- Verify all test cases from planning phase
- Check for console errors or build warnings
- Test in multiple browsers if UI changes are involved
- Validate external integrations (RSS feeds, forms, etc.)
- **Run CSS linting**: `npm run lint:css` to check for CSS issues
- **Run visual regression tests**: `npm run test:visual` to catch UI changes
- **Review visual diffs**: If visual tests fail, check `test-results/` for diff images
- **Update baselines if intentional**: Use `npm run test:visual:update` only for deliberate UI changes
- **Create verification scripts when appropriate:**
  - For complex features, create bash scripts to automate testing (e.g., `verify-*.sh`)
  - Script should test all acceptance criteria with pass/fail reporting
  - Use colored output (GREEN/RED/YELLOW) for readability
  - Example: `verify-image-optimization.sh` tests lazy loading, file sizes, etc.
  - Make scripts executable: `chmod +x verify-*.sh`
  - Include scripts in commits so they're available for future regression testing

**6. Rollback Strategy**
- Keep commits small and reversible
- Know how to revert: `git revert <commit-hash>`
- Test at each phase so issues are caught early
- Document any breaking changes or migration steps

**7. Documentation Updates**
- Update WARP.md with new features, commands, or workflows
- Document any new dependencies or configuration
- Update README if user-facing changes occur
- Note any special deployment or setup steps

**8. Code Quality Practices**
- **Create reusable components:** When implementing repeating patterns, create Nunjucks components in `src/_includes/`
  - Example: `image.njk` for consistent image handling with lazy loading, srcset, etc.
  - Example: `book-grid.njk` for displaying book collections
- **Performance optimization:**
  - Compress images before adding to repo (use ImageOptim, Squoosh, or similar)
  - Use lazy loading (`loading="lazy"`) for below-fold images
  - Use eager loading (`loading="eager"`) for above-fold/critical images
  - Add `decoding="async"` to all images
  - Implement responsive images with `srcset` and `sizes` for large images
  - Add CSS placeholders to prevent layout shift during image loading
- **Accessibility:**
  - Always include descriptive `alt` text for images
  - Test keyboard navigation
  - Verify ARIA labels and semantic HTML

### Standard Development Workflow

1. **Start**: Create feature branch from clean main
2. **Implement**: Work in phases, commit after each phase
   - Use `npm start` for development with live reload
   - Content changes in `/src` automatically trigger rebuilds
   - CSS changes are processed through PostCSS import system
3. **Test**: Run `npm run build` and verify functionality
4. **Commit**: Use conventional commit format with co-author line
5. **Push**: `git push origin feature/branch-name`
6. **Review**: Create PR or review changes locally
7. **Merge**: Merge to main when ready
8. **Deploy**: Push to production (GitHub Pages/Cloudflare Pages)
9. **Verify**: Test in production environment
10. **Document**: Update WARP.md or other docs as needed

## RSS Feeds

The site provides two RSS feeds using the @11ty/eleventy-plugin-rss plugin:

### Feed URLs
- **Unified Feed**: `/feed.xml` - Combined books and writing for RSS readers
- **Writing Feed**: `/writing/feed.xml` - Writing posts only for Buttondown email automation

### Feed Features
- Book entries prefixed with "📚 Added to shelf:"
- Books sorted by `dateAdded` field (reverse chronological)
- Writing posts sorted by `date` field (reverse chronological)
- Autodiscovery links in `<head>` for RSS reader detection
- Valid Atom XML format

### Buttondown Integration
The writing-only feed (`/writing/feed.xml`) is configured for Buttondown email automation:
1. In Buttondown → Settings → Automations
2. Add automation: "Send email when RSS feed updates"
3. URL: `https://chrisguimarin.com/writing/feed.xml`
4. Set to "Draft" mode initially to review emails before sending

This ensures that adding books to the shelf doesn't trigger emails, but publishing writing posts does.

### Testing Feeds
Run the verification scripts to test RSS implementation:
```bash
./verify-rss-feeds.sh      # Tests feed structure and content
./verify-rss-styling.sh    # Tests feed styling and page icons
```
The scripts test: build success, feed existence, XML validity, XSLT styling, RSS icons on pages, and educational banner.

### Feed Styling (Browser Presentation)
When users visit RSS feeds directly in a browser, they see a styled HTML page instead of raw XML:
- **XSLT Stylesheet**: `src/assets/feed.xsl` transforms Atom XML into branded HTML
- **Educational Banner**: Explains what RSS is with link to aboutfeeds.com
- **Theme Support**: Light/dark mode via `prefers-color-scheme`
- **Branding**: Uses Chris Guimarin site colors, typography, and spacing

RSS readers (Feedly, NetNewsWire, etc.) ignore the XSLT and parse the raw XML normally.

### RSS Icons on Pages
The shelf and writing pages display RSS subscribe icons:
- **Shelf page**: Links to `/feed.xml` (books feed)
- **Writing page**: Links to `/writing/feed.xml` (writing-only feed)

Components used:
- `src/_includes/page-header.njk` - Page title with optional RSS icon
- `src/_includes/rss-icon.njk` - Reusable RSS icon with accessible markup
- `src/assets/css/components/rss.css` - Icon and page header styling

To add RSS icon to a new page:
```liquid
{% render "page-header.njk", title: "Page Title", feedUrl: "/feed.xml", feedLabel: "Subscribe to updates" %}
```

## CSS Consistency and Linting

The site uses Stylelint to enforce CSS consistency and best practices.

### Stylelint Configuration
Configuration file: `.stylelintrc.json`
- Extends `stylelint-config-standard` for baseline rules
- Enforces kebab-case for class and custom property names
- Warns about hardcoded hex colors (use CSS variables instead)
- Ignores `@import` rules for PostCSS compatibility

### Running Stylelint
```bash
npm run lint:css          # Check CSS for issues
npm run lint:css:fix      # Auto-fix issues where possible
```

### CSS Best Practices
- **Use CSS variables** for colors, spacing, and fonts defined in `:root`
- **Create modular components** in `src/assets/css/components/` for new features
- **Import components** in `src/assets/css/main.css` using `@import`
- **Follow naming conventions**: kebab-case for classes (e.g., `.writing-item-title`)
- **Use existing spacing variables**: `--spacing-xs`, `--spacing-sm`, `--spacing-md`, `--spacing-lg`
- **Use color variables**: `--color-primary`, `--color-text`, `--color-text-muted`, `--color-border`

### Creating New CSS Components
1. Create new file in `src/assets/css/components/[component-name].css`
2. Use CSS custom properties from `:root` for all values
3. Add responsive behavior with existing breakpoints
4. Import in `src/assets/css/main.css` with `@import "components/[component-name].css";`
5. Run `npm run lint:css` to check for issues
6. Build site to verify: `npm run build`

Example component structure:
```css
/* Component-specific styles */
.component-name {
    margin: var(--spacing-md);
    color: var(--color-text);
}

/* Mobile responsive */
@media (max-width: 500px) {
    .component-name {
        margin: var(--spacing-sm);
    }
}
```

## Visual Regression Testing

The site uses Playwright for visual regression testing to catch unintended UI changes.

### Test Configuration
Configuration file: `playwright.config.js`
- Tests built site in `/docs` directory
- Uses http-server to serve site locally on port 8080
- Tests Chromium browser (can be extended to Firefox/WebKit)
- Baseline screenshots stored in `tests/visual/pages.spec.js-snapshots/`

### Running Visual Tests
```bash
npm run test:visual              # Run visual tests against baselines
npm run test:visual:update       # Update baseline screenshots
```

### Test Coverage
Tests capture screenshots of key pages across three viewports:
- **Desktop**: 1400x900
- **Tablet**: 800x1024
- **Mobile**: 375x667

Pages tested:
- Homepage (`/`)
- Shelf (`/shelf/`)
- Writing index (`/writing/`)
- About (`/about/`)
- Theater (`/theater/`)
- Projects (`/projects/`)

### When to Update Baselines
Update baselines when you intentionally change:
- Layout or positioning
- Colors or styling
- Typography or spacing
- Responsive behavior
- Content that affects page height

**Important**: Always review the diff images before updating baselines to ensure changes are intentional.

### When to Skip Visual Tests
When adding **new visual elements** (icons, components, layout changes), you can skip running visual regression tests during development since the baselines will need updating anyway. Instead:
1. Complete the feature implementation
2. Build and manually verify the changes look correct
3. Update baselines at the end: `npm run test:visual:update`
4. Review the new baseline screenshots before committing

### Visual Test Best Practices
- **Build before testing**: Always run `npm run build` before visual tests
- **Review diffs**: Check `test-results/` directory for diff images when tests fail
- **Commit baselines**: Baseline screenshots in `tests/visual/pages.spec.js-snapshots/` must be committed to git
- **CI will fail on mismatches**: GitHub Actions will catch visual regressions automatically

## Verification Scripts

The site includes verification scripts to test various aspects:

### Available Scripts
```bash
./verify-rss-feeds.sh                # Test RSS feed implementation
./verify-image-optimization.sh       # Test image optimization
./verify-visual-consistency.sh       # Test visual consistency tools
```

All scripts:
- Use colored output (GREEN ✓ / RED ✗ / YELLOW ⊘)
- Exit with code 0 on success, 1 on failure
- Can be run locally or in CI
- Follow consistent format for easy reading

### Visual Consistency Verification
The `verify-visual-consistency.sh` script checks:
1. Stylelint is installed
2. Stylelint config exists
3. Writing component CSS exists
4. Writing CSS is imported
5. Playwright is installed
6. Playwright config exists
7. Visual test files exist
8. Baseline screenshots exist
9. Stylelint passes (or only warnings)

## Continuous Integration

GitHub Actions workflow: `.github/workflows/visual-consistency.yml`

The CI pipeline runs on all pushes and pull requests:

### Pipeline Steps
1. **Checkout code**
2. **Setup Node.js** with npm caching
3. **Install dependencies** (`npm ci`)
4. **Build site** (`npm run build`)
5. **Run CSS linting** (continue on error for warnings)
6. **Install Playwright browsers**
7. **Run visual regression tests**
8. **Upload test artifacts** on failure (screenshots, diffs, reports)
9. **Run verification scripts** (RSS, images, visual consistency)

### CI Best Practices
- **All tests must pass** before merging PRs
- **Review test artifacts** if visual tests fail
- **Update baselines carefully** only for intentional changes
- **Monitor CI run time** and optimize if needed

## Production Notes

- The site outputs to `/docs` directory for GitHub Pages compatibility
- CSS is processed and concatenated through PostCSS
- All assets are copied to output directory
- The site includes proper meta tags, favicons, and accessibility features
- RSS feeds are generated at build time and deployed with the site
- Visual regression baselines are committed to ensure consistency across environments
