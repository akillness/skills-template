#!/bin/bash
# Agent Skills MCP Integration (Auto-detect path)

if [ -n "$BASH_SOURCE" ]; then
    _MCP_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
elif [ -n "$ZSH_VERSION" ]; then
    _MCP_SCRIPT_DIR="$(cd "$(dirname "${(%):-%x}")" && pwd)"
else
    _MCP_SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
fi

export AGENT_SKILLS_PATH="$_MCP_SCRIPT_DIR"

# Load helper functions
[ -f "$AGENT_SKILLS_PATH/mcp-skill-loader.sh" ] && source "$AGENT_SKILLS_PATH/mcp-skill-loader.sh"

# Aliases
alias skill-list='python3 "$AGENT_SKILLS_PATH/skill-query-handler.py" list'
alias skill-match='python3 "$AGENT_SKILLS_PATH/skill-query-handler.py" match'
alias skill-query='python3 "$AGENT_SKILLS_PATH/skill-query-handler.py" query'
alias skill-stats='python3 "$AGENT_SKILLS_PATH/skill-query-handler.py" stats'

# Token mode aliases
alias skill-query-toon='python3 "$AGENT_SKILLS_PATH/skill-query-handler.py" query --mode toon'
alias skill-query-compact='python3 "$AGENT_SKILLS_PATH/skill-query-handler.py" query --mode compact'
alias skill-query-full='python3 "$AGENT_SKILLS_PATH/skill-query-handler.py" query --mode full'

# MCP functions (default: toon mode for minimal tokens)
gemini-skill() {
    local query="$1"
    local mode="${2:-toon}"
    python3 "$AGENT_SKILLS_PATH/skill-query-handler.py" query "$query" --tool gemini --mode "$mode" 2>/dev/null || echo "No matching skill for: $query"
}

codex-skill() {
    local query="$1"
    local mode="${2:-toon}"
    python3 "$AGENT_SKILLS_PATH/skill-query-handler.py" query "$query" --tool codex --mode "$mode" 2>/dev/null || echo "No matching skill for: $query"
}

export -f gemini-skill codex-skill
unset _MCP_SCRIPT_DIR
