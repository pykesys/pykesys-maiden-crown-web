# Getting Started with Maiden Crown Store (Django)

This guide will help you set up the Maiden Crown Press ecommerce platform locally.

---

## Prerequisites

- Python 3.11+ installed
- PostgreSQL 14+ installed
- Redis (optional, for Celery tasks)
- Git

---

## Step-by-Step Setup

### 1. Clone and Navigate
```bash
cd dynamic
```

### 2. Create Virtual Environment
```bash
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

### 3. Install Dependencies
```bash
pip install --upgrade pip
pip install -r requirements/development.txt
```

### 4. Set Up Database

#### Create PostgreSQL Database
```bash
# Using psql
createdb maiden_crown_db

# OR using SQL
psql postgres
CREATE DATABASE maiden_crown_db;
CREATE USER maiden_crown_user WITH PASSWORD 'your_password';
GRANT ALL PRIVILEGES ON DATABASE maiden_crown_db TO maiden_crown_user;
\q
```

### 5. Configure Environment Variables
```bash
cp .env.example .env
```

Edit `.env` and update:
```bash
SECRET_KEY=your-generated-secret-key
DB_NAME=maiden_crown_db
DB_USER=maiden_crown_user  # or postgres
DB_PASSWORD=your_password
```

**Generate a secret key:**
```bash
python -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())"
```

### 6. Run Migrations
```bash
python manage.py makemigrations
python manage.py migrate
```

### 7. Create Superuser
```bash
python manage.py createsuperuser
```

Follow the prompts to create your admin account.

### 8. Run Development Server
```bash
python manage.py runserver
```

Visit: **http://localhost:8000**

### 9. Access Admin Panel
Visit: **http://localhost:8000/admin**

Log in with your superuser credentials.

---

## API Documentation

Once the server is running, visit:
- **Swagger UI:** http://localhost:8000/api/docs/
- **API Schema:** http://localhost:8000/api/schema/

---

## Running Celery (Optional)

For async tasks like digital delivery:

### Terminal 1: Start Redis
```bash
redis-server
```

### Terminal 2: Start Celery Worker
```bash
celery -A maiden_crown_store worker -l info
```

### Terminal 3: Start Celery Beat (for scheduled tasks)
```bash
celery -A maiden_crown_store beat -l info
```

---

## Development Workflow

### Create New App
```bash
python manage.py startapp my_app
```

### Make Migrations
```bash
python manage.py makemigrations
python manage.py migrate
```

### Run Tests
```bash
pytest
# OR
python manage.py test
```

### Format Code
```bash
black .
isort .
```

### Check Code Quality
```bash
flake8
```

### Run Django Shell
```bash
python manage.py shell_plus  # Enhanced shell with django-extensions
# OR
python manage.py shell
```

---

## Creating Products

### Via Admin Panel
1. Go to http://localhost:8000/admin
2. Navigate to **Products** → **Add Product**
3. Fill in product details
4. Add **Product Variants** (formats: hardcover, ebook, etc.)
5. For books, add **Book Metadata**

### Via Django Shell
```python
python manage.py shell

from apps.products.models import Product, ProductVariant, Category

# Create category
category = Category.objects.create(name="Science Fiction", slug="science-fiction")

# Create product
product = Product.objects.create(
    name="The Weight of Thirty Worlds - Book 1",
    slug="weight-of-thirty-worlds-1",
    product_type="book",
    short_description="The first book in the Maiden Crown saga",
    full_description="Full description here...",
    base_price=24.99,
    status="preorder",
    category=category
)

# Create variants
hardcover = ProductVariant.objects.create(
    product=product,
    format_type="hardcover",
    sku="WOTW-1-HC",
    price=29.99,
    inventory_quantity=100,
    is_digital=False
)

ebook = ProductVariant.objects.create(
    product=product,
    format_type="ebook",
    sku="WOTW-1-EB",
    price=9.99,
    is_digital=True
)
```

---

## Stripe Integration

### Test Mode Setup
1. Create a Stripe account at https://stripe.com
2. Get your test API keys from Dashboard
3. Add to `.env`:
```bash
STRIPE_PUBLIC_KEY=pk_test_...
STRIPE_SECRET_KEY=sk_test_...
```

### Test Cards
- Success: `4242 4242 4242 4242`
- Decline: `4000 0000 0000 0002`

---

## Troubleshooting

### Database Connection Error
```bash
# Check PostgreSQL is running
psql --version
pg_ctl status

# Restart PostgreSQL (macOS)
brew services restart postgresql

# Check connection
psql -U postgres -h localhost
```

### Migration Issues
```bash
# Reset migrations (DEVELOPMENT ONLY)
python manage.py migrate --fake
python manage.py migrate --run-syncdb

# OR drop database and recreate
dropdb maiden_crown_db
createdb maiden_crown_db
python manage.py migrate
```

### Port Already in Use
```bash
# Find process on port 8000
lsof -i :8000

# Kill process
kill -9 <PID>

# OR use different port
python manage.py runserver 8001
```

---

## Next Steps

1. ✅ Set up database and run migrations
2. ✅ Create superuser and access admin
3. ⬜ Create sample products
4. ⬜ Test API endpoints
5. ⬜ Set up Stripe test mode
6. ⬜ Implement frontend (React/Vue) or use Django templates
7. ⬜ Configure email delivery
8. ⬜ Set up S3 for digital products

---

## Useful Commands Reference

```bash
# Migrations
python manage.py makemigrations
python manage.py migrate
python manage.py showmigrations

# Database
python manage.py dbshell
python manage.py dumpdata > backup.json
python manage.py loaddata backup.json

# Users
python manage.py createsuperuser
python manage.py changepassword <username>

# Static files
python manage.py collectstatic

# Server
python manage.py runserver
python manage.py runserver 0.0.0.0:8000

# Shell
python manage.py shell
python manage.py shell_plus

# Testing
python manage.py test
pytest
coverage run -m pytest
coverage report
```

---

## Support

For questions or issues:
- Check the main README.md
- Review Django documentation: https://docs.djangoproject.com
- DRF documentation: https://www.django-rest-framework.org

---

*Happy coding! 👑*
