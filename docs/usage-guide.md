# Usage Guide

## Overview

This document describes the operational flow after installing `agentskills`, with practical command examples for daily workflows.

---

## A. Skill Query & Discovery

### 1) List All Skills

```bash
python3 .agent-skills/skill_loader.py list
```

### 2) Search Skills

```bash
python3 .agent-skills/skill_loader.py search "api"
python3 .agent-skills/skill_loader.py search "testing"
```

### 3) Query Skills (TOON format)

```bash
python3 .agent-skills/skill-query-handler.py query "REST API design"
python3 .agent-skills/skill-query-handler.py query "code review" --mode full
```

---

## B. Multi-Agent Orchestration

### OMC (oh-my-claudecode)

Teams-first multi-agent orchestration layer for Claude Code.

```bash
# Load the omc skill
npx skills add https://github.com/akillness/skills-template --skill omc
```

See [OMC docs](omc/README.md) for full usage.

### oh-my-codex

Multi-agent orchestration for OpenAI Codex CLI.

```bash
# Load the oh-my-codex skill
npx skills add https://github.com/akillness/skills-template --skill oh-my-codex
```

---

## C. Ralph Loop (Self-Referential Agent)

Self-referential completion loop for multi-turn agent tasks.

```bash
# Load the ralph skill
npx skills add https://github.com/akillness/skills-template --skill ralph
```

See [Ralph docs](ralph/README.md) for full usage.

---

## D. Vibe Kanban

Kanban board for AI coding agents with git worktree automation.

```bash
# Load the vibe-kanban skill
npx skills add https://github.com/akillness/skills-template --skill vibe-kanban
```

See [Vibe Kanban docs](vibe-kanban/README.md) for full usage.

---

## E. Plannotator

Visual plan and diff review for AI coding agents.

```bash
# Load the plannotator skill
npx skills add https://github.com/akillness/skills-template --skill plannotator
```

See [Plannotator docs](plannotator/README.md) for full usage.

---

## F. Recommended Daily Flow

1. Query skills to find the right tool: `python3 .agent-skills/skill-query-handler.py query "your task"`
2. Load the skill into your AI agent session
3. Follow the skill's workflow instructions
4. Validate with `git status` before committing

---

**Updated**: 2026-02-21
