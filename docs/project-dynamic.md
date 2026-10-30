# Maiden Crown Press — Dynamic Platform Documentation

**Date:** 2026-10-30
**Version:** Django Platform v1.0 (Initial Scaffold)
**Status:** Development / Scaffold Phase

---

## Overview

This is a comprehensive Django-based ecommerce platform for Maiden Crown Press, designed to support book sales with multiple formats, digital delivery, user accounts, and a content management API.

**Purpose:** Replace static marketing site with full-featured ecommerce store
**Framework:** Django 5.x with Django REST Framework
**Database:** PostgreSQL
**Deployment:** Platform-agnostic (Heroku, Railway, AWS, DigitalOcean)

---

## Architecture

### Technology Stack

**Backend Framework:**
- Django 5.x
- Python 3.11+
- PostgreSQL 14+

**API Layer:**
- Django REST Framework (DRF) 3.14+
- JWT Authentication (djangorestframework-simplejwt)
- drf-spectacular (OpenAPI/Swagger documentation)

**Payment Processing:**
- Stripe API 7.8+
- Webhook support for order fulfillment

**Async Tasks:**
- Celery 5.3+ (task queue)
- Redis 5.0+ (message broker)
- django-celery-beat (scheduled tasks)

**Storage:**
- AWS S3 via boto3 (digital products)
- django-storages (S3 integration)

**Email:**
- SendGrid (transactional emails)
- Order confirmations, digital delivery, password resets

**Security:**
- django-allauth (authentication)
- django-csp (Content Security Policy)
- django-ratelimit (API rate limiting)
- CORS headers for frontend integration

---

## Project Structure

```
dynamic/
├── maiden_crown_store/              # Django project (settings, config)
│   ├── settings/
│   │   ├── __init__.py
│   │   ├── base.py                  # Shared settings
│   │   ├── development.py           # Dev overrides
│   │   └── production.py            # Production settings
│   ├── __init__.py                  # Celery app import
│   ├── celery.py                    # Celery configuration
│   ├── urls.py                      # Root URL routing
│   ├── wsgi.py                      # WSGI entry point
│   └── asgi.py                      # ASGI entry point (future WebSockets)
│
├── apps/                            # Django applications
│   ├── users/                       # ✅ FULLY IMPLEMENTED
│   │   ├── models.py                # User, UserProfile
│   │   ├── admin.py                 # Admin interface
│   │   ├── serializers.py           # DRF serializers
│   │   ├── views.py                 # API views
│   │   ├── urls.py                  # URL routing
│   │   ├── signals.py               # Auto-create profiles
│   │   └── apps.py                  # App configuration
│   │
│   ├── products/                    # ⚠️ SCAFFOLD ONLY (needs models)
│   │   ├── models.py                # TODO: Product, Variant, Category, BookMetadata
│   │   ├── admin.py                 # TODO: Admin interface
│   │   ├── serializers.py           # TODO: DRF serializers
│   │   ├── views.py                 # TODO: API views
│   │   └── urls.py                  # TODO: URL routing
│   │
│   ├── orders/                      # ⚠️ SCAFFOLD ONLY
│   │   ├── models.py                # TODO: Order, OrderItem, Cart
│   │   ├── admin.py                 # TODO: Admin interface
│   │   ├── serializers.py           # TODO: DRF serializers
│   │   ├── views.py                 # TODO: Checkout, order management
│   │   └── urls.py                  # TODO: URL routing
│   │
│   ├── content_api/                 # ⚠️ SCAFFOLD ONLY
│   │   ├── models.py                # TODO: World, Chronicle, Character
│   │   ├── admin.py                 # TODO: Admin interface
│   │   ├── serializers.py           # TODO: DRF serializers
│   │   ├── views.py                 # TODO: API views
│   │   └── urls.py                  # TODO: URL routing
│   │
│   └── digital_delivery/            # ⚠️ SCAFFOLD ONLY
│       ├── models.py                # TODO: DigitalProduct, Download
│       ├── admin.py                 # TODO: Admin interface
│       ├── tasks.py                 # TODO: Celery tasks for delivery
│       ├── views.py                 # TODO: Secure download links
│       └── urls.py                  # TODO: URL routing
│
├── templates/                       # HTML templates (Django or frontend)
├── static/                          # Static assets (CSS, JS, images)
├── media/                           # User uploads (product images)
│
├── requirements/                    # Python dependencies
│   ├── base.txt                     # Core dependencies
│   ├── development.txt              # Dev tools (pytest, debug toolbar)
│   └── production.txt               # Production (gunicorn, sentry)
│
├── manage.py                        # Django CLI
├── .env.example                     # Environment variables template
├── .gitignore                       # Git exclusions
├── README.md                        # Platform overview
└── GETTING_STARTED.md               # Setup instructions
```

