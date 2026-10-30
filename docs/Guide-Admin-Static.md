# Administrator Guide — Static Site

**Maiden Crown Press Static Marketing Site**
**Location:** `./static/`
**Deployment:** GitHub Pages
**Domain:** maidencrownpress.com

---

## Overview

This guide covers how to manage and update the static marketing site for Maiden Crown Press. The static site is a single-page HTML website deployed via GitHub Pages.

**Purpose:** Marketing landing page, brand presence, public information
**Technology:** Pure HTML/CSS/JavaScript (no frameworks)
**Hosting:** GitHub Pages with custom domain

---

## File Structure

```
static/
├── index.html      # Main HTML file
├── styles.css      # All styling (minified)
├── script.js       # Interactive elements
└── CNAME          # Custom domain configuration
```

---

## Making Updates

### Updating Content

#### 1. Hero Section

**Location:** `index.html` (lines 4-5, within `<section class="hero">`)

**What you can change:**
- Main heading text: `MAIDEN CROWN`
- Tagline: "Some stories are remembered. Others are forged."
- Eyebrow text: "AN ARCHIVE OF WORLDS UNFORGOTTEN"
- Call-to-action button text

**Example:**
```html
<h1>MAIDEN<br><em>CROWN</em></h1>
<p class="tagline">Some stories are remembered.<br>Others are forged.</p>
```

**⚠️ Note:** The HTML is minified (single line). Use a browser "Inspect Element" to navigate or unminify first.

---

#### 2. The Chronicles Section

**Location:** `index.html` (within `<section id="chronicles">`)

**What you can change:**
- Section heading
- Introduction paragraph
- Book title and description
- Links

---

#### 3. The Worlds Section

**Location:** `index.html` (within `<section id="worlds">`)

**What you can change:**
- Grid item titles and descriptions
- Number of world cards (add/remove `<article>` elements)

---

#### 4. Contact Email

**Location:** `index.html` (search for `mailto:`)

**Current:** `contact@maidencrownpress.com`

**To update:**
```html
<a href="mailto:your-new-email@maidencrownpress.com?subject=Maiden%20Crown%20Press%20Inquiry">
```

---

### Updating Styles

#### Color Palette

**Location:** `styles.css` (`:root` section at the top)

**Current colors:**
```css
:root {
  --ink: #100d13;      /* Deep purple background */
  --gold: #d5b77b;     /* Gold accents */
  --pale: #f3e5c9;     /* Pale text */
  --dim: #b4a48d;      /* Dimmed text */
  --red: #632537;      /* Red accents */
}
```

**To change a color:**
1. Unminify `styles.css` (use an online tool or editor)
2. Find the `:root` section
3. Change the hex color value
4. Save and test locally
5. Optionally re-minify before deploying

---

#### Typography

**Fonts used:**
- **Cinzel** (serif) — Headlines, branding
- **Cormorant Garamond** (serif) — Italics, taglines
- **Inter** (sans-serif) — Body text

**Loaded from:** Google Fonts CDN (top of `styles.css`)

**To change fonts:**
1. Find a Google Font you like: https://fonts.google.com
2. Replace the `@import` URL at the top of `styles.css`
3. Update font-family declarations throughout the CSS

---

### Updating the Crown Sigil (SVG)

**Location:** `index.html` (within `<div class="sigil">`)

The crown is a custom SVG graphic. To modify:

1. Copy the SVG code from `index.html`
2. Use an SVG editor (e.g., Figma, Inkscape, or online editor)
3. Make your changes
4. Export as SVG code
5. Replace the `<svg>` element in `index.html`

**⚠️ Warning:** Changing the SVG may affect brand consistency.

---

## Deployment Workflow

### How It Works

GitHub Pages automatically deploys the site when you push changes to the `main` branch.

**Deployment process:**
1. You commit changes to `static/` directory
2. Push to GitHub (`main` branch)
3. GitHub Pages detects changes
4. Site rebuilds automatically (usually within 1-2 minutes)
5. Changes appear at maidencrownpress.com

---

### Step-by-Step: Making a Content Update

#### Step 1: Clone the Repository (First Time Only)

```bash
git clone https://github.com/your-username/pykesys-maiden-crown-web.git
cd pykesys-maiden-crown-web
```

---

#### Step 2: Navigate to Static Directory

```bash
cd static
```

---

#### Step 3: Edit Files

**Option A: Use a Code Editor**
```bash
# Open in VS Code
code index.html

# Or use any text editor
nano index.html
```

**Option B: Use GitHub Web Interface**
1. Go to GitHub repository
2. Navigate to `static/index.html`
3. Click "Edit" (pencil icon)
4. Make changes
5. Commit directly (skip to Step 7)

---

#### Step 4: Test Locally (Recommended)

```bash
# Serve the site locally
python3 -m http.server 8000

# Open in browser
open http://localhost:8000
```

**Check:**
- Content appears correctly
- Links work
- No broken layouts
- Mobile responsive (test by resizing browser)

---

#### Step 5: Stage Changes

