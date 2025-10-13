# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

This is a personal website for Chris Guimarin built with [Eleventy](https://www.11ty.dev/) (11ty) static site generator. The site features sections for design work, theater involvement, projects, a book shelf, and personal information. The site is deployed to GitHub Pages at chrisguimarin.github.io.

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
4. **Accessibility**: Skip links, proper ARIA labels, keyboard navigation support

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

## Development Workflow

When working on this site:
1. Use `npm start` for development with live reload
2. Content changes in `/src` automatically trigger rebuilds
3. CSS changes are processed through PostCSS import system
4. The site builds to `/docs` for GitHub Pages deployment
5. Test theme toggle functionality and responsive behavior across breakpoints

## Production Notes

- The site outputs to `/docs` directory for GitHub Pages compatibility
- CSS is processed and concatenated through PostCSS
- All assets are copied to output directory
- The site includes proper meta tags, favicons, and accessibility features