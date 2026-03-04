# chrisguimarin.com — Claude Code Context

Personal website built with [Eleventy](https://www.11ty.dev/) (11ty) v3. Deployed at chrisguimarin.com via GitHub Pages.

## Key Commands

```bash
npm start          # Dev server with live reload
npm run build      # Production build → /docs
npm run lint:css   # Stylelint check
npm run lint:css:fix  # Auto-fix CSS issues
npm run test:visual   # Playwright visual smoke test (homepage only)
npm run test:visual:update  # Update baseline screenshot
```

## Architecture

- **Input**: `/src` (Nunjucks templates, Markdown content, CSS)
- **Output**: `/docs` (GitHub Pages — do NOT edit manually)
- **CSS**: PostCSS + postcss-import, modular components in `src/assets/css/components/`
- **Templates**: `src/_includes/` (base.njk, book.njk, work.njk, post.njk, etc.)
- **Collections**: `work`, `writing`, `books` — defined in `.eleventy.js`

## Content Patterns

### Books (`src/books/*.md`)
```yaml
---
title: "Book Title"
author: "Author Name"
category: "Category"
cover: /assets/images/shelf/book-cover.jpg
link: https://bookshop.org/link
dateAdded: 2025-01-15
---
```

### Writing (`src/writing/*.md`)
```yaml
---
title: "Post Title"
date: 2025-01-20
excerpt: "Brief summary"
---
```

## CSS Conventions

- CSS variables only — no hardcoded hex colors
- Spacing: `--spacing-xs/sm/md/lg`
- Colors: `--color-primary`, `--color-text`, `--color-text-muted`, `--color-border`
- New components → `src/assets/css/components/[name].css` → import in `main.css`
- Class names: kebab-case

## Engineering Preferences

- **DRY** — flag repetition aggressively
- **Well-tested** — err toward more tests, not fewer
- **Explicit over clever** — readable > tricky
- **Handle edge cases** — thoughtfulness > speed
- **"Engineered enough"** — no premature abstraction, no fragile hacks

## Compound Engineering

Saved solutions live in `.claude/solutions/`. When a non-trivial problem is solved, use `/workflows:compound` to document it there.

## Commit Format

```
type: short description

- Detail
- Detail

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `perf`

## Before Any PR

1. `npm run build` — must succeed
2. `npm run lint:css` — no errors (warnings OK)
3. `npm run test:visual` — must pass (or update baseline if change is intentional)
4. Manual spot-check in browser