```bash
cd ..  # Go back to repo root
git add static/
git status  # Verify changes
```

---

#### Step 6: Commit Changes

```bash
git commit -m "Update hero tagline and contact email"
```

**Good commit messages:**
- "Update Chronicles section with Book 2 announcement"
- "Change contact email to press@maidencrownpress.com"
- "Add new world card for Dispensation XII"

**Bad commit messages:**
- "Update"
- "Changes"
- "asdf"

---

#### Step 7: Push to GitHub

```bash
git push origin main
```

**Authentication:**
- You may need to enter GitHub username/password
- Or use SSH keys (recommended for frequent updates)
- Or use Personal Access Token (GitHub requirement)

---

#### Step 8: Verify Deployment

1. Wait 1-2 minutes for GitHub Pages to rebuild
2. Visit https://maidencrownpress.com
3. Hard refresh to clear cache: `Cmd+Shift+R` (Mac) or `Ctrl+F5` (Windows)
4. Verify your changes appear

---

### Emergency Rollback

**If something breaks:**

#### Option 1: Revert via GitHub
1. Go to repository on GitHub
2. Click "Commits"
3. Find the last working commit
4. Click "Browse files" button (in top right)
5. Click "Revert" on that commit

#### Option 2: Revert via Git
```bash
# See recent commits
git log --oneline

# Revert to a specific commit
git revert <commit-hash>
git push origin main
```

#### Option 3: Quick Fix
```bash
# Discard local changes
git checkout -- static/index.html

# Or reset to origin
git fetch origin
git reset --hard origin/main
```

---

## Common Tasks

### Task 1: Update Copyright Year

**When:** Every January 1st

**Where:** `index.html` (footer section) + `script.js`

**How:**
The year updates automatically via JavaScript (`script.js:1`):
```javascript
document.getElementById('year').textContent = new Date().getFullYear();
```

**No action needed** — it updates automatically!

But double-check in January to ensure it's working.

---

### Task 2: Add a New Section

**Example:** Adding a "Press" section

1. Open `index.html`
2. Add a new `<section>` before the footer:

```html
<section id="press" class="section">
  <p class="eyebrow">IV · PRESS</p>
  <h2>For the Record</h2>
  <p>Media inquiries and press materials.</p>
  <a class="primary secondary" href="mailto:press@maidencrownpress.com">
    CONTACT PRESS <span>↗</span>
  </a>
</section>
```

3. Update navigation in `<header>`:

```html
<nav id="navigation">
  <a href="#chronicles">The Chronicles</a>
  <a href="#worlds">The Thirty Worlds</a>
  <a href="#house">The House</a>
  <a href="#press">Press</a>  <!-- NEW -->
  <a href="mailto:contact@maidencrownpress.com" class="nav-contact">Contact ↗</a>
</nav>
```

4. Test locally, commit, push

---

### Task 3: Update Meta Tags (SEO)

**Where:** `index.html` (within `<head>`)

**Current description:**
```html
<meta name="description" content="Maiden Crown Press — stories of memory, power, and the worlds between.">
```

**To improve SEO:**
- Keep under 160 characters
- Include keywords naturally
- Be descriptive and compelling

**Example:**
```html
<meta name="description" content="Maiden Crown Press publishes The Weight of Thirty Worlds, a six-book sci-fi saga exploring power, memory, and authority across thirty worlds.">
```

**Also add Open Graph tags for social media:**
```html
<meta property="og:title" content="Maiden Crown Press — Enter the Archives">
<meta property="og:description" content="Stories of memory, power, and the worlds between.">
<meta property="og:image" content="https://maidencrownpress.com/og-image.jpg">
<meta property="og:url" content="https://maidencrownpress.com">
<meta property="og:type" content="website">

<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="Maiden Crown Press">
<meta name="twitter:description" content="Stories of memory, power, and the worlds between.">
<meta name="twitter:image" content="https://maidencrownpress.com/og-image.jpg">
```

---

### Task 4: Change the Domain

**Current:** maidencrownpress.com

**To change:**

1. Update `static/CNAME` file:
```
newdomain.com
```

2. Configure DNS at your domain registrar:
   - **A Records** (point to GitHub Pages IPs):
     ```
     185.199.108.153
     185.199.109.153
     185.199.110.153
     185.199.111.153
     ```
   - Wait 24-48 hours for DNS propagation

3. In GitHub repo settings:
   - Go to Settings → Pages
   - Verify custom domain is detected
   - Enforce HTTPS (recommended)

---

### Task 5: Add Google Analytics

**To track visitors:**

1. Create Google Analytics account
2. Get tracking ID (e.g., `G-XXXXXXXXXX`)
3. Add script to `index.html` (before `</head>`):

```html
<!-- Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-XXXXXXXXXX"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'G-XXXXXXXXXX');
</script>
```

4. Commit and push
5. Verify tracking in Google Analytics dashboard

---

## Troubleshooting

### Site Not Updating After Push

**Possible causes:**

1. **Browser cache**
   - Solution: Hard refresh (`Cmd+Shift+R` or `Ctrl+F5`)
   - Try incognito/private window

