#!/usr/bin/env bash
#
# Maiden Crown Press Dynamic (MCPD) Development Runner
# Build, run and manage the Django ecommerce platform in containers with Docker or Podman,
# with an interactive menu or direct commands.
#
# The development environment runs Django, PostgreSQL, and Redis in containers with
# hot-reload, debug toolbar, and all development tools. Adapted from the AuthBot runner.
#
# Note: set -e is NOT used so the interactive menu survives a failed step

# Debug mode (timestamped logs vs continuous)
DEBUG="${DEBUG:-true}"

# ISO-like date for log names
DATE=$(date +%Y-%m-%d:%H:%M)

# User
USER=$(whoami)

# Colors
NC='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
ORANGE='\033[38;5;208m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BRIGHT_RED='\033[0;91m'
BRIGHT_GREEN='\033[0;92m'
BRIGHT_BLUE='\033[0;94m'
BRIGHT_CYAN='\033[0;96m'
BRIGHT_BLACK='\033[0;90m'

# Get script directory and set log dir
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG="$SCRIPT_DIR/log"

# Settings (override in the environment)
RUNTIME="${RUNTIME:-docker}"           # docker or podman
COMPOSE="${COMPOSE:-docker-compose}"   # docker-compose or podman-compose
PROJECT_NAME="${PROJECT_NAME:-mcpd}"   # compose project name
WEB_CONTAINER="${WEB_CONTAINER:-${PROJECT_NAME}_web_1}"
DB_CONTAINER="${DB_CONTAINER:-${PROJECT_NAME}_db_1}"
REDIS_CONTAINER="${REDIS_CONTAINER:-${PROJECT_NAME}_redis_1}"
PORT="${PORT:-8000}"                   # host port for Django
DB_PORT="${DB_PORT:-5432}"            # PostgreSQL port
REDIS_PORT="${REDIS_PORT:-6379}"      # Redis port
DRY_RUN="${DRY_RUN:-0}"               # 1 = print commands instead of running
ASSUME_YES="${ASSUME_YES:-0}"         # 1 = skip confirmations
URL="http://127.0.0.1:${PORT}/"

mkdir -p "$LOG" 2>/dev/null

####
# Banner
function show_banner() {
    echo -e "${BRIGHT_BLUE}"
    echo "╔════════════════════════════════════════════════╗"
    echo "║   Maiden Crown Press Dynamic Dev Runner       ║"
    echo "║          Django Ecommerce Platform             ║"
    echo "╚════════════════════════════════════════════════╝"
    if [ "$DEBUG" == "true" ]; then
        echo -e "${BRIGHT_RED}"
        echo "╔════════════════════════════════════════════════╗"
        echo "║              Debug Information                 ║"
        echo "║ Script Dir: ${SCRIPT_DIR}"
        echo "║ Log Dir:    ${LOG}"
        echo "║ Date:       ${DATE}"
        echo "║ User:       ${USER}"
        echo "║ Runtime:    ${RUNTIME}  Compose: ${COMPOSE}"
        echo "║ Project:    ${PROJECT_NAME}"
        echo "╚════════════════════════════════════════════════╝"
        echo -e "${NC}"
    else
        echo -e "${NC}"
    fi
}

####
# Toggle DEBUG mode
function toggle_debug() {
    if [ "$DEBUG" == "true" ]; then
        DEBUG="false"
        echo -e "${YELLOW}Debug mode disabled${NC} - Logs will append to single files"
    else
        DEBUG="true"
        echo -e "${BRIGHT_GREEN}Debug mode enabled${NC} - Logs will be timestamped"
    fi
    echo ""
    sleep 1
}

# Menu
function show_menu() {
    echo -e "${YELLOW}Available Commands:${NC}\n"
    echo -e "  ${BRIGHT_BLUE}Setup:${NC}"
    echo -e "  ${GREEN} 0)${NC} ${BRIGHT_CYAN}Setup: Runtime        ${BLUE}(Check Docker/Podman installation)${NC}"
    echo ""
    echo -e "  ${BRIGHT_BLUE}Container Management:${NC}"
    echo -e "  ${GREEN} 1)${NC} ${BRIGHT_GREEN}Build: Containers     ${BLUE}(Build all Docker images)${NC}"
    echo -e "  ${GREEN} 2)${NC} ${BRIGHT_GREEN}Up: Start All         ${BLUE}(Start all services: Django + PostgreSQL + Redis)${NC}"
    echo -e "  ${GREEN} 3)${NC} ${BRIGHT_GREEN}Connect: Shell        ${BLUE}(Open Django shell in web container)${NC}"
    echo -e "  ${GREEN} 4)${NC} ${ORANGE}Status: Containers    ${BLUE}(List all containers)${NC}"
    echo -e "  ${GREEN} 5)${NC} ${BRIGHT_RED}Down: Stop All        ${BLUE}(Stop all containers, keep volumes)${NC}"
    echo -e "  ${GREEN} 6)${NC} ${BRIGHT_RED}Clean: Full Reset     ${BLUE}(Stop, remove containers and volumes, rebuild)${NC}"
    echo ""
    echo -e "  ${BRIGHT_BLUE}Django Commands:${NC}"
    echo -e "  ${GREEN} 7)${NC} ${BRIGHT_GREEN}Migrate: Database     ${BLUE}(Run Django migrations)${NC}"
    echo -e "  ${GREEN} 8)${NC} ${BRIGHT_GREEN}Makemigrations        ${BLUE}(Create new migrations)${NC}"
    echo -e "  ${GREEN} 9)${NC} ${BRIGHT_GREEN}Createsuperuser       ${BLUE}(Create Django admin user)${NC}"
    echo -e "  ${GREEN}10)${NC} ${BRIGHT_GREEN}Shell: Django         ${BLUE}(Open Django Python shell)${NC}"
    echo -e "  ${GREEN}11)${NC} ${BRIGHT_GREEN}Shell: DB             ${BLUE}(Open PostgreSQL shell)${NC}"
    echo -e "  ${GREEN}12)${NC} ${ORANGE}Collectstatic        ${BLUE}(Collect static files)${NC}"
    echo -e "  ${GREEN}13)${NC} ${ORANGE}Flush: Database      ${BLUE}(WARNING: Delete all data)${NC}"
    echo ""
    echo -e "  ${BRIGHT_BLUE}Application:${NC}"
    echo -e "  ${GREEN}14)${NC} ${ORANGE}Logs: Web            ${BLUE}(Follow Django logs)${NC}"
    echo -e "  ${GREEN}15)${NC} ${ORANGE}Logs: DB             ${BLUE}(Follow PostgreSQL logs)${NC}"
    echo -e "  ${GREEN}16)${NC} ${ORANGE}Logs: All            ${BLUE}(Follow all service logs)${NC}"
    echo -e "  ${GREEN}17)${NC} ${ORANGE}Browser              ${BLUE}(Open app in browser: ${URL})${NC}"
    echo -e "  ${GREEN}18)${NC} ${ORANGE}Admin                ${BLUE}(Open Django admin: ${URL}admin)${NC}"
    echo -e "  ${GREEN}19)${NC} ${ORANGE}API Docs             ${BLUE}(Open Swagger UI: ${URL}api/docs/)${NC}"
    echo ""
    echo -e "  ${BRIGHT_BLUE}Testing & Quality:${NC}"
    echo -e "  ${GREEN}20)${NC} ${CYAN}Test: Run All        ${BLUE}(Run pytest test suite)${NC}"
    echo -e "  ${GREEN}21)${NC} ${CYAN}Test: Coverage       ${BLUE}(Run tests with coverage report)${NC}"
    echo -e "  ${GREEN}22)${NC} ${CYAN}Lint: Check          ${BLUE}(Run flake8, black, isort)${NC}"
    echo -e "  ${GREEN}23)${NC} ${CYAN}Format: Code         ${BLUE}(Auto-format with black and isort)${NC}"
    echo ""
    echo -e "  ${BRIGHT_BLUE}Data Management:${NC}"
    echo -e "  ${GREEN}24)${NC} ${ORANGE}Load: Fixtures       ${BLUE}(Load sample data)${NC}"
    echo -e "  ${GREEN}25)${NC} ${ORANGE}Dump: Database       ${BLUE}(Export database to JSON)${NC}"
    echo -e "  ${GREEN}26)${NC} ${CYAN}Backup: Volumes      ${BLUE}(Create volume backup)${NC}"
    echo -e "  ${GREEN}27)${NC} ${CYAN}Restore: Volumes     ${BLUE}(Restore from backup)${NC}"
    echo ""

    if [ "$DEBUG" == "true" ]; then
        echo -e "  ${CYAN}Debug:${NC} ${BRIGHT_GREEN}ENABLED${NC} (timestamped logs)  ${MAGENTA}[d to toggle]${NC}"
    else
        echo -e "  ${CYAN}Debug:${NC} ${BRIGHT_BLACK}disabled${NC} (continuous logs)  ${MAGENTA}[d to toggle]${NC}"
    fi

    echo ""
    echo -e "  ${BRIGHT_RED}q)${NC} Quit"
    echo ""
}

############
# Helpers

# Print the command, or run it when DRY_RUN is not 1
function run() {
    if [ "$DRY_RUN" == "1" ]; then
        printf '+'; printf ' %q' "$@"; printf '\n'
    else
        "$@"
    fi
}

# Best effort: ignore failures
function quiet() {
    if [ "$DRY_RUN" == "1" ]; then run "$@"; else "$@" >/dev/null 2>&1 || true; fi
}

# Success line
function ok() {
    [ "$DRY_RUN" == "1" ] && return 0
    echo -e "${GREEN}✓ $*${NC}"
}

function header() {
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}$1${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    [ "$DRY_RUN" == "1" ] && echo -e "${YELLOW}[dry run] commands are printed, not run${NC}"
}

# Check if runtime is installed
function need_runtime() {
    if [ "$DRY_RUN" == "1" ]; then return 0; fi
    if ! command -v "$RUNTIME" >/dev/null 2>&1; then
        echo -e "${RED}✗ '$RUNTIME' not found${NC}"
        echo -e "${YELLOW}Install Docker: https://docs.docker.com/get-docker/${NC}"
        echo -e "${YELLOW}Or use Podman: RUNTIME=podman ./run-mcpd.sh${NC}"
        return 127
    fi
    if ! command -v "$COMPOSE" >/dev/null 2>&1; then
        echo -e "${RED}✗ '$COMPOSE' not found${NC}"
        echo -e "${YELLOW}Install docker-compose or use 'docker compose' (v2)${NC}"
        return 127
    fi
    return 0
}

# Container/service status checks
function containers_running() {
    [ "$DRY_RUN" == "1" ] && return 1
    $COMPOSE -p "$PROJECT_NAME" ps 2>/dev/null | grep -q "Up"
}

function web_up() {
    [ "$DRY_RUN" == "1" ] && return 1
    $RUNTIME exec "$WEB_CONTAINER" python manage.py check >/dev/null 2>&1
}

function confirm() {
    if [ "$ASSUME_YES" == "1" ] || [ "$DRY_RUN" == "1" ]; then return 0; fi
    echo -e "${MAGENTA}WARNING!! $1 Hit return to continue (Ctrl-C to cancel)...${NC}"
    read dummy
}

########
# Setup

function run_setup() {
    header "Checking container runtime                    "
    if ! command -v "$RUNTIME" >/dev/null 2>&1; then
        echo -e "${RED}✗ '$RUNTIME' is not installed${NC}"
        echo -e "  Install Docker:"
        echo -e "   ${CYAN}https://docs.docker.com/get-docker/${NC}"
        echo -e "  Or use Podman:"
        echo -e "   ${CYAN}brew install podman${NC}"
        echo -e "   ${CYAN}RUNTIME=podman COMPOSE=podman-compose ./run-mcpd.sh${NC}"
        return 127
    fi
    echo -e "${GREEN}✓ $RUNTIME found:${NC} $($RUNTIME --version 2>/dev/null | head -1)"

    if ! command -v "$COMPOSE" >/dev/null 2>&1; then
        echo -e "${RED}✗ '$COMPOSE' is not installed${NC}"
        echo -e "  Install docker-compose or use Docker Compose V2 (built-in)"
        return 127
    fi
    echo -e "${GREEN}✓ $COMPOSE found:${NC} $($COMPOSE --version 2>/dev/null | head -1)"

    echo ""
    echo -e "Next steps:"
    echo -e "  ${YELLOW}1. Configure:${NC}   ${CYAN}cd dynamic && cp .env.example .env${NC}  (edit if needed)"
    echo -e "  ${YELLOW}2. Build:${NC}       ${CYAN}./run-mcpd.sh build${NC}"
    echo -e "  ${YELLOW}3. Start:${NC}       ${CYAN}./run-mcpd.sh up${NC}"
    echo -e "  ${YELLOW}4. Migrate:${NC}     ${CYAN}./run-mcpd.sh migrate${NC}"
    echo -e "  ${YELLOW}5. Superuser:${NC}   ${CYAN}./run-mcpd.sh createsuperuser${NC}"
    echo -e "  ${YELLOW}6. Browse:${NC}      ${CYAN}./run-mcpd.sh browser${NC}"
}

########
# Container Management

function run_build() {
    header "Building containers                            "
    need_runtime || return $?
    cd "$SCRIPT_DIR/dynamic"
    run $COMPOSE -p "$PROJECT_NAME" build 2>&1 | tee -a "$LOG/run-build.log"
    local rc=${PIPESTATUS[0]}
    [ $rc -eq 0 ] && ok "Containers built" || echo -e "${RED}✗ Build failed (see $LOG/run-build.log)${NC}"
    return $rc
}

function run_up() {
    header "Starting all services                          "
    need_runtime || return $?
    cd "$SCRIPT_DIR/dynamic"
    run $COMPOSE -p "$PROJECT_NAME" up -d 2>&1 | tee -a "$LOG/run-up.log"
    local rc=${PIPESTATUS[0]}
    if [ $rc -eq 0 ]; then
        ok "Services started"
        echo -e "${CYAN}  Web:   ${YELLOW}${URL}${NC}"
        echo -e "${CYAN}  Admin: ${YELLOW}${URL}admin${NC}"
        echo -e "${CYAN}  Docs:  ${YELLOW}${URL}api/docs/${NC}"
        echo ""
        echo -e "${YELLOW}Run migrations if this is your first start:${NC}"
        echo -e "  ${CYAN}./run-mcpd.sh migrate${NC}"
        echo -e "  ${CYAN}./run-mcpd.sh createsuperuser${NC}"
    else
        echo -e "${RED}✗ Failed to start services (see $LOG/run-up.log)${NC}"
    fi
    return $rc
}

function run_down() {
    header "Stopping all services                          "
    need_runtime || return $?
    cd "$SCRIPT_DIR/dynamic"
    run $COMPOSE -p "$PROJECT_NAME" down
    ok "Services stopped (volumes preserved)"
}

function run_status() {
    header "Container status                               "
    need_runtime || return $?
    cd "$SCRIPT_DIR/dynamic"
    run $COMPOSE -p "$PROJECT_NAME" ps
}

function run_clean() {
    header "Full reset: removing all containers & volumes  "
    confirm "This will delete ALL containers, volumes, and data!"
    cd "$SCRIPT_DIR/dynamic"
    run $COMPOSE -p "$PROJECT_NAME" down -v
    run_build || return $?
    run_up
}

function run_connect() {
    header "Connecting to web container shell              "
    need_runtime || return $?
    cd "$SCRIPT_DIR/dynamic"
    run $COMPOSE -p "$PROJECT_NAME" exec web /bin/bash
}

########
# Django Commands

function run_migrate() {
    header "Running Django migrations                      "
    need_runtime || return $?
    cd "$SCRIPT_DIR/dynamic"
    run $COMPOSE -p "$PROJECT_NAME" exec web python manage.py migrate
}

function run_makemigrations() {
    header "Creating new migrations                        "
    need_runtime || return $?
    cd "$SCRIPT_DIR/dynamic"
    run $COMPOSE -p "$PROJECT_NAME" exec web python manage.py makemigrations
}

function run_createsuperuser() {
    header "Creating Django superuser                      "
    need_runtime || return $?
    cd "$SCRIPT_DIR/dynamic"
    run $COMPOSE -p "$PROJECT_NAME" exec web python manage.py createsuperuser
}

function run_django_shell() {
    header "Opening Django Python shell                    "
    need_runtime || return $?
    cd "$SCRIPT_DIR/dynamic"
    run $COMPOSE -p "$PROJECT_NAME" exec web python manage.py shell_plus
}

function run_db_shell() {
    header "Opening PostgreSQL shell                       "
    need_runtime || return $?
    cd "$SCRIPT_DIR/dynamic"
    run $COMPOSE -p "$PROJECT_NAME" exec db psql -U postgres -d maiden_crown_db
}

function run_collectstatic() {
    header "Collecting static files                        "
    need_runtime || return $?
    cd "$SCRIPT_DIR/dynamic"
    run $COMPOSE -p "$PROJECT_NAME" exec web python manage.py collectstatic --noinput
}

function run_flush() {
    header "Flushing database (DELETE ALL DATA)            "
    confirm "This will DELETE ALL DATA from the database!"
    cd "$SCRIPT_DIR/dynamic"
    run $COMPOSE -p "$PROJECT_NAME" exec web python manage.py flush --noinput
}

########
# Application

function run_logs_web() {
    header "Following Django logs (Ctrl-C to stop)         "
    need_runtime || return $?
    cd "$SCRIPT_DIR/dynamic"
    run $COMPOSE -p "$PROJECT_NAME" logs -f web
}

function run_logs_db() {
    header "Following PostgreSQL logs (Ctrl-C to stop)     "
    need_runtime || return $?
    cd "$SCRIPT_DIR/dynamic"
    run $COMPOSE -p "$PROJECT_NAME" logs -f db
}

function run_logs_all() {
    header "Following all logs (Ctrl-C to stop)            "
    need_runtime || return $?
    cd "$SCRIPT_DIR/dynamic"
    run $COMPOSE -p "$PROJECT_NAME" logs -f
}

function open_browser() {
    header "Opening browser to Django app                  "
    if [ "$DRY_RUN" == "1" ]; then run open "$URL"; return 0; fi

    echo -e "${CYAN}Target URL: ${YELLOW}${URL}${NC}"
    open "$URL"
    ok "Browser opened"
}

function open_admin() {
    header "Opening browser to Django admin                "
    if [ "$DRY_RUN" == "1" ]; then run open "${URL}admin"; return 0; fi

    echo -e "${CYAN}Target URL: ${YELLOW}${URL}admin${NC}"
    open "${URL}admin"
    ok "Admin panel opened"
}

function open_api_docs() {
    header "Opening browser to API documentation           "
    if [ "$DRY_RUN" == "1" ]; then run open "${URL}api/docs/"; return 0; fi

    echo -e "${CYAN}Target URL: ${YELLOW}${URL}api/docs/${NC}"
    open "${URL}api/docs/"
    ok "API docs opened"
}

########
# Testing & Quality

function run_tests() {
    header "Running test suite                             "
    need_runtime || return $?
    cd "$SCRIPT_DIR/dynamic"
    local logfile="$LOG/run-tests.log"
    [ "$DEBUG" == "true" ] && logfile="$LOG/run-tests-${DATE}.log"

    run $COMPOSE -p "$PROJECT_NAME" exec web pytest 2>&1 | tee -a "$logfile"
    local rc=${PIPESTATUS[0]}
    [ $rc -eq 0 ] && ok "Tests passed" || echo -e "${RED}✗ Tests failed (see $logfile)${NC}"
    return $rc
}

function run_coverage() {
    header "Running tests with coverage                    "
    need_runtime || return $?
    cd "$SCRIPT_DIR/dynamic"
    run $COMPOSE -p "$PROJECT_NAME" exec web coverage run -m pytest
    run $COMPOSE -p "$PROJECT_NAME" exec web coverage report
    ok "Coverage report generated"
}

function run_lint() {
    header "Running code quality checks                    "
    need_runtime || return $?
    cd "$SCRIPT_DIR/dynamic"
    echo -e "${CYAN}Running flake8...${NC}"
    run $COMPOSE -p "$PROJECT_NAME" exec web flake8 .
    echo -e "${CYAN}Running black check...${NC}"
    run $COMPOSE -p "$PROJECT_NAME" exec web black --check .
    echo -e "${CYAN}Running isort check...${NC}"
    run $COMPOSE -p "$PROJECT_NAME" exec web isort --check .
    ok "Linting complete"
}

function run_format() {
    header "Auto-formatting code                           "
    need_runtime || return $?
    cd "$SCRIPT_DIR/dynamic"
    run $COMPOSE -p "$PROJECT_NAME" exec web black .
    run $COMPOSE -p "$PROJECT_NAME" exec web isort .
    ok "Code formatted"
}

########
# Data Management

function run_load_fixtures() {
    header "Loading sample data                            "
    need_runtime || return $?
    cd "$SCRIPT_DIR/dynamic"
    run $COMPOSE -p "$PROJECT_NAME" exec web python manage.py loaddata fixtures/initial_data.json
    ok "Fixtures loaded"
}

function run_dump_db() {
    header "Dumping database to JSON                       "
    need_runtime || return $?
    cd "$SCRIPT_DIR/dynamic"
    local dump_file="backup_$(date +%Y%m%d_%H%M%S).json"
    run $COMPOSE -p "$PROJECT_NAME" exec web python manage.py dumpdata > "$dump_file"
    ok "Database dumped to $dump_file"
}

function run_backup_volumes() {
    header "Backing up Docker volumes                      "
    need_runtime || return $?
    echo -e "${YELLOW}Not yet implemented${NC}"
}

function run_restore_volumes() {
    header "Restoring Docker volumes                       "
    need_runtime || return $?
    echo -e "${YELLOW}Not yet implemented${NC}"
}

########
# Help

function show_help() {
    show_banner
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  Setup:"
    echo "  setup               Check Docker/Podman installation"
    echo ""
    echo "  Container Management:"
    echo "  build               Build all containers"
    echo "  up                  Start all services (Django + PostgreSQL + Redis)"
    echo "  down                Stop all services"
    echo "  status              Show container status"
    echo "  clean               Full reset (stop, remove, rebuild)"
    echo "  connect             Open bash shell in web container"
    echo ""
    echo "  Django Commands:"
    echo "  migrate             Run database migrations"
    echo "  makemigrations      Create new migrations"
    echo "  createsuperuser     Create Django admin user"
    echo "  shell               Open Django Python shell"
    echo "  dbshell             Open PostgreSQL shell"
    echo "  collectstatic       Collect static files"
    echo "  flush               Delete all database data"
    echo ""
    echo "  Application:"
    echo "  logs:web            Follow Django logs"
    echo "  logs:db             Follow PostgreSQL logs"
    echo "  logs:all            Follow all service logs"
    echo "  browser             Open app in browser"
    echo "  admin               Open Django admin"
    echo "  docs                Open API documentation"
    echo ""
    echo "  Testing & Quality:"
    echo "  test                Run pytest test suite"
    echo "  coverage            Run tests with coverage"
    echo "  lint                Check code quality"
    echo "  format              Auto-format code"
    echo ""
    echo "  Data:"
    echo "  loaddata            Load sample fixtures"
    echo "  dumpdata            Export database to JSON"
    echo ""
    echo "  help                Show this help message"
    echo ""
    echo "Environment: RUNTIME, COMPOSE, PROJECT_NAME, PORT, DEBUG, DRY_RUN, ASSUME_YES"
    echo "If no command is provided, an interactive menu will be shown."
}

############
# Main

function main() {
    # Handle command-line arguments
    if [[ $# -gt 0 ]]; then
        case "$1" in
            setup)                       run_setup; exit $? ;;
            build)                       run_build; exit $? ;;
            up)                          run_up; exit $? ;;
            down)                        run_down; exit $? ;;
            status)                      run_status; exit $? ;;
            clean)                       run_clean; exit $? ;;
            connect|shell:bash)          run_connect; exit $? ;;
            migrate)                     run_migrate; exit $? ;;
            makemigrations)              run_makemigrations; exit $? ;;
            createsuperuser)             run_createsuperuser; exit $? ;;
            shell|shell:django)          run_django_shell; exit $? ;;
            dbshell|shell:db)            run_db_shell; exit $? ;;
            collectstatic)               run_collectstatic; exit $? ;;
            flush)                       run_flush; exit $? ;;
            logs:web)                    run_logs_web; exit $? ;;
            logs:db)                     run_logs_db; exit $? ;;
            logs:all|logs)               run_logs_all; exit $? ;;
            browser)                     open_browser; exit $? ;;
            admin)                       open_admin; exit $? ;;
            docs)                        open_api_docs; exit $? ;;
            test)                        run_tests; exit $? ;;
            coverage)                    run_coverage; exit $? ;;
            lint)                        run_lint; exit $? ;;
            format)                      run_format; exit $? ;;
            loaddata)                    run_load_fixtures; exit $? ;;
            dumpdata)                    run_dump_db; exit $? ;;
            help|--help|-h)              show_help; exit 0 ;;
            *)
                echo -e "${RED}Error: Unknown command '$1'${NC}"
                echo "Run '$0 help' for usage information."
                exit 1
                ;;
        esac
    fi

    ####
    # Interactive menu
    show_banner

    while true; do
        show_menu
        read -p "Select a command: " choice
        echo ""

        case $choice in
            0)  run_setup ;;
            1)  run_build ;;
            2)  run_up ;;
            3)  run_connect ;;
            4)  run_status ;;
            5)  run_down ;;
            6)  run_clean ;;
            7)  run_migrate ;;
            8)  run_makemigrations ;;
            9)  run_createsuperuser ;;
            10) run_django_shell ;;
            11) run_db_shell ;;
            12) run_collectstatic ;;
            13) run_flush ;;
            14) run_logs_web ;;
            15) run_logs_db ;;
            16) run_logs_all ;;
            17) open_browser ;;
            18) open_admin ;;
            19) open_api_docs ;;
            20) run_tests ;;
            21) run_coverage ;;
            22) run_lint ;;
            23) run_format ;;
            24) run_load_fixtures ;;
            25) run_dump_db ;;
            26) run_backup_volumes ;;
            27) run_restore_volumes ;;
            d|D) toggle_debug ;;
            q|Q)
                echo -e "${GREEN}Goodbye! The records endure.${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid option${NC}"
                ;;
        esac
        echo ""
    done
}

main "$@"