---

## Apps Overview

### ✅ `users` — **FULLY IMPLEMENTED**

**Purpose:** User authentication, profiles, and account management

**Models:**
- `User` (custom user model, email-based authentication)
  - Email (unique, used for login)
  - Newsletter subscription preference
  - Created/updated timestamps

- `UserProfile` (one-to-one with User)
  - Phone, birth date
  - Shipping address (line1, line2, city, state, postal, country)
  - Billing address (separate from shipping)

**Features:**
- ✅ Custom user model with email authentication
- ✅ Auto-created profiles via signals
- ✅ Admin interface with inline profile editing
- ✅ REST API endpoints:
  - `GET/PUT /api/v1/users/profile/` — User profile
  - `GET /api/v1/users/orders/` — User order history

**Files:**
- `models.py` — User and UserProfile models (62 lines)
- `admin.py` — Admin configuration with inline profile (23 lines)
- `serializers.py` — DRF serializers (18 lines)
- `views.py` — API views (27 lines)
- `signals.py` — Auto-create profile on user creation (20 lines)
- `apps.py` — App config with signal imports (9 lines)
- `urls.py` — URL routing (11 lines)

**Status:** ✅ Production-ready (needs testing)

---

### ⚠️ `products` — **SCAFFOLD ONLY**

**Purpose:** Product catalog, variants, and inventory management

**Planned Models:**

1. **`Category`**
   - Name, slug, description
   - Parent category (for nested categories)
   - Self-referential hierarchy support

2. **`Product`**
   - Name, slug, SKU
   - Product type (book, merchandise, bundle)
   - Short/full description
   - Base price
   - Status (draft, active, preorder, coming_soon, out_of_stock, discontinued)
   - Release date, preorder start date
   - Featured flag
   - Image, thumbnail
   - Category (FK)
   - Created/updated timestamps

3. **`ProductVariant`**
   - Product (FK)
   - Format type (hardcover, paperback, ebook, audiobook, signed, limited)
   - SKU (unique per variant)
   - Price, compare_at_price (for sales)
   - Inventory quantity (null for digital)
   - Is digital flag
   - Digital file (for ebooks/audiobooks)
   - ISBN, pages, weight
   - Active status

4. **`BookMetadata`** (one-to-one with Product)
   - Author, series, series number
   - Publisher (default: Maiden Crown Press)
   - Genre, target audience
   - Excerpt (sample chapter)

**Planned Features:**
- [ ] Product catalog with filtering/search
- [ ] Variant management (multiple formats per product)
- [ ] Inventory tracking (physical products)
- [ ] Pre-order support
- [ ] Digital product file storage (S3)
- [ ] Category hierarchy
- [ ] Featured products
- [ ] Sale pricing (compare_at_price)

**API Endpoints (Planned):**
```
GET    /api/v1/products/              # List products
POST   /api/v1/products/              # Create product (admin)
GET    /api/v1/products/{id}/         # Product detail
PUT    /api/v1/products/{id}/         # Update product (admin)
DELETE /api/v1/products/{id}/         # Delete product (admin)
GET    /api/v1/products/{id}/variants/  # List variants
```

**Status:** ⚠️ Scaffold only — models need implementation

---

### ⚠️ `orders` — **SCAFFOLD ONLY**

**Purpose:** Shopping cart, checkout, order management, payment processing

**Planned Models:**

1. **`Cart`**
   - User (FK, nullable for guest carts)
   - Session key (for guest users)
   - Created/updated timestamps

2. **`CartItem`**
   - Cart (FK)
   - Product variant (FK)
   - Quantity
   - Price snapshot (at time of add)

3. **`Order`**
   - User (FK, nullable for guest orders)
   - Order number (unique)
   - Status (pending, paid, processing, shipped, delivered, cancelled, refunded)
   - Subtotal, tax, shipping, total
   - Shipping address fields
   - Billing address fields
   - Payment method
   - Stripe payment intent ID
   - Tracking number
   - Notes
   - Created/updated timestamps