2. **GitHub Pages build failed**
   - Check: GitHub repo → Actions tab
   - Look for red X (failed build)
   - Check error logs

3. **Pushed to wrong branch**
   - Ensure you're on `main` branch: `git branch`
   - Switch if needed: `git checkout main`

4. **DNS issues (custom domain)**
   - Check DNS propagation: https://dnschecker.org
   - Verify CNAME file is correct
   - Check GitHub Pages settings

---

### Broken Layout After Edit

**Symptoms:**
- Elements overlapping
- Missing sections
- CSS not loading

**Likely causes:**

1. **Unclosed HTML tag**
   - Look for missing `</div>`, `</section>`, etc.
   - Use HTML validator: https://validator.w3.org

2. **CSS syntax error**
   - Missing semicolon or curly brace
   - Use CSS validator or browser DevTools

3. **JavaScript error**
   - Open browser console (F12)
   - Check for error messages

**Quick fix:**
```bash
git checkout -- static/index.html  # Discard changes
```

---

### Mobile Navigation Not Working

**Check:** `script.js` is loaded

**Verify:**
1. Open browser DevTools (F12)
2. Go to Console tab
3. Look for JavaScript errors

**Common issue:** Minified code needs proper escaping

---

### Custom Domain Not Working

**Checklist:**

- [ ] CNAME file exists with correct domain
- [ ] DNS A records point to GitHub IPs
- [ ] DNS propagation complete (24-48 hours)
- [ ] HTTPS enforced in GitHub Pages settings
- [ ] No conflicting DNS records (old hosting)

**Test DNS:**
```bash
dig maidencrownpress.com
# Should show GitHub Pages IPs
```

---

## Best Practices

### 1. Always Test Locally First

Never push directly to production without testing.

```bash
cd static
python3 -m http.server 8000
# Test thoroughly before committing
```

---

### 2. Use Descriptive Commit Messages

**Good:**
```bash
git commit -m "Add Book 2 announcement to Chronicles section"
```

**Bad:**
```bash
git commit -m "update"
```

---

### 3. Keep Backups

**Option 1: Git Tags**
```bash
# Tag stable versions
git tag -a v1.0 -m "Stable release before redesign"
git push origin v1.0
```

**Option 2: Branch Before Major Changes**
```bash
git checkout -b redesign-experiment
# Make changes
# Test
# Merge when ready
git checkout main
git merge redesign-experiment
```

---

### 4. Unminify Before Editing

Minified files are hard to read. Use online tools:
- HTML: https://htmlformatter.com/
- CSS: https://www.cleancss.com/css-beautify/

**Workflow:**
1. Unminify file
2. Make edits
3. Optionally re-minify
4. Test
5. Deploy

---

### 5. Preserve Accessibility

When making changes, maintain:
- ARIA labels
- Alt text on images
- Keyboard navigation
- Semantic HTML
- Sufficient color contrast

**Test with:**
- Screen reader (macOS VoiceOver: `Cmd+F5`)
- Keyboard-only navigation (Tab key)
- Browser accessibility inspector

---

## Maintenance Schedule

### Weekly
- [ ] Check site loads correctly
- [ ] Test all links
- [ ] Review contact form submissions (if added)

### Monthly
- [ ] Check Google Analytics (if installed)
- [ ] Review DNS/hosting status
- [ ] Test mobile responsiveness
- [ ] Check SSL certificate validity

### Quarterly
- [ ] Update content as needed
- [ ] Review and update meta tags
- [ ] Performance audit (Google PageSpeed)
- [ ] Accessibility audit

### Annually
- [ ] Review branding consistency
- [ ] Update legal notices (copyright year)
- [ ] Comprehensive redesign review

---

## Getting Help

### Resources

**HTML/CSS Reference:**
- MDN Web Docs: https://developer.mozilla.org/
- W3Schools: https://www.w3schools.com/

**GitHub Pages:**
- Official Docs: https://docs.github.com/en/pages

**Validators:**
- HTML: https://validator.w3.org/
- CSS: https://jigsaw.w3.org/css-validator/
- Accessibility: https://wave.webaim.org/

### Who to Contact

**For technical issues:**
- Check GitHub Issues in repository
- Contact web developer/maintainer

**For content updates:**
- Content team at Maiden Crown Press
- Editorial lead

**For domain/hosting:**
- Domain registrar support
- GitHub Support (for Pages issues)

---

## Quick Reference Commands

```bash
# Clone repository
git clone https://github.com/your-username/pykesys-maiden-crown-web.git

# Navigate to static site
cd pykesys-maiden-crown-web/static

# Test locally
python3 -m http.server 8000

# Check status
git status

# Stage changes
git add .

# Commit changes
git commit -m "Description of changes"

# Push to GitHub
git push origin main

# View commit history
git log --oneline

# Revert to previous version
git checkout <commit-hash> -- index.html
```

---

**For more advanced administration, consider migrating to the dynamic platform (see Guide-Admin-Dynamic.md).**

*The static site endures. Simple, fast, accessible.*
