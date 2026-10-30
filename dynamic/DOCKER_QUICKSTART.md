# Docker Development Quick Start

**Get the Maiden Crown Press Dynamic platform running in under 5 minutes.**

---

## Prerequisites

- Docker Desktop installed and running
- Git repository cloned

---

## One-Command Setup (macOS/Linux)

From the **project root**:

```bash
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
2. ✅ Copies environment template
3. ✅ Builds all containers (Django, PostgreSQL, Redis)
4. ✅ Starts all services
5. ✅ Runs database migrations
6. ✅ Prompts you to create admin user
7. ✅ Opens browser to http://127.0.0.1:8000/

---

## Step-by-Step Setup

### 1. Check Prerequisites
```bash
./run-mcpd.sh setup
```

### 2. Configure Environment
```bash
cd dynamic
cp .env.example .env
# Optional: edit .env (defaults work for development)
cd ..
```

### 3. Build Containers
```bash
./run-mcpd.sh build
```
*First time: ~5 minutes to download images and install dependencies*

### 4. Start Services
```bash
./run-mcpd.sh up
```
*Starts Django, PostgreSQL, and Redis*

### 5. Run Migrations
```bash
./run-mcpd.sh migrate
```
*Creates database tables*

### 6. Create Admin User
```bash
./run-mcpd.sh createsuperuser
```
*Follow prompts to create your admin account*

### 7. Open in Browser
```bash
./run-mcpd.sh browser
```
*Opens http://127.0.0.1:8000/*

---

## Daily Workflow

### Start Working
```bash
# Start all services
./run-mcpd.sh up

# In another terminal, watch logs
./run-mcpd.sh logs:web
```

### Make Code Changes
- Edit files in `dynamic/` — **changes auto-reload!**
- No need to restart containers

### Run Migrations (after model changes)
```bash
./run-mcpd.sh makemigrations
./run-mcpd.sh migrate
```

### Stop Working
```bash
./run-mcpd.sh down
```
*Stops containers but keeps your data*

---

## Common Commands

```bash
# Container management
./run-mcpd.sh up              # Start all services
./run-mcpd.sh down            # Stop all services
./run-mcpd.sh status          # Check container status
./run-mcpd.sh logs:web        # View Django logs

# Django commands
./run-mcpd.sh shell           # Django Python shell
./run-mcpd.sh dbshell         # PostgreSQL shell
./run-mcpd.sh migrate         # Run migrations

# Testing
./run-mcpd.sh test            # Run tests
./run-mcpd.sh lint            # Check code quality
./run-mcpd.sh format          # Auto-format code

# Open in browser
./run-mcpd.sh browser         # Homepage
./run-mcpd.sh admin           # Admin panel
./run-mcpd.sh docs            # API docs (Swagger)
```

---

## Troubleshooting

### Port Already in Use
```bash
# Use different port
PORT=8080 ./run-mcpd.sh up
```

### Can't Connect to Database
```bash
# Wait a few seconds for DB to initialize
sleep 10
./run-mcpd.sh migrate
```

### Forgot Admin Password
```bash
./run-mcpd.sh connect
root@container:/app# python manage.py changepassword admin@example.com
```

### Complete Reset
```bash
# Nuclear option: destroys everything
./run-mcpd.sh clean

# Then re-setup
./run-mcpd.sh migrate
./run-mcpd.sh createsuperuser
```

---

## URLs

| Service | URL |
|:---|:---|
| **Homepage** | http://127.0.0.1:8000/ |
| **Admin Panel** | http://127.0.0.1:8000/admin |
| **API Docs** | http://127.0.0.1:8000/api/docs/ |
| **API Schema** | http://127.0.0.1:8000/api/schema/ |

---

## File Structure

```
pykesys-maiden-crown-web/
├── run-mcpd.sh              # Container manager
├── run-mcpd.md              # Full documentation
└── dynamic/
    ├── Dockerfile.dev       # Django container
    ├── docker-compose.dev.yml   # Multi-container setup
    ├── .env                 # Your local config
    ├── manage.py
    └── apps/                # Django apps
```

---

## Next Steps

1. ✅ **Implement Products App** — See `docs/project-dynamic.md`
2. ✅ **Add Sample Products** — Via admin panel
3. ✅ **Build Orders App** — Shopping cart & checkout
4. ✅ **Integrate Stripe** — Payment processing
5. ✅ **Deploy** — See `dynamic/README.md`

---

## Full Documentation

- **Runner Guide:** `run-mcpd.md`
- **Django Setup:** `dynamic/GETTING_STARTED.md`
- **Project Overview:** `dynamic/README.md`
- **Architecture:** `docs/project-dynamic.md`
- **Admin Guide:** `docs/Guide-Admin-Dynamic.md`

---

**Happy coding! 👑**

*The containerized development environment endures.*