4. **`OrderItem`**
   - Order (FK)
   - Product variant (FK)
   - Quantity
   - Price (snapshot at purchase)
   - Product name, variant name (for historical record)

**Planned Features:**
- [ ] Shopping cart (session-based + user-based)
- [ ] Checkout flow
- [ ] Stripe payment integration
- [ ] Order confirmation emails
- [ ] Order status tracking
- [ ] Admin order management
- [ ] Refund handling
- [ ] Tax calculation
- [ ] Shipping calculation
- [ ] Guest checkout support

**API Endpoints (Planned):**
```
GET    /api/v1/orders/cart/           # Current cart
POST   /api/v1/orders/cart/add/       # Add to cart
DELETE /api/v1/orders/cart/remove/    # Remove from cart
POST   /api/v1/orders/checkout/       # Initiate checkout
GET    /api/v1/orders/                # List user orders
GET    /api/v1/orders/{id}/           # Order detail
```

**Stripe Integration Points:**
- Payment intents for checkout
- Webhook handling for payment confirmation
- Refund processing
- Subscription support (future)

**Status:** ⚠️ Scaffold only — critical for ecommerce functionality

---

### ⚠️ `content_api` — **SCAFFOLD ONLY**

**Purpose:** Content delivery API for worlds, chronicles, characters (Auger/Forge/Foundry integration)

**Planned Models:**

1. **`World`**
   - Name, slug
   - Description
   - Order (for sorting)
   - Is published
   - Metadata (JSON field for flexible data)
   - Created/updated timestamps

2. **`Chronicle`**
   - Title, slug
   - Content (rich text)
   - Excerpt
   - World (FK, nullable)
   - Order
   - Is published
   - Published date
   - Author
   - Metadata (JSON)

3. **`Character`**
   - Name, slug
   - Biography
   - World (FK)
   - Role (protagonist, antagonist, supporting, etc.)
   - Image
   - Is published
   - Metadata (JSON)

4. **`ContentVersion`** (optional, for Foundry workflow)
   - Content type (world, chronicle, character)
   - Object ID
   - Version number
   - Status (draft, review, approved, published)
   - Approved by (FK to User)
   - Published date

**Planned Features:**
- [ ] Auger → Forge → Foundry → Market workflow
- [ ] Version control for content
- [ ] Approval workflow
- [ ] Public API for website content
- [ ] Admin CMS interface
- [ ] Rich text editor integration
- [ ] Media library for images

**API Endpoints (Planned):**
```
GET /api/v1/content/worlds/           # List worlds
GET /api/v1/content/worlds/{slug}/    # World detail
GET /api/v1/content/chronicles/       # List chronicles
GET /api/v1/content/chronicles/{slug}/  # Chronicle detail
GET /api/v1/content/characters/       # List characters
```

**Status:** ⚠️ Scaffold only — important for content management

---

### ⚠️ `digital_delivery` — **SCAFFOLD ONLY**

**Purpose:** Automated digital product delivery after purchase

**Planned Models:**

1. **`DigitalProduct`**
   - Product variant (FK)
   - File (S3 storage)
   - File size
   - File type (PDF, EPUB, MOBI, MP3, etc.)
   - Download limit (per purchase)
   - Expiration days (download link validity)

2. **`Download`**
   - User (FK)
   - Order item (FK)
   - Digital product (FK)
   - Download token (UUID)
   - Download count
   - Expires at
   - IP address
   - Created/downloaded timestamps

**Planned Features:**
- [ ] S3 file storage
- [ ] Secure, expiring download links
- [ ] Download limit enforcement
- [ ] Email delivery of download links
- [ ] Download tracking
- [ ] Re-send download link functionality
- [ ] IP restriction (optional)
- [ ] Watermarking (future)

**Celery Tasks (Planned):**
- `send_digital_delivery_email` — Send download links after purchase
- `cleanup_expired_downloads` — Periodic cleanup of expired tokens
- `generate_download_link` — Create secure, signed URLs

**API Endpoints (Planned):**
```
GET /api/v1/digital/downloads/        # User's digital products
GET /api/v1/digital/download/{token}/  # Secure download
POST /api/v1/digital/resend/{id}/     # Resend download link
```

**Status:** ⚠️ Scaffold only — critical for ebook/audiobook sales

---

## Configuration

### Environment Variables

**Required Variables** (`.env.example`):

