#!/bin/bash
#
# Add New Skill Script
# Creates a new Agent Skill with proper structure and updates manifest
#
# Usage:
#   ./add_new_skill.sh <category> <skill-name> [--template basic|advanced]
#
# Examples:
#   ./add_new_skill.sh backend api-caching
#   ./add_new_skill.sh frontend react-hooks --template advanced
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

# Valid categories
VALID_CATEGORIES=(
    "backend"
    "frontend"
    "code-quality"
    "infrastructure"
    "documentation"
    "project-management"
    "search-analysis"
    "utilities"
)

# Show usage
usage() {
    echo "Add New Skill Script"
    echo ""
    echo "Usage: $0 <category> <skill-name> [options]"
    echo ""
    echo "Categories:"
    for cat in "${VALID_CATEGORIES[@]}"; do
        echo "  - $cat"
    done
    echo ""
    echo "Options:"
    echo "  --template <type>  Template type: basic (default), advanced"
    echo "  --description <d>  Short description for the skill"
    echo "  --tools <tools>    Comma-separated allowed tools"
    echo "  --help             Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 backend api-caching"
    echo "  $0 frontend react-hooks --template advanced"
    echo "  $0 backend graphql-api --description 'Design GraphQL APIs' --tools 'Read,Write'"
    echo ""
    exit 1
}

# Validate category
validate_category() {
    local category="$1"
    for valid in "${VALID_CATEGORIES[@]}"; do
        if [ "$valid" = "$category" ]; then
            return 0
        fi
    done
    return 1
}

