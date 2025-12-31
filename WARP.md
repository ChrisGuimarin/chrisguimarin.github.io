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
---
```

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

## Production Notes

- The site outputs to `/docs` directory for GitHub Pages compatibility
- CSS is processed and concatenated through PostCSS
- All assets are copied to output directory
- The site includes proper meta tags, favicons, and accessibility features