```bash
# Django Core
SECRET_KEY=                          # Generate with Django
DEBUG=True                           # False in production
ALLOWED_HOSTS=localhost,127.0.0.1   # Add domain in production

# Database
DB_NAME=maiden_crown_db
DB_USER=postgres
DB_PASSWORD=
DB_HOST=localhost
DB_PORT=5432

# Stripe
STRIPE_PUBLIC_KEY=pk_test_...
STRIPE_SECRET_KEY=sk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...

# AWS S3
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_STORAGE_BUCKET_NAME=
AWS_S3_REGION_NAME=us-east-1

# Email (SendGrid)
EMAIL_HOST=smtp.sendgrid.net
EMAIL_PORT=587
EMAIL_HOST_USER=apikey
EMAIL_HOST_PASSWORD=
DEFAULT_FROM_EMAIL=noreply@maidencrownpress.com

# Redis
REDIS_URL=redis://localhost:6379/0

# Site
SITE_URL=https://maidencrownpress.com
CONTACT_EMAIL=contact@maidencrownpress.com
```

### Settings Architecture

**`settings/base.py`** (162 lines)
- Shared settings for all environments
- Installed apps configuration
- Middleware stack
- Database configuration
- REST Framework settings
- Celery configuration
- Stripe/AWS integration

**`settings/development.py`** (42 lines)
- DEBUG=True
- Debug toolbar integration
- Console email backend
- Permissive CORS
- Enhanced logging

**`settings/production.py`** (62 lines)
- Security hardening (SSL, HSTS, CSP)
- Sentry error tracking
- Redis caching
- WhiteNoise static files
- Production email backend

---

## Dependencies

### Base Requirements (`requirements/base.txt`)

**Core:**
- Django 5.0+
- psycopg2-binary 2.9+ (PostgreSQL)
- python-decouple 3.8+ (environment management)
- Pillow 10.1+ (image processing)

**API:**
- djangorestframework 3.14+
- django-filter 23.5+
- drf-spectacular 0.27+ (API docs)

**Authentication:**
- django-allauth 0.57+
- djangorestframework-simplejwt 5.3+

**Payments:**
- stripe 7.8+

**Storage:**
- boto3 1.34+ (AWS SDK)
- django-storages 1.14+

**Task Queue:**
- celery 5.3+
- redis 5.0+
- django-celery-beat 2.5+

**Email:**
- sendgrid 6.11+

**Utilities:**
- python-slugify 8.0+
- django-cors-headers 4.3+
- django-extensions 3.2+

**Security:**
- django-csp 3.8+
- django-ratelimit 4.1+

### Development Requirements (`requirements/development.txt`)

**Development Tools:**
- django-debug-toolbar 4.2+
- ipython 8.18+
- ipdb 0.13+ (debugger)

**Testing:**
- pytest 7.4+
- pytest-django 4.7+
- pytest-cov 4.1+ (coverage)
- factory-boy 3.3+ (test fixtures)
- faker 20.1+ (fake data)

**Code Quality:**
- black 23.12+ (formatter)
- flake8 6.1+ (linter)
- isort 5.13+ (import sorting)
- pylint 3.0+

### Production Requirements (`requirements/production.txt`)

**Server:**
- gunicorn 21.2+ (WSGI server)
- whitenoise 6.6+ (static files)

**Monitoring:**
- sentry-sdk 1.39+ (error tracking)

**Performance:**
- django-redis 5.4+ (caching)

---

## API Documentation

### Auto-Generated Docs

**Swagger UI:** http://localhost:8000/api/docs/
**OpenAPI Schema:** http://localhost:8000/api/schema/

Powered by `drf-spectacular`.

### Current API Endpoints

**Users API:**
```
GET    /api/v1/users/profile/        # Get/update user profile
PUT    /api/v1/users/profile/
GET    /api/v1/users/orders/         # User order history
```

**Authentication:**
```
POST   /api/auth/login/              # Session auth
POST   /api/auth/logout/
POST   /accounts/signup/             # django-allauth registration
POST   /accounts/login/
```

### Planned API Endpoints

**Products:**
```
GET    /api/v1/products/
GET    /api/v1/products/{id}/
GET    /api/v1/products/{id}/variants/
```

**Orders:**
```
GET    /api/v1/orders/cart/
POST   /api/v1/orders/cart/add/
POST   /api/v1/orders/checkout/
GET    /api/v1/orders/
GET    /api/v1/orders/{id}/
```

**Content:**
```
GET    /api/v1/content/worlds/
GET    /api/v1/content/chronicles/
GET    /api/v1/content/characters/
```

