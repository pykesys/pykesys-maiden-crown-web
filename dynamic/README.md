# Maiden Crown Press — Dynamic Ecommerce Platform

**Framework:** Django 5.x + PostgreSQL + Django REST Framework
**Purpose:** Full-featured ecommerce store with digital delivery and content API

---

## Tech Stack

- **Backend:** Django 5.x with PostgreSQL
- **API:** Django REST Framework
- **Payments:** Stripe
- **Task Queue:** Celery + Redis
- **Storage:** AWS S3 (for digital products)
- **Email:** SendGrid / AWS SES
- **Auth:** Django Allauth + JWT for API

---

## Features

### Ecommerce
- ✅ Product catalog with variants (hardcover, paperback, ebook, audiobook)
- ✅ User accounts & order history
- ✅ Pre-orders & coming soon products
- ✅ Digital delivery (automated ebook/PDF delivery)
- ✅ Shopping cart & checkout
- ✅ Stripe payment integration
- ✅ Order management & tracking

### Content Management
- ✅ REST API for content delivery
- ✅ Admin dashboard for content management
- ✅ Auger → Forge → Foundry → Market workflow support

---

## Project Structure

```
dynamic/
├── maiden_crown_store/          # Main Django project
│   ├── settings/
│   │   ├── base.py             # Base settings
│   │   ├── development.py      # Dev environment
│   │   └── production.py       # Production settings
│   ├── urls.py                 # Root URL configuration
│   ├── wsgi.py                 # WSGI config
│   └── asgi.py                 # ASGI config
│
├── apps/
│   ├── products/               # Product catalog & variants
│   ├── orders/                 # Order management
│   ├── users/                  # User accounts & profiles
│   ├── content_api/            # Content delivery API
│   └── digital_delivery/       # Automated digital product delivery
│
├── static/                     # Static assets (CSS, JS, images)
├── media/                      # User-uploaded files
├── templates/                  # HTML templates
│
├── requirements/
│   ├── base.txt               # Core dependencies
│   ├── development.txt        # Dev dependencies
│   └── production.txt         # Production dependencies
│
├── manage.py                  # Django management script
├── .env.example               # Environment variables template
└── README.md                  # This file
```

---

## Quick Start

### 1. Set up virtual environment
```bash
cd dynamic
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

### 2. Install dependencies
```bash
pip install -r requirements/development.txt
```

### 3. Configure environment
```bash
cp .env.example .env
# Edit .env with your database credentials, Stripe keys, etc.
```

### 4. Set up database
```bash
# Create PostgreSQL database
createdb maiden_crown_db

# Run migrations
python manage.py migrate

# Create superuser
python manage.py createsuperuser
```

### 5. Load initial data
```bash
python manage.py loaddata initial_data
```

### 6. Run development server
```bash
python manage.py runserver
```

Visit: http://localhost:8000

---

## Apps Overview

### `products`
- Product models (Book, Merchandise, etc.)
- Product variants (format, edition)
- Categories and tags
- Inventory management
- Pre-order functionality

### `orders`
- Shopping cart
- Checkout process
- Order management
- Payment processing (Stripe)
- Order status tracking

### `users`
- Custom user model
- User profiles
- Order history
- Wishlist
- Email preferences

### `content_api`
- RESTful API endpoints
- Content delivery
- Auger/Forge/Foundry integration
- Versioning and publishing workflow

### `digital_delivery`
- Digital product storage (S3)
- Automated delivery emails
- Download link generation
- Access control
- Delivery tracking

---

## API Endpoints

### Content API
```
GET  /api/v1/content/worlds/           # List all worlds
GET  /api/v1/content/worlds/{id}/      # World detail
GET  /api/v1/content/chronicles/       # List chronicles
GET  /api/v1/content/characters/       # List characters
```

### Products API
```
GET  /api/v1/products/                 # List products
GET  /api/v1/products/{id}/            # Product detail
GET  /api/v1/products/{id}/variants/   # Product variants
```

### Orders API (Authenticated)
```
GET  /api/v1/orders/                   # User's orders
POST /api/v1/orders/                   # Create order
GET  /api/v1/orders/{id}/              # Order detail
```

---

## Environment Variables

Required environment variables (see `.env.example`):

```bash
# Django
SECRET_KEY=your-secret-key
DEBUG=True
ALLOWED_HOSTS=localhost,127.0.0.1

# Database
DB_NAME=maiden_crown_db
DB_USER=postgres
DB_PASSWORD=your-password
DB_HOST=localhost
DB_PORT=5432

# Stripe
STRIPE_PUBLIC_KEY=pk_test_...
STRIPE_SECRET_KEY=sk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...

# AWS S3
AWS_ACCESS_KEY_ID=your-access-key
AWS_SECRET_ACCESS_KEY=your-secret-key
AWS_STORAGE_BUCKET_NAME=maiden-crown-digital

# Email
EMAIL_BACKEND=django.core.mail.backends.smtp.EmailBackend
EMAIL_HOST=smtp.sendgrid.net
EMAIL_PORT=587
EMAIL_USE_TLS=True
EMAIL_HOST_USER=apikey
EMAIL_HOST_PASSWORD=your-sendgrid-api-key

# Redis (for Celery)
REDIS_URL=redis://localhost:6379/0
```

---

## Development Workflow

### Run tests
```bash
python manage.py test
```

### Create migrations
```bash
python manage.py makemigrations
python manage.py migrate
```

### Run Celery (for async tasks)
```bash
celery -A maiden_crown_store worker -l info
```

### Access admin panel
http://localhost:8000/admin

---

## Deployment

### Production checklist
- [ ] Set `DEBUG=False`
- [ ] Configure production database
- [ ] Set up S3 for media files
- [ ] Configure Stripe production keys
- [ ] Set up SSL certificate
- [ ] Configure email service
- [ ] Set up Redis for Celery
- [ ] Configure static file serving (CDN)
- [ ] Set up monitoring (Sentry)
- [ ] Configure backup strategy

### Deployment platforms
- **Heroku** (easiest)
- **Railway** (modern, simple)
- **AWS Elastic Beanstalk** (scalable)
- **DigitalOcean App Platform** (balanced)
- **Self-hosted** (VPS with Docker)

---

## Design Integration

The dynamic site will preserve the branding from the static site:

- **Color Palette:** Deep purple (#100d13), Gold (#d5b77b)
- **Typography:** Cinzel, Cormorant Garamond, Inter
- **Crown Sigil:** SVG asset from static site
- **Accessibility:** WCAG compliance maintained

---

## Next Steps

1. Install dependencies and set up database
2. Run initial migrations
3. Create product models and admin interface
4. Implement Stripe checkout
5. Build content API
6. Set up digital delivery system
7. Create frontend templates (or integrate with React/Vue)

---

*Built for Maiden Crown Press — Stories endure. Records remain.*
