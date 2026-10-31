# Maiden Crown Press

**Official website and ecommerce platform for Maiden Crown Press — An independent creative publishing house.**

🌐 **Live Site:** [maidencrownpress.com](https://maidencrownpress.com)

---

## Table of Contents

- [About](#about)
- [Project Structure](#project-structure)
- [Technology Stack](#technology-stack)
- [Quick Start](#quick-start)
  - [Static Site (Marketing)](#static-site-marketing)
  - [Dynamic Site (Ecommerce)](#dynamic-site-ecommerce)
  - [Docker Development Environment](#docker-development-environment-recommended)
- [Container Manager](#container-manager)
- [Features](#features)
- [Development Workflow](#development-workflow)
- [API Documentation](#api-documentation)
- [Deployment](#deployment)
- [Design System](#design-system)
- [Documentation](#documentation)
- [Architecture Note](#architecture-note)
- [Legal](#legal)
- [Contact](#contact)

---

## About

Maiden Crown Press develops worlds of myth, memory, and speculative fiction. Our founding saga, *The Weight of Thirty Worlds*, is a six-book science-fiction epic exploring themes of power, memory, and the consequences of authority across thirty worlds.

**Tagline:** *Some stories are remembered. Others are forged.*

[↑ Back to top](#maiden-crown-press)

---

## Project Structure

This repository contains two versions of the Maiden Crown Press website:

```
pykesys-maiden-crown-web/
├── run-mcpd.sh          # Container manager for Dynamic site (MaidenCrownPressDynamic)
├── run-mcpd.md          # Container manager documentation
├── log/                 # Runner logs (gitignored)
│
├── static/              # Static marketing site (GitHub Pages)
│   ├── index.html      # Single-page site
│   ├── styles.css      # Styling
│   ├── script.js       # Interactive elements
│   └── CNAME           # Custom domain config
│
├── dynamic/            # Django ecommerce platform (MaidenCrownPressDynamic)
│   ├── Dockerfile.dev              # Development container
│   ├── docker-compose.dev.yml      # Multi-container orchestration
│   ├── .dockerignore               # Docker build optimization
│   ├── DOCKER_QUICKSTART.md        # 5-minute Docker setup
│   │
│   ├── apps/           # Django applications
│   │   ├── products/   # Product catalog & variants
│   │   ├── orders/     # Order management & checkout
│   │   ├── users/      # User accounts & profiles (✅ implemented)
│   │   ├── content_api/         # Content delivery API
│   │   └── digital_delivery/    # Digital product delivery
│   │
│   ├── maiden_crown_store/      # Django project settings
│   ├── requirements/   # Python dependencies
│   ├── README.md       # Django platform overview
│   └── GETTING_STARTED.md       # Manual setup guide
│
└── docs/               # Documentation
    ├── project-static.md        # Static site analysis
    ├── project-dynamic.md       # Django platform architecture
    ├── Guide-Admin-Static.md    # Static site admin guide
    └── Guide-Admin-Dynamic.md   # Django admin guide
```

[↑ Back to top](#maiden-crown-press)

---

## Technology Stack

### Static Site (`./static/`)
- **Pure HTML/CSS/JavaScript** — No build tools required
- **GitHub Pages** hosting
- **Zero dependencies** (except Google Fonts CDN)
- Fast, accessible, WCAG compliant

**Purpose:** Marketing site, landing page, public face

**Note:** GitHub Pages auto-deploys from the `static/` directory on push to `main` branch. A separate container manager (run-mcps.sh for MaidenCrownPressStatic) is generally not needed since GitHub Pages handles the build/deployment automatically.

### Dynamic Platform (`./dynamic/`)
- **Django 5.x** with PostgreSQL
- **Django REST Framework** for API
- **Stripe** for payments
- **Celery + Redis** for async tasks
- **AWS S3** for digital product delivery
- **Docker** development environment with hot-reload

**Purpose:** Full ecommerce store, user accounts, digital delivery, content API

[↑ Back to top](#maiden-crown-press)

---

## Quick Start

### Static Site (Marketing)

```bash
cd static
python3 -m http.server 8000
open http://localhost:8000
```

**Admin Guide:** See [`docs/Guide-Admin-Static.md`](docs/Guide-Admin-Static.md)

[↑ Back to top](#maiden-crown-press)

---

### Dynamic Site (Ecommerce)

#### Option A: Manual Setup (Traditional)

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

[↑ Back to top](#maiden-crown-press)

---

### Docker Development Environment (Recommended)

**One-command setup** using the `run-mcpd.sh` container manager:

```bash
# Quick setup (from project root)
./run-mcpd.sh setup && \
  cd dynamic && cp .env.example .env && cd .. && \
  ./run-mcpd.sh build && \
  ./run-mcpd.sh up && \
  sleep 10 && \
  ./run-mcpd.sh migrate && \
  ./run-mcpd.sh createsuperuser && \
  ./run-mcpd.sh browser
```

**What this does:**
1. ✅ Checks Docker is installed
2. ✅ Configures environment
3. ✅ Builds containers (Django + PostgreSQL + Redis)
4. ✅ Starts all services
5. ✅ Runs database migrations
6. ✅ Creates admin user
7. ✅ Opens http://127.0.0.1:8000/ in browser

**Quick reference:** See [`dynamic/DOCKER_QUICKSTART.md`](dynamic/DOCKER_QUICKSTART.md)

**Full documentation:** See [`run-mcpd.md`](run-mcpd.md)

[↑ Back to top](#maiden-crown-press)

---

## Container Manager

### run-mcpd.sh

**MCPD** = **M**aiden**C**rown**P**ress**D**ynamic

A comprehensive development environment manager for the Django platform, providing:

- 🐳 **Multi-container orchestration** (Django, PostgreSQL, Redis)
- 🔄 **Hot-reload** development (code changes apply instantly)
- 🎨 **Interactive menu** or direct commands
- 📊 **27+ commands** for container, Django, testing, and data management
- 🐛 **Debug mode** with detailed logging
- 🧪 **Testing tools** (pytest, coverage, linting)

**Common commands:**

```bash
# Container management
./run-mcpd.sh up              # Start all services
./run-mcpd.sh down            # Stop all services
./run-mcpd.sh status          # Check container status
./run-mcpd.sh connect         # Shell into web container
./run-mcpd.sh clean           # Full reset

# Django commands
./run-mcpd.sh migrate         # Run migrations
./run-mcpd.sh makemigrations  # Create migrations
./run-mcpd.sh createsuperuser # Create admin user
./run-mcpd.sh shell           # Django Python shell
./run-mcpd.sh dbshell         # PostgreSQL shell

# Application
./run-mcpd.sh logs:web        # Follow Django logs
./run-mcpd.sh browser         # Open in browser
./run-mcpd.sh admin           # Open admin panel
./run-mcpd.sh docs            # Open API docs

# Testing
./run-mcpd.sh test            # Run test suite
./run-mcpd.sh coverage        # Coverage report
./run-mcpd.sh lint            # Code quality checks
./run-mcpd.sh format          # Auto-format code

# Interactive menu
./run-mcpd.sh                 # No arguments = menu
```

**Full command list:** Run `./run-mcpd.sh help` or see [`run-mcpd.md`](run-mcpd.md)

**Note:** A similar manager for the static site (run-mcps.sh) is generally not needed since GitHub Pages handles static site deployment automatically. However, one could be created if local development workflows require it.

[↑ Back to top](#maiden-crown-press)

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
- 👤 User accounts & profiles (✅ fully implemented)
- 📦 Pre-orders & coming soon products
- 💳 Stripe payment integration (planned)
- 📧 Automated digital delivery (planned)
- 🔌 REST API for content delivery
- 📊 Admin dashboard for content management
- 🐳 Dockerized development environment
- 🔥 Hot-reload for instant code changes
- 🧪 Complete testing infrastructure

**Implementation Status:**
- ✅ Users App: 100% complete
- ⚠️ Products App: 10% (models scaffolded)
- ⚠️ Orders App: 5% (scaffolded)
- ⚠️ Content API: 5% (scaffolded)
- ⚠️ Digital Delivery: 5% (scaffolded)

**Next Steps:** See [`docs/project-dynamic.md`](docs/project-dynamic.md#next-steps-to-flesh-out-the-app)

[↑ Back to top](#maiden-crown-press)

---

## Development Workflow

### Static Site Changes

1. Edit files in `./static/`
2. Test locally: `python3 -m http.server 8000` (in `static/` directory)
3. Commit and push to `main` (auto-deploys to GitHub Pages)

**Admin Guide:** See [`docs/Guide-Admin-Static.md`](docs/Guide-Admin-Static.md)

[↑ Back to top](#maiden-crown-press)

---

### Dynamic Site Changes (Docker)

**Recommended workflow:**

```bash
# Start containers
./run-mcpd.sh up

# In another terminal, watch logs
./run-mcpd.sh logs:web

# Edit code in dynamic/apps/...
# Changes apply automatically (hot-reload)

# After model changes
./run-mcpd.sh makemigrations
./run-mcpd.sh migrate

# Before committing
./run-mcpd.sh test
./run-mcpd.sh lint
./run-mcpd.sh format

# Stop when done
./run-mcpd.sh down
```

**Admin Guide:** See [`docs/Guide-Admin-Dynamic.md`](docs/Guide-Admin-Dynamic.md)

[↑ Back to top](#maiden-crown-press)

---

### Dynamic Site Changes (Manual)

1. Activate virtual environment: `source dynamic/venv/bin/activate`
2. Make changes to Django apps
3. Create migrations: `python manage.py makemigrations`
4. Run migrations: `python manage.py migrate`
5. Test: `pytest` or `python manage.py test`
6. Commit changes

[↑ Back to top](#maiden-crown-press)

---

## API Documentation

Once the dynamic site is running:

- **Swagger UI:** http://localhost:8000/api/docs/
- **API Schema:** http://localhost:8000/api/schema/

### Sample Endpoints

```
# Products API
GET  /api/v1/products/              # List products
GET  /api/v1/products/{id}/         # Product detail
GET  /api/v1/products/{id}/variants/ # Product variants

# Content API
GET  /api/v1/content/worlds/        # List worlds
GET  /api/v1/content/chronicles/    # List chronicles
GET  /api/v1/content/characters/    # List characters

# Orders API (authenticated)
POST /api/v1/orders/                # Create order
GET  /api/v1/orders/                # User's orders
GET  /api/v1/orders/{id}/           # Order detail

# Users API (authenticated)
GET  /api/v1/users/profile/         # User profile
PUT  /api/v1/users/profile/         # Update profile
GET  /api/v1/users/orders/          # Order history
```

**Quick access:** Run `./run-mcpd.sh docs` to open Swagger UI in browser

[↑ Back to top](#maiden-crown-press)

---

## Deployment

### Static Site

- **Platform:** GitHub Pages
- **Domain:** maidencrownpress.com (via CNAME)
- **Auto-deploy:** On push to `main` branch
- **Configuration:** See [`docs/Guide-Admin-Static.md`](docs/Guide-Admin-Static.md)

**DNS Configuration:**

**A Records (GitHub Pages):**
```
185.199.108.153
185.199.109.153
185.199.110.153
185.199.111.153
```

**CNAME (optional www):**
```
www → <your-github-username>.github.io
```

[↑ Back to top](#maiden-crown-press)

---

### Dynamic Platform

**Recommended platforms:**

| Platform | Best For | Difficulty |
|:---|:---|:---|
| **Heroku** | Easiest setup | ⭐ Easy |
| **Railway** | Modern, simple | ⭐⭐ Easy |
| **DigitalOcean App Platform** | Balanced | ⭐⭐ Medium |
| **AWS Elastic Beanstalk** | Scalability | ⭐⭐⭐ Medium |
| **Self-hosted (VPS)** | Full control | ⭐⭐⭐⭐ Hard |

**Deployment Guide:** See [`dynamic/README.md`](dynamic/README.md#deployment)

**Production Checklist:**
- [ ] Set `DEBUG=False`
- [ ] Configure production database
- [ ] Set up AWS S3 for media files
- [ ] Configure Stripe production keys
- [ ] Set up SSL certificate
- [ ] Configure email service (SendGrid)
- [ ] Set up Redis for Celery
- [ ] Configure static file serving (CDN)
- [ ] Set up monitoring (Sentry)
- [ ] Configure backup strategy

[↑ Back to top](#maiden-crown-press)

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

**Design Preservation:**

The dynamic platform should preserve the static site's branding:
- Same color palette
- Same typography
- Crown sigil integration
- Accessibility standards (WCAG)

[↑ Back to top](#maiden-crown-press)

---

## Documentation

### Overview
- [`README.md`](README.md) — This file (project overview)

### Static Site
- [`docs/project-static.md`](docs/project-static.md) — Static site analysis & migration notes
- [`docs/Guide-Admin-Static.md`](docs/Guide-Admin-Static.md) — Static site administration guide

### Dynamic Platform
- [`dynamic/README.md`](dynamic/README.md) — Django platform overview
- [`dynamic/GETTING_STARTED.md`](dynamic/GETTING_STARTED.md) — Manual setup guide
- [`dynamic/DOCKER_QUICKSTART.md`](dynamic/DOCKER_QUICKSTART.md) — 5-minute Docker setup
- [`docs/project-dynamic.md`](docs/project-dynamic.md) — Complete architecture & roadmap
- [`docs/Guide-Admin-Dynamic.md`](docs/Guide-Admin-Dynamic.md) — Django admin panel guide

### Container Manager (run-mcpd.sh)
- [`run-mcpd.md`](run-mcpd.md) — Complete container manager documentation
  - All 27 commands explained
  - Interactive menu reference
  - Common workflows
  - Troubleshooting guide
  - Environment variables

### Quick References
| I want to... | See this document |
|:---|:---|
| Understand the project | This README |
| Set up Django with Docker | [`dynamic/DOCKER_QUICKSTART.md`](dynamic/DOCKER_QUICKSTART.md) |
| Set up Django manually | [`dynamic/GETTING_STARTED.md`](dynamic/GETTING_STARTED.md) |
| Understand architecture | [`docs/project-dynamic.md`](docs/project-dynamic.md) |
| Use run-mcpd.sh | [`run-mcpd.md`](run-mcpd.md) |
| Manage static site | [`docs/Guide-Admin-Static.md`](docs/Guide-Admin-Static.md) |
| Use Django admin | [`docs/Guide-Admin-Dynamic.md`](docs/Guide-Admin-Dynamic.md) |
| Build new features | [`docs/project-dynamic.md`](docs/project-dynamic.md#next-steps-to-flesh-out-the-app) |

[↑ Back to top](#maiden-crown-press)

---

## Architecture Note

This platform is the public **Market** distribution channel for Maiden Crown Press. It displays Foundry-approved content. The backend content management system (Auger → Forge → Foundry → Market) is maintained in a separate private repository.

**Content Workflow:**
```
Auger → Forge → Foundry → Market (this repo)
```

The `content_api` Django app serves as the public-facing **Market** interface, delivering approved content via REST API.

[↑ Back to top](#maiden-crown-press)

---

## Legal

© 2026 Maiden Crown Press. All rights reserved.

Fictional works in development. No trademark registration status is claimed.

[↑ Back to top](#maiden-crown-press)

---

## Contact

**Email:** [contact@maidencrownpress.com](mailto:contact@maidencrownpress.com?subject=Maiden%20Crown%20Press%20Inquiry)

**Website:** [maidencrownpress.com](https://maidencrownpress.com)

[↑ Back to top](#maiden-crown-press)

---

## Contributing

### For Developers

**First-time setup:**
```bash
# Clone repository
git clone <repo-url>
cd pykesys-maiden-crown-web

# Start Docker environment
./run-mcpd.sh setup
./run-mcpd.sh build
./run-mcpd.sh up
./run-mcpd.sh migrate
./run-mcpd.sh createsuperuser
```

**Development workflow:**
```bash
# Start working
./run-mcpd.sh up

# Make changes (auto-reload)
# Edit files in dynamic/apps/...

# Test changes
./run-mcpd.sh test
./run-mcpd.sh lint

# Format code
./run-mcpd.sh format

# Commit
git add .
git commit -m "Your changes"
git push
```

**Code quality standards:**
- All code must pass `./run-mcpd.sh lint`
- Auto-format with `./run-mcpd.sh format` before committing
- Maintain test coverage above 80%
- Follow Django best practices
- Preserve accessibility standards

### For Content Managers

See administrator guides:
- Static site: [`docs/Guide-Admin-Static.md`](docs/Guide-Admin-Static.md)
- Dynamic platform: [`docs/Guide-Admin-Dynamic.md`](docs/Guide-Admin-Dynamic.md)

[↑ Back to top](#maiden-crown-press)

---

## Version History

- **v1.0** (2026-10-30) — Initial scaffold with Docker development environment
  - Static marketing site (GitHub Pages)
  - Django ecommerce platform scaffold
  - Users app fully implemented
  - Docker development environment with `run-mcpd.sh`
  - Comprehensive documentation

**Current Status:** ~25% complete (scaffolding phase)

**Next Milestone:** Products & Orders apps implementation

[↑ Back to top](#maiden-crown-press)

---

*The record endures. The story begins.*

**👑 Built with Django, PostgreSQL, and purpose.**
