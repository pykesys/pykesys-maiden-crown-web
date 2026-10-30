# Maiden Crown Press

**Official website and ecommerce platform for Maiden Crown Press — An independent creative publishing house.**

🌐 **Live Site:** [maidencrownpress.com](https://maidencrownpress.com)

---

## About

Maiden Crown Press develops worlds of myth, memory, and speculative fiction. Our founding saga, *The Weight of Thirty Worlds*, is a six-book science-fiction epic exploring themes of power, memory, and the consequences of authority across thirty worlds.

**Tagline:** *Some stories are remembered. Others are forged.*

---

## Project Structure

This repository contains two versions of the Maiden Crown Press website:

```
pykesys-maiden-crown-web/
├── static/              # Static marketing site (GitHub Pages)
│   ├── index.html      # Single-page site
│   ├── styles.css      # Styling
│   ├── script.js       # Interactive elements
│   └── CNAME           # Custom domain config
│
├── dynamic/            # Django ecommerce platform
│   ├── apps/           # Django applications
│   │   ├── products/   # Product catalog & variants
│   │   ├── orders/     # Order management
│   │   ├── users/      # User accounts
│   │   ├── content_api/    # Content delivery API
│   │   └── digital_delivery/   # Digital product delivery
│   ├── maiden_crown_store/    # Django project settings
│   ├── requirements/   # Python dependencies
│   └── README.md       # Django setup guide
│
└── docs/               # Documentation
    └── project-static.md   # Static site analysis
```

---

## Technology Stack

### Static Site (`./static/`)
- **Pure HTML/CSS/JavaScript** — No build tools required
- **GitHub Pages** hosting
- **Zero dependencies** (except Google Fonts CDN)
- Fast, accessible, WCAG compliant

**Purpose:** Marketing site, landing page, public face

### Dynamic Platform (`./dynamic/`)
- **Django 5.x** with PostgreSQL
- **Django REST Framework** for API
- **Stripe** for payments
- **Celery + Redis** for async tasks
- **AWS S3** for digital product delivery

**Purpose:** Full ecommerce store, user accounts, digital delivery, content API

---

## Quick Start

### Static Site (Marketing)
```bash
cd static
python3 -m http.server 8000
open http://localhost:8000
```

### Dynamic Site (Ecommerce)
```bash
cd dynamic
python3 -m venv venv
source venv/bin/activate
pip install -r requirements/development.txt

# Set up database (see dynamic/GETTING_STARTED.md)
cp .env.example .env
python manage.py migrate
python manage.py createsuperuser
python manage.py runserver
```

**Detailed setup:** See [`dynamic/GETTING_STARTED.md`](dynamic/GETTING_STARTED.md)

---

## Features

### Static Site
- ✨ Animated starfield background
- 👑 Custom crown sigil (SVG)
- 🎨 Royal color palette (deep purple, gold)
- 📱 Fully responsive design
- ♿ WCAG accessibility compliance

### Dynamic Platform
- 🛍️ Product catalog with variants (hardcover, paperback, ebook, audiobook)
- 👤 User accounts & profiles
- 📦 Pre-orders & coming soon products
- 💳 Stripe payment integration
- 📧 Automated digital delivery
- 🔌 REST API for content delivery
- 📊 Admin dashboard for content management

---

## Content Sections (Static Site)

1. **Hero** — "An Archive of Worlds Unforgotten"
2. **The Chronicles** — Introduction to the Maiden Crown saga
3. **The Worlds** — Overview of the thirty worlds
4. **The House** — About Maiden Crown Press
5. **Contact** — Email inquiries

---

## Deployment

### Static Site
- **Platform:** GitHub Pages
- **Domain:** maidencrownpress.com (via CNAME)
- **Auto-deploy:** On push to `main` branch

### Dynamic Platform
**Recommended platforms:**
- Heroku (easiest)
- Railway (modern, simple)
- AWS Elastic Beanstalk (scalable)
- DigitalOcean App Platform (balanced)

See [`dynamic/README.md`](dynamic/README.md) for deployment guide.

---

## API Documentation

Once the dynamic site is running:
- **Swagger UI:** http://localhost:8000/api/docs/
- **API Schema:** http://localhost:8000/api/schema/

### Sample Endpoints
```
GET  /api/v1/products/              # List products
GET  /api/v1/products/{id}/         # Product detail
GET  /api/v1/content/worlds/        # Content API
POST /api/v1/orders/                # Create order
GET  /api/v1/users/profile/         # User profile
```

---

## Architecture Note

This platform is the public **Market** distribution channel for Maiden Crown Press. It displays Foundry-approved content. The backend content management system (Auger → Forge → Foundry → Market) is maintained in a separate private repository.

---

## Design System

**Color Palette:**
- Deep Purple (Ink): `#100d13`
- Gold: `#d5b77b`
- Pale: `#f3e5c9`
- Dim: `#b4a48d`
- Red: `#632537`

**Typography:**
- **Cinzel** (serif) — Headlines and branding
- **Cormorant Garamond** (serif) — Italic emphasis
- **Inter** (sans-serif) — Body text

**Brand Assets:**
- Crown sigil (SVG) — Located in `static/index.html`

---

## Documentation

- [`docs/project-static.md`](docs/project-static.md) — Static site analysis
- [`dynamic/README.md`](dynamic/README.md) — Django platform overview
- [`dynamic/GETTING_STARTED.md`](dynamic/GETTING_STARTED.md) — Setup guide

---

## Development Workflow

### Static Site Changes
1. Edit files in `./static/`
2. Test locally: `python3 -m http.server 8000`
3. Commit and push to `main` (auto-deploys to GitHub Pages)

### Dynamic Site Changes
1. Activate virtual environment: `source dynamic/venv/bin/activate`
2. Make changes to Django apps
3. Create migrations: `python manage.py makemigrations`
4. Run migrations: `python manage.py migrate`
5. Test: `pytest` or `python manage.py test`
6. Commit changes

---

## Legal

© 2026 Maiden Crown Press. All rights reserved.

Fictional works in development. No trademark registration status is claimed.

---

## Contact

**Email:** [contact@maidencrownpress.com](mailto:contact@maidencrownpress.com?subject=Maiden%20Crown%20Press%20Inquiry)

**Website:** [maidencrownpress.com](https://maidencrownpress.com)

---

*The record endures. The story begins.*