**Digital Delivery:**
```
GET    /api/v1/digital/downloads/
GET    /api/v1/digital/download/{token}/
POST   /api/v1/digital/resend/{id}/
```

---

## Database Schema (Planned)

### Users App (✅ Implemented)
```
users_user
├── id (PK)
├── email (unique)
├── username
├── password
├── first_name
├── last_name
├── is_newsletter_subscribed
├── is_staff
├── is_active
├── created_at
└── updated_at

users_userprofile
├── id (PK)
├── user_id (FK → users_user)
├── phone
├── birth_date
├── shipping_address_line1
├── shipping_address_line2
├── shipping_city
├── shipping_state
├── shipping_postal_code
├── shipping_country
├── billing_address_line1
├── billing_address_line2
├── billing_city
├── billing_state
├── billing_postal_code
├── billing_country
├── created_at
└── updated_at
```

### Products App (⚠️ Planned)
```
products_category
├── id (PK)
├── name
├── slug (unique)
├── description
├── parent_id (FK → self)
└── created_at

products_product
├── id (PK)
├── name
├── slug (unique)
├── product_type
├── sku (unique)
├── short_description
├── full_description
├── base_price
├── status
├── is_featured
├── release_date
├── preorder_start_date
├── image
├── thumbnail
├── category_id (FK → products_category)
├── created_at
└── updated_at

products_productvariant
├── id (PK)
├── product_id (FK → products_product)
├── format_type
├── sku (unique)
├── price
├── compare_at_price
├── inventory_quantity
├── is_digital
├── digital_file
├── isbn
├── pages
├── weight
├── is_active
├── created_at
└── updated_at

products_bookmetadata
├── id (PK)
├── product_id (FK → products_product, one-to-one)
├── author
├── series
├── series_number
├── publisher
├── genre
├── target_audience
├── excerpt
├── created_at
└── updated_at
```

### Orders App (⚠️ Planned)
```
orders_cart
├── id (PK)
├── user_id (FK → users_user, nullable)
├── session_key
├── created_at
└── updated_at

orders_cartitem
├── id (PK)
├── cart_id (FK → orders_cart)
├── variant_id (FK → products_productvariant)
├── quantity
└── price_snapshot

orders_order
├── id (PK)
├── order_number (unique)
├── user_id (FK → users_user, nullable)
├── status
├── subtotal
├── tax
├── shipping_cost
├── total
├── shipping_address_*
├── billing_address_*
├── payment_method
├── stripe_payment_intent_id
├── tracking_number
├── notes
├── created_at
└── updated_at

orders_orderitem
├── id (PK)
├── order_id (FK → orders_order)
├── variant_id (FK → products_productvariant)
├── quantity
├── price
├── product_name
└── variant_name
```

---

## Testing Strategy

### Planned Test Coverage

**Unit Tests:**
- Model validation
- Model methods and properties
- Serializer validation
- Custom permissions

**Integration Tests:**
- API endpoints
- Authentication flows
- Order checkout process
- Payment processing (Stripe test mode)

**Celery Task Tests:**
- Digital delivery emails
- Order confirmation emails
- Scheduled cleanup tasks

**End-to-End Tests:**
- Complete purchase flow
- User registration → product selection → checkout → delivery

### Testing Tools

- `pytest` — Test runner
- `pytest-django` — Django integration
- `factory-boy` — Model factories
- `faker` — Fake data generation
- `pytest-cov` — Coverage reporting

---

## Security Considerations

### Implemented

✅ Custom user model with email authentication
✅ Password validation (Django defaults)
✅ CSRF protection
✅ XSS protection (Django templates)
✅ Clickjacking protection
✅ SQL injection protection (Django ORM)
✅ HTTPS enforcement (production)
✅ Secure cookies (production)
✅ HSTS headers (production)

### Planned

- [ ] Rate limiting on API endpoints
- [ ] Content Security Policy (CSP)
- [ ] Two-factor authentication (2FA)
- [ ] PCI compliance for payments (Stripe handles this)
- [ ] GDPR compliance features (data export, deletion)
- [ ] Security audit logging
- [ ] Penetration testing

---

## Performance Optimization

### Planned Optimizations

**Database:**
- [ ] Database indexes on frequently queried fields
- [ ] Select_related/prefetch_related for queries
- [ ] Database connection pooling
- [ ] Read replicas (for scaling)

