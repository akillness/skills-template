# CLI Reference

## Overview

Below is a compact reference for CLI tools under `.agent-skills/`.

---

## Skill Loader (`skill_loader.py`)

| Command | Purpose | Usage |
|---|---|---|
| `list` | List all available skills | `python3 skill_loader.py list` |
| `search` | Search skills by keyword | `python3 skill_loader.py search "api"` |
| `show` | Show details of a specific skill | `python3 skill_loader.py show api-design` |

---

## Skill Query Handler (`skill-query-handler.py`)

| Command | Purpose | Usage |
|---|---|---|
| `list` | List all skills | `python3 skill-query-handler.py list` |
| `match` | Find skills matching a query | `python3 skill-query-handler.py match "REST API"` |
| `query` | Generate skill prompt (TOON format default) | `python3 skill-query-handler.py query "API design"` |
| `stats` | View skill statistics | `python3 skill-query-handler.py stats` |

### Query Options

| Option | Description |
|---|---|
| `--mode toon` | Use TOON format (default, 95% token reduction) |
| `--mode full` | Use full SKILL.md content |

---

## Output Formats

### TOON Format

Compact representation with ~95% token reduction:

```
N:skill-name
D:Skill description
G:keyword1 keyword2

U[N]: Use cases
S[N]: Steps
R[N]: Rules/Best practices
```

### Full Format

Complete SKILL.md content with all sections and examples.

---

## Common Usage Patterns

```bash
# Quick skill discovery
python3 .agent-skills/skill_loader.py search "testing"

# Get skill prompt for AI agent
python3 .agent-skills/skill-query-handler.py query "code review"

# Full documentation when needed
python3 .agent-skills/skill-query-handler.py query "authentication" --mode full
```

---

**Updated**: 2026-02-21
