# Usage Guide

## Overview

This document describes the operational flow after installing `agentskills`, with practical command examples for daily workflows.

---

## A. Conductor Pattern (Parallel Agents)

### 1) Preflight Check

```bash
bash scripts/pipeline-check.sh --agents=claude,codex
```

Mandatory tools:

- `git` + `git worktree`
- `tmux`
- `gh` (when creating PRs)
- At least one CLI: `claude`, `codex`, `gemini`

---

### 2) Run Conductor

```bash
bash scripts/conductor.sh <feature-name> <base-branch> <agent-list>
# example
bash scripts/conductor.sh user-dashboard main claude,codex
```

Rules:

- worktree: `trees/feat-<feature>-<agent>`
- branch: `feat/<feature>-<agent>`
- default agents: `claude,codex`

---

### 3) Create PRs

```bash
bash scripts/conductor-pr.sh <feature-name> <base-branch>
# example
bash scripts/conductor-pr.sh user-dashboard main
```

---

### 4) Cleanup

```bash
bash scripts/conductor-cleanup.sh <feature-name>
# example
bash scripts/conductor-cleanup.sh user-dashboard
```

---

## B. Unified Pipeline

```bash
bash scripts/pipeline.sh <feature-name> --stages check,conductor,pr
bash scripts/pipeline.sh <feature-name> --stages check,plan,conductor,pr
bash scripts/pipeline.sh <feature-name> --dry-run
```

Main options:

- `--base <branch>`: default `main`
- `--agents <claude,codex,...>`: comma-separated agent list
- `--stages <check,plan,conductor,pr,copilot>`
- `--no-attach`: disable tmux attach in non-interactive runs
- `--resume`: continue from last failed stage
- `--dry-run`: preview plan without executing

---

## C. Hook Behavior

Hooks use the default directory `scripts/hooks/`.

- `pre-conductor.sh` (fail-stop)
- `post-conductor.sh` (warn-only)

You can add `pre-pr` and `post-pr` using the same hook naming pattern.

```bash
# Skip all hooks
CONDUCTOR_SKIP_HOOKS=1 bash scripts/pipeline.sh <feature-name> --stages check,conductor,pr

# Use a custom hooks directory
CONDUCTOR_HOOKS_DIR=/path/to/hooks bash scripts/pipeline.sh <feature-name> --stages check,conductor,pr
```

---

## D. Copilot Coding Agent Integration

```bash
bash scripts/copilot-setup-workflow.sh
bash scripts/copilot-assign-issue.sh <issue-number>
```

- `copilot-setup-workflow.sh`: initializes workflow, secrets, and labels.
- `copilot-assign-issue.sh`: assigns an existing GitHub issue directly.

---

## E. Vibe Kanban

```bash
bash scripts/vibe-kanban-start.sh
bash scripts/vibe-kanban-start.sh --port 3001
bash scripts/vibe-kanban-start.sh --remote
```

Use it as a UI-based alternative to parallel workflow operations.

---

## F. Recommended Daily Flow

1. Run `pipeline-check.sh` before starting.
2. Run `pipeline.sh` with `check,conductor,pr`.
3. Run `conductor-cleanup.sh` after completion.
4. Validate with `git worktree list` and `git status`.