**Caching:**
- [ ] Redis caching for product catalog
- [ ] Template fragment caching
- [ ] API response caching
- [ ] Session storage in Redis

**Static Assets:**
- [ ] WhiteNoise for static file serving
- [ ] CDN integration for media files
- [ ] Image optimization (Pillow)
- [ ] Lazy loading for images

**Code:**
- [ ] Async views for I/O-bound operations
- [ ] Celery for long-running tasks
- [ ] Database query optimization
- [ ] Pagination on list endpoints

---

## Deployment Checklist

### Pre-Deployment

- [ ] Set `DEBUG=False`
- [ ] Configure production database
- [ ] Set up S3 bucket for media/digital products
- [ ] Configure Stripe production keys
- [ ] Set up SendGrid for emails
- [ ] Configure Redis instance
- [ ] Set strong `SECRET_KEY`
- [ ] Configure `ALLOWED_HOSTS`
- [ ] Enable SSL certificate
- [ ] Set up error tracking (Sentry)
- [ ] Configure backup strategy

### Post-Deployment

- [ ] Run migrations
- [ ] Create superuser
- [ ] Collect static files
- [ ] Test payment flow
- [ ] Test email delivery
- [ ] Test digital product delivery
- [ ] Monitor error logs
- [ ] Performance testing
- [ ] Security scan

---

## Next Steps to Flesh Out the App

### Phase 1: Core Ecommerce (High Priority)

1. **Implement Products App** ⚠️ **CRITICAL**
   - [ ] Create Product, ProductVariant, Category, BookMetadata models
   - [ ] Implement admin interface with inline variants
   - [ ] Create DRF serializers for API
   - [ ] Build API views (list, detail, filter, search)
   - [ ] Add URL routing
   - [ ] Create sample products via fixtures
   - [ ] Test product catalog API

2. **Implement Orders App** ⚠️ **CRITICAL**
   - [ ] Create Cart, CartItem, Order, OrderItem models
   - [ ] Implement shopping cart logic (session + user)
   - [ ] Build checkout API endpoint
   - [ ] Integrate Stripe payment intents
   - [ ] Create order confirmation emails
   - [ ] Implement admin order management
   - [ ] Add order status tracking
   - [ ] Test complete purchase flow

3. **Stripe Integration** ⚠️ **CRITICAL**
   - [ ] Set up Stripe test account
   - [ ] Implement payment intent creation
   - [ ] Build webhook handler for payment confirmation
   - [ ] Handle payment failures
   - [ ] Implement refund processing
   - [ ] Test with Stripe test cards

### Phase 2: Digital Delivery (High Priority)

4. **Implement Digital Delivery App**
   - [ ] Create DigitalProduct, Download models
   - [ ] Set up AWS S3 bucket
   - [ ] Implement secure download link generation
   - [ ] Create Celery task for email delivery
   - [ ] Build download API endpoint
   - [ ] Implement download tracking
   - [ ] Add re-send download functionality
   - [ ] Test with sample ebook

5. **Email System**
   - [ ] Configure SendGrid account
   - [ ] Create email templates
   - [ ] Implement order confirmation emails
   - [ ] Implement digital delivery emails
   - [ ] Implement password reset emails
   - [ ] Test all email flows

### Phase 3: Content Management (Medium Priority)

6. **Implement Content API App**
   - [ ] Create World, Chronicle, Character models
   - [ ] Implement admin CMS interface
   - [ ] Add rich text editor (TinyMCE or CKEditor)
   - [ ] Create DRF serializers
   - [ ] Build public API endpoints
   - [ ] Implement version control (optional)
   - [ ] Add Foundry workflow integration
   - [ ] Create sample content

7. **Admin Dashboard Enhancements**
   - [ ] Customize Django admin theme
   - [ ] Add sales analytics dashboard
   - [ ] Implement inventory reports
   - [ ] Create order export functionality
   - [ ] Add customer management tools

### Phase 4: Frontend (Medium Priority)

8. **Build Frontend** (Choose one approach)

   **Option A: Django Templates**
   - [ ] Create base template with navigation
   - [ ] Build product catalog page
   - [ ] Build product detail page
   - [ ] Build cart page
   - [ ] Build checkout page
   - [ ] Build user account pages
   - [ ] Integrate with Django forms

   **Option B: React/Vue Frontend**
   - [ ] Set up frontend project (Next.js, Nuxt, Vite)
   - [ ] Implement product catalog UI
   - [ ] Implement cart functionality
   - [ ] Implement checkout flow
   - [ ] Integrate with REST API
   - [ ] Add state management (Redux, Vuex, Pinia)