# Validate skill name
validate_skill_name() {
    local name="$1"
    # lowercase, hyphens, max 64 chars
    if [[ ! "$name" =~ ^[a-z][a-z0-9-]*$ ]]; then
        return 1
    fi
    if [ ${#name} -gt 64 ]; then
        return 1
    fi
    return 0
}

# Create basic skill template
create_basic_skill() {
    local skill_path="$1"
    local skill_name="$2"
    local description="$3"
    local tools="$4"

    cat > "$skill_path/SKILL.md" << EOF
---
name: $skill_name
description: "$description"
tags: [${skill_name//-/, }]
platforms: [Claude, ChatGPT, Gemini]
EOF

    if [ -n "$tools" ]; then
        echo "allowed-tools: [$tools]" >> "$skill_path/SKILL.md"
    fi

    cat >> "$skill_path/SKILL.md" << 'EOF'
---

# Skill Name

## When to use this skill

- Use case 1
- Use case 2
- Use case 3

## Instructions

### Step 1: Understand the requirement
- Analyze the user's request
- Identify key requirements

### Step 2: Execute the task
- Follow the procedure
- Apply best practices

### Step 3: Validate and deliver
- Review the output
- Ensure quality

## Examples

### Example 1: Basic usage

```
// Example code or output here
```

### Example 2: Advanced usage

```
// More complex example
```

## Best practices

1. Practice 1
2. Practice 2
3. Practice 3

## References

- [Reference 1](https://example.com)
- [Reference 2](https://example.com)
EOF

    print_success "Created SKILL.md"
}

# Create advanced skill template
create_advanced_skill() {
    local skill_path="$1"
    local skill_name="$2"
    local description="$3"
    local tools="$4"

    # Create main SKILL.md
    cat > "$skill_path/SKILL.md" << EOF
---
name: $skill_name
description: "$description"
tags: [${skill_name//-/, }]
platforms: [Claude, ChatGPT, Gemini]
version: "1.0.0"
EOF

    if [ -n "$tools" ]; then
        echo "allowed-tools: [$tools]" >> "$skill_path/SKILL.md"
    fi

    cat >> "$skill_path/SKILL.md" << 'EOF'
---

# Skill Name

## Overview

Brief overview of what this skill does.

## When to use this skill

- Use case 1
- Use case 2
- Use case 3

## Prerequisites

- Prerequisite 1
- Prerequisite 2

## Instructions

### Phase 1: Analysis

1. Step 1
2. Step 2

### Phase 2: Implementation

1. Step 1
2. Step 2

### Phase 3: Validation

1. Step 1
2. Step 2

## Examples

### Example 1: Basic usage

```
// Example code
```

### Example 2: Advanced usage

```
// Complex example
```

## Best practices

1. Practice 1
2. Practice 2

## Anti-patterns

1. Avoid doing X
2. Don't do Y

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Problem 1 | Fix 1 |
| Problem 2 | Fix 2 |

## References

- See REFERENCE.md for detailed documentation
- See EXAMPLES.md for more examples
EOF

    print_success "Created SKILL.md"

    # Create REFERENCE.md
    cat > "$skill_path/REFERENCE.md" << EOF
# $skill_name Reference

Detailed reference documentation for the $skill_name skill.

## API Reference

### Function 1

\`\`\`
function_name(param1, param2)
\`\`\`

**Parameters:**
- \`param1\`: Description
- \`param2\`: Description

**Returns:** Description

## Configuration

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| option1 | string | "" | Description |
| option2 | number | 0 | Description |

## Error Codes

| Code | Message | Solution |
|------|---------|----------|
| E001 | Error 1 | Fix 1 |
| E002 | Error 2 | Fix 2 |
EOF

    print_success "Created REFERENCE.md"

    # Create EXAMPLES.md
    cat > "$skill_path/EXAMPLES.md" << EOF
# $skill_name Examples

Additional examples for the $skill_name skill.

## Example 1: Basic

\`\`\`
// Basic example code
\`\`\`

## Example 2: Intermediate

\`\`\`
// Intermediate example code
\`\`\`

## Example 3: Advanced

\`\`\`
// Advanced example code
\`\`\`
EOF

    print_success "Created EXAMPLES.md"

    # Create scripts directory
    mkdir -p "$skill_path/scripts"
    cat > "$skill_path/scripts/helper.sh" << 'EOF'
#!/bin/bash
# Helper script for this skill
echo "Helper script placeholder"
EOF
    chmod +x "$skill_path/scripts/helper.sh"
    print_success "Created scripts/helper.sh"

    # Create templates directory
    mkdir -p "$skill_path/templates"
    touch "$skill_path/templates/.gitkeep"
    print_success "Created templates/"
}

# Update manifest
update_manifest() {
    local skill_path="$1"
    print_info "Updating skill manifest..."

    if [ -f "$SKILLS_DIR/scripts/skill_manifest_builder.py" ]; then
        python3 "$SKILLS_DIR/scripts/skill_manifest_builder.py"
        print_success "Manifest updated"
    else
        print_warn "Manifest builder not found, skipping"
    fi

    # Also generate TOON format if converter exists
    if [ -f "$SKILLS_DIR/scripts/toon_converter.py" ]; then
        print_info "Generating TOON format..."
        python3 "$SKILLS_DIR/scripts/toon_converter.py" convert-all
        print_success "TOON format generated"
    fi
}

# Main
main() {
    if [ $# -lt 2 ]; then
        usage
    fi

    local category="$1"
    local skill_name="$2"
    shift 2

    # Parse options
    local template="basic"
    local description="$skill_name skill"
    local tools=""

    while [ $# -gt 0 ]; do
        case "$1" in
            --template)
                template="$2"
                shift 2
                ;;
            --description)
                description="$2"
                shift 2
                ;;
            --tools)
                tools="$2"
                shift 2
                ;;
            --help)
                usage
                ;;
            *)
                print_error "Unknown option: $1"
                usage
                ;;
        esac
    done

    # Validate inputs
    if ! validate_category "$category"; then
        print_error "Invalid category: $category"
        echo "Valid categories: ${VALID_CATEGORIES[*]}"
        exit 1
    fi

    if ! validate_skill_name "$skill_name"; then
        print_error "Invalid skill name: $skill_name"
        echo "Skill names must be lowercase, start with a letter, use hyphens, max 64 chars"
        exit 1
    fi

    # Check if skill already exists
    local skill_path="$SKILLS_DIR/$category/$skill_name"
    if [ -d "$skill_path" ]; then
        print_error "Skill already exists: $skill_path"
        exit 1
    fi

    # Create skill
    print_info "Creating new skill: $category/$skill_name"
    echo ""

    mkdir -p "$skill_path"
    print_success "Created directory: $skill_path"

    case "$template" in
        basic)
            create_basic_skill "$skill_path" "$skill_name" "$description" "$tools"
            ;;
        advanced)
            create_advanced_skill "$skill_path" "$skill_name" "$description" "$tools"
            ;;
        *)
            print_error "Unknown template: $template"
            exit 1
            ;;
    esac

    # Update manifest
    echo ""
    update_manifest "$skill_path"

    echo ""
    print_success "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    print_success "New skill created successfully!"
    print_success "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Location: $skill_path"
    echo ""
    echo "Next steps:"
    echo "  1. Edit $skill_path/SKILL.md"
    echo "  2. Update description, instructions, and examples"
    echo "  3. Run setup.sh to deploy to AI platforms"
    echo ""
}

main "$@"
