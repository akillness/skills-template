#!/bin/bash
# MCP Skill Loader Helper Script
# Usage: source mcp-skill-loader.sh

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export AGENT_SKILLS_PATH="$SCRIPT_DIR"

# Function to load a skill
load_skill() {
    local skill_path="$1"
    local full_path="$AGENT_SKILLS_PATH/$skill_path/SKILL.md"

    if [ -f "$full_path" ]; then
        cat "$full_path"
    else
        echo "Error: Skill not found at $full_path" >&2
        return 1
    fi
}

# Function to list available skills
list_skills() {
    echo "Available Skills:"
    echo ""
    find "$AGENT_SKILLS_PATH" -name "SKILL.md" -type f | while read -r skill; do
        local rel_path="${skill#$AGENT_SKILLS_PATH/}"
        local skill_dir="$(dirname "$rel_path")"
        echo "  - $skill_dir"
    done
}

# Function to load skill with context
load_skill_with_context() {
    local skill_path="$1"
    cat "$AGENT_SKILLS_PATH/MCP_CONTEXT.md"
    echo ""
    echo "---"
    echo ""
    load_skill "$skill_path"
}

# Function to search skills by keyword
search_skills() {
    local keyword="$1"
    echo "Searching for skills matching '$keyword':"
    echo ""
    grep -r -l "$keyword" "$AGENT_SKILLS_PATH"/*/*/SKILL.md 2>/dev/null | while read -r skill; do
        local rel_path="${skill#$AGENT_SKILLS_PATH/}"
        local skill_dir="$(dirname "$rel_path")"
        echo "  - $skill_dir"
    done
}

# Function to execute skill via codex-cli (Claude integration pattern)
execute_skill_codex() {
    local skill_path="$1"
    local action="$2"
    shift 2
    local args=("$@")

    echo "=== Claude + Codex-CLI Integration ==="
    echo "Skill: $skill_path"
    echo "Action: $action"
    echo ""

    # Execute using codex_skill_executor.sh
    local executor="$AGENT_SKILLS_PATH/scripts/codex_skill_executor.sh"
    if [ -f "$executor" ]; then
        bash "$executor" "$skill_path" "$action" "${args[@]}"
    else
        echo "Error: codex_skill_executor.sh not found"
        return 1
    fi
}

# Function to show skill manifest
show_manifest() {
    local manifest="$AGENT_SKILLS_PATH/skills.json"
    if [ -f "$manifest" ]; then
        cat "$manifest"
    else
        echo "Manifest not found. Run: python3 scripts/skill_manifest_builder.py"
    fi
}

# Function to build skill manifest
build_manifest() {
    python3 "$AGENT_SKILLS_PATH/scripts/skill_manifest_builder.py"
}

# Export functions
export -f load_skill
export -f list_skills
export -f load_skill_with_context
export -f search_skills
export -f execute_skill_codex
export -f show_manifest
export -f build_manifest

# Print usage if called directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    echo "MCP Skill Loader (with Codex Integration)"
    echo "=========================================="
    echo ""
    echo "Usage: source mcp-skill-loader.sh"
    echo ""
    echo "Core Functions:"
    echo "  load_skill <category>/<skill-name>        - Load a specific skill"
    echo "  load_skill_with_context <category>/<skill> - Load skill with MCP context"
    echo "  list_skills                                - List all available skills"
    echo "  search_skills <keyword>                    - Search skills by keyword"
    echo ""
    echo "Codex Integration Functions:"
    echo "  execute_skill_codex <skill> <action>      - Execute skill action via codex"
    echo "  show_manifest                              - Show skills.json manifest"
    echo "  build_manifest                             - Rebuild skill manifest"
    echo ""
    echo "Examples:"
    echo "  load_skill backend/api-design"
    echo "  execute_skill_codex infrastructure/system-environment-setup docker-up"
    echo "  search_skills 'REST API'"
fi
