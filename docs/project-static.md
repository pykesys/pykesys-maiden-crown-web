# Maiden Crown Press — Project Status & Analysis

**Date:** 2026-10-30
**Version:** Static Site v1.0 (Pre-Dynamic Migration)

---

## Overview

This is a static website for **Maiden Crown Press**, an independent creative publishing house developing speculative fiction. The site promotes their founding saga, *The Weight of Thirty Worlds*, a six-book science-fiction epic.

**Live Site:** [maidencrownpress.com](https://maidencrownpress.com)
**Repository:** `pykesys-maiden-crown-web`
**Hosting:** GitHub Pages with custom domain

---

## Technology Stack

- **Pure HTML/CSS/JavaScript** — No frameworks or build tools
- **Zero dependencies** (only Google Fonts CDN)
- **GitHub Pages** hosting
- **Custom domain** configured via CNAME

---

## File Structure (Static Version)

```
pykesys-maiden-crown-web/
├── index.html       # Single-page website (minified HTML)
├── styles.css       # Complete styling (minified CSS)
├── script.js        # Dynamic year + mobile menu (5 lines)
├── CNAME           # Custom domain: maidencrownpress.com
├── .gitignore      # Standard ignores (macOS, editors)
└── README.md       # Comprehensive documentation
```

---

## Design Features

### Visual Design
- ✨ Animated starfield background using CSS radial gradients
- 👑 Custom SVG crown sigil with intricate details
- 🎨 Royal color palette:
  - Deep purple (ink): `#100d13`
  - Gold: `#d5b77b`
  - Pale: `#f3e5c9`
  - Dim: `#b4a48d`
  - Red: `#632537`
- 🌟 Decorative arched hero section with layered borders
- Orbital planet illustration (CSS-only)

### Typography
- **Cinzel** (serif) — headlines and branding
- **Cormorant Garamond** (serif) — italic emphasis and taglines
- **Inter** (sans-serif) — body text

### Responsive Design
- Mobile-first approach
- Breakpoints at 800px and 420px
- Collapsible mobile navigation
- Reduced motion support via `prefers-reduced-motion`

---

## Accessibility Features

- ARIA labels (`aria-label`, `aria-expanded`, `aria-hidden`)
- Semantic HTML structure
- Keyboard navigation support
- Theme color meta tag
- Reduced motion support
- WCAG compliant design

---

## JavaScript Functionality

**File:** `script.js` (5 lines, minified)

1. **Dynamic copyright year** — Updates footer year automatically
2. **Mobile menu toggle** — Opens/closes navigation with ARIA state management
3. **Auto-close menu** — Closes menu when clicking any navigation link

---

## Content Sections

1. **Hero** — "An Archive of Worlds Unforgotten" with custom crown sigil
2. **The Chronicles** — Introduction to the Maiden Crown saga
3. **The Worlds** — Overview of the thirty worlds and their inhabitants
4. **The House** — About Maiden Crown Press as a publishing house
5. **Contact** — Email link for inquiries (contact@maidencrownpress.com)

---

## Git Status at Migration

```
Current branch: main
Main branch: main

Modified:  README.md
Untracked: .gitignore, CNAME, index.html, script.js, styles.css

Recent commits:
17f8817 Initial commit
```

**Analysis:** The HTML, CSS, JS, CNAME, and .gitignore files were new additions (untracked at time of analysis). The README had been modified since the initial commit.

---

## Code Quality Assessment

### Strengths
✅ Well-structured, semantic HTML
✅ Accessibility features implemented
✅ Clean, minimal JavaScript
✅ Responsive design
✅ Fast loading (no external dependencies beyond fonts)
✅ Comprehensive documentation in README
✅ Zero-dependency architecture

### Observations
⚠️ HTML and CSS are **minified** (single-line), reducing readability for editing
⚠️ No source maps or unminified versions present
⚠️ Mobile menu uses `display: none` toggle (works but could use transform for smoother transitions)
⚠️ Email exposed in mailto link (potential spam target)

---

## Performance Characteristics

- **Load Time:** Near-instant (minimal assets)
- **Dependencies:** Google Fonts only
- **Asset Size:**
  - HTML: ~9KB (minified)
  - CSS: ~2KB (minified)
  - JS: <1KB
- **Total Page Weight:** <15KB (excluding fonts)

---

## Deployment Configuration

### GitHub Pages
- **Method:** Auto-deploys on push to `main` branch
- **Custom Domain:** maidencrownpress.com (configured via CNAME)

### DNS Configuration
**A Records (GitHub Pages):**
```
185.199.108.153
185.199.109.153
185.199.110.153
185.199.111.153
```

**CNAME (optional www subdomain):**
```
www → <your-github-username>.github.io
```

---

## Potential Improvements (Future Considerations)

1. **Code Readability:** Keep unminified source files for easier editing
2. **Email Privacy:** Consider contact form or obfuscation
3. **SEO Enhancement:** Add Open Graph and Twitter Card meta tags
4. **Analytics:** No analytics detected; consider adding if user tracking is desired
5. **Image Optimization:** If images are added later, implement lazy loading
6. **Progressive Enhancement:** Consider service workers for offline capability

---

## Content Architecture Note

Per the README, this is the "Market" distribution channel for Maiden Crown Press. It displays only Foundry-approved content. The backend content management system (Auger → Forge → Foundry → Market) is maintained in a separate private repository.

---

## Migration Plan

### Static Site Preservation
The current static site will be moved to `./static/` directory to preserve this working version.

### Dynamic Site Development
A new dynamic ecommerce platform will be developed in `./dynamic/` to support:
- User accounts and authentication
- Product catalog (books, merchandise)
- Shopping cart and checkout
- Order management
- Content management system
- Admin dashboard

---

## Technical Debt

- [ ] Unminify HTML/CSS for development
- [ ] Add source control for design assets
- [ ] Implement contact form instead of mailto link
- [ ] Add SEO meta tags
- [ ] Consider CDN for fonts (or self-host)

---

## Notes

- Site branding and design language should be preserved in dynamic version
- Color palette and typography choices are well-established
- SVG crown sigil is a key brand asset
- Accessibility standards must be maintained in new implementation

---

*This document captures the state of the static site before migration to a dynamic ecommerce platform.*
