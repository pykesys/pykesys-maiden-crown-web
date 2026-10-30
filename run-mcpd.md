# run-mcpd.sh

**Maiden Crown Press Dynamic (MCPD) Development Runner** — an interactive menu and set of commands to build, run and manage the Django ecommerce platform development environment with Docker Compose.

---

## Table of Contents

- [Synopsis](#synopsis)
- [Description](#description)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Commands (Non-Interactive)](#commands-non-interactive)
- [Interactive Menu](#interactive-menu)
- [Settings (Environment Variables)](#settings-environment-variables)
- [Dry Run](#dry-run)
- [Project Structure](#project-structure)
- [Common Workflows](#common-workflows)
- [Troubleshooting](#troubleshooting)

---

## Synopsis

```bash
./run-mcpd.sh [command]
```

With no arguments it launches the interactive menu. Commands can be run directly for automation.

---

## Description

The runner manages a **complete Django development environment** with:

- **Django 5.x** web application with hot-reload
- **PostgreSQL 14+** database
- **Redis** for Celery task queue
- **Debug Toolbar** and development tools
- **Automated migrations** and setup

All services run in Docker containers orchestrated with Docker Compose. The app is published on `http://127.0.0.1:8000/` (localhost only).

---

## Prerequisites

| Requirement | Notes |
|:---|:---|
| **Docker** | macOS: Docker Desktop, Linux: Docker Engine 20.10+ |
| **Docker Compose** | V1 (`docker-compose`) or V2 (`docker compose`) |
| **bash** | Already on macOS/Linux |
| **python3** (optional) | For local development without containers |

**Installation:**

```bash
# macOS (Docker Desktop includes Compose)
brew install --cask docker

# Linux
curl -fsSL https://get.docker.com | sh
sudo apt-get install docker-compose  # or use Docker Compose V2
```

**Alternative:** Use Podman instead of Docker:
```bash
brew install podman podman-compose
RUNTIME=podman COMPOSE=podman-compose ./run-mcpd.sh
```

---

## Quick Start

```bash
# 1. Check prerequisites
./run-mcpd.sh setup

# 2. Configure environment
cd dynamic
cp .env.example .env
# Edit .env if needed (defaults work for development)

# 3. Build containers
./run-mcpd.sh build

# 4. Start all services
./run-mcpd.sh up

# 5. Run database migrations
./run-mcpd.sh migrate

# 6. Create admin user
./run-mcpd.sh createsuperuser

# 7. Open in browser
./run-mcpd.sh browser

# 8. Follow logs (second terminal)
./run-mcpd.sh logs:web
```

**First-time complete setup:**
```bash
./run-mcpd.sh setup && \
  cd dynamic && cp .env.example .env && cd .. && \
  ./run-mcpd.sh build && \
  ./run-mcpd.sh up && \
  ./run-mcpd.sh migrate && \
  ./run-mcpd.sh createsuperuser && \
  ./run-mcpd.sh browser
```

---

## Commands (Non-Interactive)

Run a command directly without entering the menu:

### Setup
```bash
./run-mcpd.sh setup            # Check Docker/Compose, show next steps
```

### Container Management
```bash
./run-mcpd.sh build            # Build all containers
./run-mcpd.sh up               # Start all services (detached)
./run-mcpd.sh down             # Stop all services (keep volumes)
./run-mcpd.sh status           # Show container status
./run-mcpd.sh clean            # Full reset: stop, remove, rebuild
./run-mcpd.sh connect          # Open bash shell in web container
```

### Django Commands
```bash
./run-mcpd.sh migrate          # Run database migrations
./run-mcpd.sh makemigrations   # Create new migrations
./run-mcpd.sh createsuperuser  # Create Django admin user
./run-mcpd.sh shell            # Open Django Python shell (with shell_plus)
./run-mcpd.sh dbshell          # Open PostgreSQL psql shell
./run-mcpd.sh collectstatic    # Collect static files
./run-mcpd.sh flush            # DELETE ALL DATA (asks for confirmation)
```

### Application
```bash
./run-mcpd.sh logs:web         # Follow Django logs
./run-mcpd.sh logs:db          # Follow PostgreSQL logs
./run-mcpd.sh logs:all         # Follow all service logs
./run-mcpd.sh browser          # Open http://127.0.0.1:8000/
./run-mcpd.sh admin            # Open Django admin
./run-mcpd.sh docs             # Open API documentation (Swagger UI)
```

### Testing & Quality
```bash
./run-mcpd.sh test             # Run pytest test suite
./run-mcpd.sh coverage         # Run tests with coverage report
./run-mcpd.sh lint             # Check code quality (flake8, black, isort)
./run-mcpd.sh format           # Auto-format code
```

### Data Management
```bash
./run-mcpd.sh loaddata         # Load sample fixtures
./run-mcpd.sh dumpdata         # Export database to JSON
```

### Help
```bash
./run-mcpd.sh help             # Show all commands
```

---

## Interactive Menu

Launch with no arguments to enter the interactive menu:

```bash
./run-mcpd.sh
```

### Menu Structure

```
╔════════════════════════════════════════════════╗
║   Maiden Crown Press Dynamic Dev Runner       ║
║          Django Ecommerce Platform             ║
╚════════════════════════════════════════════════╝

Available Commands:

  Setup:
   0) Setup: Runtime        (Check Docker/Podman installation)

  Container Management:
   1) Build: Containers     (Build all Docker images)
   2) Up: Start All         (Start all services: Django + PostgreSQL + Redis)
   3) Connect: Shell        (Open Django shell in web container)
   4) Status: Containers    (List all containers)
   5) Down: Stop All        (Stop all containers, keep volumes)
   6) Clean: Full Reset     (Stop, remove containers and volumes, rebuild)

  Django Commands:
   7) Migrate: Database     (Run Django migrations)
   8) Makemigrations        (Create new migrations)
   9) Createsuperuser       (Create Django admin user)
  10) Shell: Django         (Open Django Python shell)
  11) Shell: DB             (Open PostgreSQL shell)
  12) Collectstatic         (Collect static files)
  13) Flush: Database       (WARNING: Delete all data)

  Application:
  14) Logs: Web            (Follow Django logs)
  15) Logs: DB             (Follow PostgreSQL logs)
  16) Logs: All            (Follow all service logs)
  17) Browser              (Open app in browser)
  18) Admin                (Open Django admin)
  19) API Docs             (Open Swagger UI)

  Testing & Quality:
  20) Test: Run All        (Run pytest test suite)
  21) Test: Coverage       (Run tests with coverage report)
  22) Lint: Check          (Run flake8, black, isort)
  23) Format: Code         (Auto-format with black and isort)

  Data Management:
  24) Load: Fixtures       (Load sample data)
  25) Dump: Database       (Export database to JSON)
  26) Backup: Volumes      (Create volume backup)
  27) Restore: Volumes     (Restore from backup)

  Debug: ENABLED (timestamped logs)  [d to toggle]

  q) Quit
```

### Menu Controls

| Key | Action |
|:---|:---|
| `d` or `D` | Toggle debug mode (timestamped vs continuous logs) |
| `q` or `Q` | Quit |

---

## Settings (Environment Variables)

Override defaults by setting environment variables:

| Variable | Default | Meaning |
|:---|:---|:---|
| `RUNTIME` | `docker` | Container runtime (`docker` or `podman`) |
| `COMPOSE` | `docker-compose` | Compose command (`docker-compose`, `docker compose`, or `podman-compose`) |
| `PROJECT_NAME` | `mcpd` | Docker Compose project name (container prefix) |
| `PORT` | `8000` | Host port for Django (published on 127.0.0.1) |
| `DB_PORT` | `5432` | PostgreSQL port |
| `REDIS_PORT` | `6379` | Redis port |
| `DEBUG` | `true` | Timestamped logs (`true`) vs continuous logs (`false`) |
| `DRY_RUN` | `0` | `1` = print commands without running them |
| `ASSUME_YES` | `0` | `1` = skip confirmations (for automation) |

**Example usage:**

```bash
# Use Podman instead of Docker
RUNTIME=podman COMPOSE=podman-compose ./run-mcpd.sh up

# Run on different port
PORT=8080 ./run-mcpd.sh up

# Dry run to see what would execute
DRY_RUN=1 ./run-mcpd.sh clean

# Non-interactive clean (for CI/CD)
ASSUME_YES=1 ./run-mcpd.sh clean
```

---

## Dry Run

Print commands without executing:

```bash
DRY_RUN=1 ./run-mcpd.sh up
```

Output:
```
+ docker-compose -p mcpd up -d
```

Useful for:
- Debugging
- Understanding what the script does
- Generating commands for documentation

---

## Project Structure

```
pykesys-maiden-crown-web/
├── run-mcpd.sh              # This runner script
├── run-mcpd.md              # This documentation
├── log/                     # Runner logs (gitignored)
│   ├── run-build.log
│   ├── run-up.log
│   └── run-tests-*.log
│
└── dynamic/                 # Django project root
    ├── docker-compose.dev.yml    # Multi-container orchestration
    ├── Dockerfile.dev            # Django development image
    ├── .env.example              # Environment template
    ├── .env                      # Your local config (gitignored)
    ├── manage.py
    ├── maiden_crown_store/       # Django project
    ├── apps/                     # Django applications
    ├── requirements/             # Python dependencies
    └── ...
```

---

## Common Workflows

### 1. Daily Development

Start containers and work:

```bash
# Start everything
./run-mcpd.sh up

# In another terminal, watch logs
./run-mcpd.sh logs:web

# Make code changes (hot-reload is automatic)

# When done
./run-mcpd.sh down
```

### 2. Running Migrations After Model Changes

```bash
# Edit models in apps/*/models.py

# Create migrations
./run-mcpd.sh makemigrations

# Review migration files, then apply
./run-mcpd.sh migrate
```

### 3. Adding Sample Data

```bash
# Create fixtures file (if not exists)
./run-mcpd.sh shell
>>> from apps.products.models import Product, Category
>>> # Create data...
>>> exit()

# Or load existing fixtures
./run-mcpd.sh loaddata
```

### 4. Testing Before Commit

```bash
# Run tests
./run-mcpd.sh test

# Check code quality
./run-mcpd.sh lint

# Auto-format if needed
./run-mcpd.sh format

# Re-run tests
./run-mcpd.sh test
```

### 5. Database Reset

```bash
# Backup first
./run-mcpd.sh dumpdata

# Delete all data
./run-mcpd.sh flush

# Or full reset (including schema)
./run-mcpd.sh down
docker volume rm mcpd_postgres_data
./run-mcpd.sh up
./run-mcpd.sh migrate
```

### 6. Debugging Database Issues

```bash
# Open PostgreSQL shell
./run-mcpd.sh dbshell

# Inside psql:
\dt                  -- List tables
\d users_user        -- Describe table
SELECT * FROM users_user LIMIT 5;
\q                   -- Quit
```

### 7. Working with Django Shell

```bash
# Open enhanced shell (shell_plus)
./run-mcpd.sh shell

# Inside shell:
>>> from apps.products.models import Product
>>> Product.objects.all()
>>> Product.objects.create(name="Test", ...)
>>> exit()
```

### 8. Viewing API Documentation

```bash
# Open Swagger UI
./run-mcpd.sh docs

# Manually: http://127.0.0.1:8000/api/docs/
```

### 9. Complete Rebuild

When things go wrong:

```bash
# Nuclear option: destroy everything and start fresh
./run-mcpd.sh clean

# After clean completes:
./run-mcpd.sh migrate
./run-mcpd.sh createsuperuser
```

### 10. Running Celery Tasks (Future)

```bash
# Start Celery worker (when implemented)
./run-mcpd.sh connect
root@container:/app# celery -A maiden_crown_store worker -l info
```

---

## Troubleshooting

### Docker Not Running

**Symptom:** `✗ 'docker' not found`

**Solution:**
1. Install Docker Desktop (macOS/Windows) or Docker Engine (Linux)
2. Start Docker Desktop application
3. Or use Podman: `RUNTIME=podman COMPOSE=podman-compose ./run-mcpd.sh`

---

### Port Already in Use

**Symptom:** `Error: port 8000 already allocated`

**Solutions:**
```bash
# Option 1: Use different port
PORT=8080 ./run-mcpd.sh up

# Option 2: Find and kill process using port 8000
lsof -i :8000
kill -9 <PID>
```

---

### Database Connection Failed

**Symptom:** `django.db.utils.OperationalError: could not connect to server`

**Diagnosis:**
```bash
# Check if database container is running
./run-mcpd.sh status

# Check database logs
./run-mcpd.sh logs:db
```

**Solutions:**
```bash
# Wait a few seconds after 'up' for DB to initialize
sleep 5 && ./run-mcpd.sh migrate

# Or restart database
./run-mcpd.sh down
./run-mcpd.sh up
```

---

### Migrations Not Applied

**Symptom:** `Table doesn't exist` errors

**Solution:**
```bash
# Run migrations
./run-mcpd.sh migrate

# If that fails, check migration files
./run-mcpd.sh makemigrations
./run-mcpd.sh migrate
```

---

### Static Files Not Loading

**Symptom:** CSS/JS not loading in browser

**Solution:**
```bash
# Collect static files
./run-mcpd.sh collectstatic

# In development, Django serves static files automatically
# Ensure DEBUG=True in .env
```

---

### Container Build Fails

**Symptom:** Build errors during `./run-mcpd.sh build`

**Solutions:**
```bash
# Check Dockerfile.dev syntax
cat dynamic/Dockerfile.dev

# Rebuild without cache
cd dynamic
docker-compose -p mcpd build --no-cache

# Check Docker disk space
docker system df
docker system prune  # Free up space
```

---

### Permission Denied Errors

**Symptom:** `Permission denied` when running commands

**Solutions:**
```bash
# Make script executable
chmod +x run-mcpd.sh

# Fix Docker socket permissions (Linux)
sudo usermod -aG docker $USER
newgrp docker

# Or run with sudo (not recommended)
sudo ./run-mcpd.sh up
```

---

### Hot Reload Not Working

**Symptom:** Code changes don't reflect without restart

**Check:**
1. Ensure volume mount is configured in `docker-compose.dev.yml`
2. Verify Django runserver is running (not gunicorn)
3. Check logs for errors

**Solution:**
```bash
# Restart web container
./run-mcpd.sh down
./run-mcpd.sh up

# Or manually restart
docker-compose -p mcpd restart web
```

---

### Database Data Lost After Restart

**Symptom:** Data disappears after `down` + `up`

**Cause:** Using `./run-mcpd.sh clean` which deletes volumes

**Prevention:**
```bash
# Use 'down' to stop (keeps volumes)
./run-mcpd.sh down

# NOT 'clean' (removes volumes)
```

**Recovery:**
```bash
# Restore from backup if you have one
./run-mcpd.sh restore

# Or re-run migrations and re-create data
./run-mcpd.sh migrate
./run-mcpd.sh loaddata
```

---

### Tests Failing

**Symptom:** `./run-mcpd.sh test` shows failures

**Diagnosis:**
```bash
# Run with verbose output
./run-mcpd.sh connect
root@container:/app# pytest -v

# Run specific test
root@container:/app# pytest apps/products/tests.py::TestProduct -v
```

**Common causes:**
- Database not migrated in test environment
- Missing test fixtures
- Incorrect test configuration

---

### Can't Access Admin Panel

**Symptom:** Admin login fails or redirects

**Solution:**
```bash
# Create superuser if you haven't
./run-mcpd.sh createsuperuser

# Check if user exists
./run-mcpd.sh shell
>>> from apps.users.models import User
>>> User.objects.filter(is_superuser=True)

# Reset password
./run-mcpd.sh connect
root@container:/app# python manage.py changepassword admin@example.com
```

---

### Docker Compose Version Mismatch

**Symptom:** `unknown option: -p`

**Cause:** Using Docker Compose V2 with V1 syntax

**Solution:**
```bash
# Use V2 syntax
COMPOSE="docker compose" ./run-mcpd.sh up

# Or install V1
pip install docker-compose
```

---

## Logs and Files

| Path | Description |
|:---|:---|
| `run-mcpd.sh` | Main runner script (project root) |
| `run-mcpd.md` | This documentation |
| `log/` | All runner log output (gitignored) |
| `log/run-build.log` | Container build log (appended) |
| `log/run-up.log` | Service startup log (appended) |
| `log/run-tests-<timestamp>.log` | Test run logs (when debug mode on) |
| `log/run-tests.log` | Continuous test log (when debug mode off) |
| `dynamic/Dockerfile.dev` | Django container image definition |
| `dynamic/docker-compose.dev.yml` | Multi-container orchestration |
| `dynamic/.env` | Your local environment config (gitignored) |
| `dynamic/.env.example` | Environment template |

---

## Exit Codes

| Code | Meaning |
|:---|:---|
| `0` | Success |
| `1` | Unknown command, failed step, or user cancellation |
| `127` | Docker/Podman not installed |

---

## Advanced Usage

### Custom Docker Compose File

```bash
# Use different compose file
COMPOSE_FILE=docker-compose.production.yml ./run-mcpd.sh up
```

### Run Commands in Container

```bash
# Connect to container
./run-mcpd.sh connect

# Inside container:
root@container:/app# python manage.py <command>
root@container:/app# pip install <package>
root@container:/app# pytest
```

### Multiple Environments

```bash
# Development (default)
./run-mcpd.sh up

# Separate staging environment
PROJECT_NAME=mcpd-staging PORT=8001 ./run-mcpd.sh up
```

### CI/CD Integration

```bash
# Non-interactive, automated flow
ASSUME_YES=1 ./run-mcpd.sh clean && \
  ./run-mcpd.sh up && \
  ./run-mcpd.sh migrate && \
  ./run-mcpd.sh test
```

---

## Security Notes

1. **Never commit `.env` files** with real secrets
2. **Use strong passwords** for superuser accounts
3. **Bind to localhost only** in development (127.0.0.1)
4. **Don't expose ports** to external networks
5. **Keep Docker images updated**
6. **Review docker-compose.yml** for production deployments

---

## Contributing

When modifying `run-mcpd.sh`:

1. Test all commands: `DRY_RUN=1 ./run-mcpd.sh <command>`
2. Update this documentation
3. Follow the existing code style
4. Add new commands to both CLI and interactive menu
5. Update help text

---

## License

Part of the Maiden Crown Press project. See main README for license information.

---

## Support

**For issues with the runner:**
- Check this documentation
- Review logs in `./log/`
- Check Docker/Compose documentation

**For Django/application issues:**
- See `dynamic/README.md`
- See `dynamic/GETTING_STARTED.md`
- See `docs/project-dynamic.md`

---

**The development environment endures. Build with confidence. 👑**
