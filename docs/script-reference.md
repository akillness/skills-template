# Script Reference

## Overview

Below is a compact reference for scripts under `agentskills/scripts`.

---

## Core Scripts

| File | Purpose | Usage |
|---|---|---|
| `scripts/pipeline-check.sh` | Preflight environment check | `bash scripts/pipeline-check.sh --agents=claude,codex` |
| `scripts/conductor.sh` | Create/run parallel agent worktrees | `bash scripts/conductor.sh <feature-name> [base-branch] [agents]` |
| `scripts/conductor-pr.sh` | Commit/push PRs from each worktree | `bash scripts/conductor-pr.sh <feature-name> [base-branch]` |
| `scripts/conductor-cleanup.sh` | Remove worktrees and tmux sessions | `bash scripts/conductor-cleanup.sh <feature-name>` |
| `scripts/pipeline.sh` | Run full pipeline (`check -> conductor -> pr`) | `bash scripts/pipeline.sh <feature-name> [options]` |
| `scripts/copilot-setup-workflow.sh` | Initialize Copilot workflow/secret/labels | `bash scripts/copilot-setup-workflow.sh` |
| `scripts/copilot-assign-issue.sh` | Assign a GitHub issue to Copilot | `bash scripts/copilot-assign-issue.sh <issue-number>` |
| `scripts/vibe-kanban-start.sh` | Start Vibe Kanban UI | `bash scripts/vibe-kanban-start.sh [--port 3000] [--remote]` |
| `scripts/conductor-planno.sh` | Optional planno plan review step | `bash scripts/conductor-planno.sh <feature-name> <base-branch> <agents>` |

---

## Pipeline Options (`scripts/pipeline.sh`)

| Option | Description |
|---|---|
| `--base <branch>` | Base branch (default `main`) |
| `--agents <list>` | Agent list (comma-separated) |
| `--stages <list>` | Execution stages: `check,plan,conductor,pr,copilot` |
| `--no-attach` | Do not automatically attach tmux |
| `--dry-run` | Show command plan only |
| `--resume` | Resume from last failed stage |

---

## Hooks

Default hook path: `scripts/hooks/`

- `pre-conductor.sh`: fails pipeline before execution
- `post-conductor.sh`: warning only if fails

You can disable all hooks with:

```bash
CONDUCTOR_SKIP_HOOKS=1
```

Use a custom directory with:

```bash
CONDUCTOR_HOOKS_DIR=<custom-dir>
```

---

## Common Outputs

- Worktree: `trees/feat-<name>-<agent>`
- Branch: `feat/<name>-<agent>`
- Pipeline state: `.conductor-pipeline-state.json`