9. **Preserve Branding**
   - [ ] Port static site design to dynamic platform
   - [ ] Implement starfield background
   - [ ] Integrate crown sigil SVG
   - [ ] Apply color palette (purple, gold)
   - [ ] Use Cinzel, Cormorant Garamond, Inter fonts
   - [ ] Ensure accessibility (WCAG)

### Phase 5: Advanced Features (Low Priority)

10. **User Features**
    - [ ] Wishlist functionality
    - [ ] Product reviews/ratings
    - [ ] Order tracking with shipping updates
    - [ ] Email preferences management
    - [ ] Two-factor authentication

11. **Marketing Features**
    - [ ] Newsletter subscription
    - [ ] Discount codes/coupons
    - [ ] Abandoned cart emails
    - [ ] Product recommendations
    - [ ] Gift cards

12. **Analytics & Monitoring**
    - [ ] Google Analytics integration
    - [ ] Sales reporting dashboard
    - [ ] Inventory alerts
    - [ ] Performance monitoring
    - [ ] Error tracking with Sentry

### Phase 6: Optimization & Testing (Ongoing)

13. **Testing**
    - [ ] Write unit tests for all models
    - [ ] Write API endpoint tests
    - [ ] Write integration tests for checkout
    - [ ] Write Celery task tests
    - [ ] Achieve 80%+ code coverage
    - [ ] Load testing

14. **Performance**
    - [ ] Implement Redis caching
    - [ ] Optimize database queries
    - [ ] Set up CDN for static assets
    - [ ] Enable gzip compression
    - [ ] Implement lazy loading

15. **Security Audit**
    - [ ] Run security scanner (bandit, safety)
    - [ ] Implement rate limiting
    - [ ] Add CSP headers
    - [ ] GDPR compliance review
    - [ ] Penetration testing

---

## Immediate Action Items

**To get started TODAY:**

1. ✅ Install dependencies: `pip install -r requirements/development.txt`
2. ✅ Create PostgreSQL database: `createdb maiden_crown_db`
3. ✅ Copy `.env.example` to `.env` and configure
4. ✅ Generate Django secret key
5. ✅ Run migrations: `python manage.py migrate`
6. ✅ Create superuser: `python manage.py createsuperuser`
7. ✅ Start server: `python manage.py runserver`
8. ✅ Access admin: http://localhost:8000/admin

**This week:**

1. ⚠️ Implement Product models in `apps/products/models.py`
2. ⚠️ Create admin interface for products
3. ⚠️ Add sample products via admin
4. ⚠️ Build product catalog API
5. ⚠️ Test API with Swagger UI

**This month:**

1. Complete Orders app
2. Integrate Stripe (test mode)
3. Implement Digital Delivery
4. Set up email system
5. Build basic frontend

---

## Resources

**Django Documentation:**
- https://docs.djangoproject.com/en/5.0/

**Django REST Framework:**
- https://www.django-rest-framework.org/

**Stripe Documentation:**
- https://stripe.com/docs/api

**Celery Documentation:**
- https://docs.celeryq.dev/

**AWS S3 Setup:**
- https://django-storages.readthedocs.io/

**Deployment Guides:**
- Heroku: https://devcenter.heroku.com/categories/python-support
- Railway: https://docs.railway.app/
- DigitalOcean: https://www.digitalocean.com/community/tags/django

---

## Status Summary

| Component | Status | Completion | Priority |
|-----------|--------|------------|----------|
| Users App | ✅ Complete | 100% | High |
| Products App | ⚠️ Scaffold | 10% | **CRITICAL** |
| Orders App | ⚠️ Scaffold | 5% | **CRITICAL** |
| Content API | ⚠️ Scaffold | 5% | Medium |
| Digital Delivery | ⚠️ Scaffold | 5% | High |
| Settings/Config | ✅ Complete | 100% | High |
| Dependencies | ✅ Complete | 100% | High |
| Documentation | ✅ Complete | 100% | Medium |

**Overall Completion: ~25%**

**Next Critical Path:** Products App → Orders App → Stripe Integration

---

*This platform is the foundation for Maiden Crown Press's digital presence. The scaffold is solid; now it's time to build the store.*

**🚀 Ready to ship books to readers across the worlds.**
