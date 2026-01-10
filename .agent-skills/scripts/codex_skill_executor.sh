#!/bin/bash
#
# Codex Skill Executor
# Claude + Codex-CLI 통합 스킬 실행기
#
# Usage:
#   ./codex_skill_executor.sh <skill_path> <action> [args...]
#
# Examples:
#   ./codex_skill_executor.sh infrastructure/system-environment-setup docker-up
#   ./codex_skill_executor.sh code-quality/code-review lint
#   ./codex_skill_executor.sh backend/api-design generate
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$(dirname "$SCRIPT_DIR")"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[OK]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }
print_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

# Show usage
usage() {
    echo "Codex Skill Executor - Claude + Codex-CLI Integration"
    echo ""
    echo "Usage: $0 <skill_path> <action> [args...]"
    echo ""
    echo "Actions:"
    echo "  info       - Show skill information"
    echo "  commands   - List available commands from skill"
    echo "  exec       - Execute a specific command"
    echo "  docker-up  - Start Docker services"
    echo "  docker-down - Stop Docker services"
    echo "  lint       - Run linter"
    echo "  test       - Run tests"
    echo "  build      - Run build"
    echo ""
    echo "Examples:"
    echo "  $0 infrastructure/system-environment-setup info"
    echo "  $0 infrastructure/system-environment-setup docker-up"
    echo "  $0 code-quality/code-review lint"
    echo ""
    exit 1
}

# Load skill content
load_skill() {
    local skill_path="$1"
    local full_path="$SKILLS_DIR/$skill_path/SKILL.md"

    if [ ! -f "$full_path" ]; then
        print_error "Skill not found: $full_path"
        exit 1
    fi

    cat "$full_path"
}

# Extract skill metadata
get_skill_name() {
    local content="$1"
    echo "$content" | grep -E "^name:" | head -1 | cut -d':' -f2 | tr -d ' '
}

get_skill_description() {
    local content="$1"
    echo "$content" | grep -E "^description:" | head -1 | cut -d':' -f2-
}

# Show skill info
show_info() {
    local skill_path="$1"
    local content
    content=$(load_skill "$skill_path")

    echo ""
    echo "=== Skill Information ==="
    echo "Path: $skill_path"
    echo "Name: $(get_skill_name "$content")"
    echo "Description: $(get_skill_description "$content")"
    echo ""
}

# List commands from skill
list_commands() {
    local skill_path="$1"
    local content
    content=$(load_skill "$skill_path")

    echo ""
    echo "=== Available Commands ==="
    echo "$content" | grep -E "^\s*(docker-compose|make|npm|git|terraform|kubectl)" | head -20
    echo ""
}

# Execute predefined actions
execute_action() {
    local skill_path="$1"
    local action="$2"
    shift 2
    local args=("$@")

    print_info "Executing action: $action for skill: $skill_path"

    case "$action" in
        docker-up)
            print_info "Starting Docker services..."
            docker-compose up -d
            docker-compose ps
            ;;
        docker-down)
            print_info "Stopping Docker services..."
            docker-compose down
            ;;
        docker-logs)
            print_info "Showing Docker logs..."
            docker-compose logs -f --tail=100
            ;;
        lint)
            print_info "Running linter..."
            if [ -f "package.json" ]; then
                npm run lint 2>/dev/null || npx eslint . 2>/dev/null || echo "No linter configured"
            elif [ -f "pyproject.toml" ] || [ -f "setup.py" ]; then
                python -m flake8 . 2>/dev/null || python -m pylint . 2>/dev/null || echo "No linter configured"
            fi
            ;;
        test)
            print_info "Running tests..."
            if [ -f "package.json" ]; then
                npm test
            elif [ -f "pyproject.toml" ] || [ -f "setup.py" ]; then
                python -m pytest
            elif [ -f "Makefile" ]; then
                make test
            fi
            ;;
        build)
            print_info "Running build..."
            if [ -f "package.json" ]; then
                npm run build
            elif [ -f "Makefile" ]; then
                make build
            fi
            ;;
        install)
            print_info "Installing dependencies..."
            if [ -f "package.json" ]; then
                npm install
            elif [ -f "requirements.txt" ]; then
                pip install -r requirements.txt
            elif [ -f "Makefile" ]; then
                make install
            fi
            ;;
        exec)
            # Execute custom command
            if [ ${#args[@]} -gt 0 ]; then
                print_info "Executing: ${args[*]}"
                "${args[@]}"
            else
                print_error "No command provided for exec action"
                exit 1
            fi
            ;;
        *)
            print_error "Unknown action: $action"
            usage
            ;;
    esac

    print_success "Action completed: $action"
}

# Main
main() {
    if [ $# -lt 2 ]; then
        usage
    fi

    local skill_path="$1"
    local action="$2"
    shift 2

    case "$action" in
        info)
            show_info "$skill_path"
            ;;
        commands)
            list_commands "$skill_path"
            ;;
        *)
            execute_action "$skill_path" "$action" "$@"
            ;;
    esac
}

main "$@"
