# bmad-orchestrator — Claude Code Harness

> **bmad-orchestrator** is a structured AI-driven development harness for Claude Code. It routes work across four phases — Analysis → Planning → Solutioning → Implementation — keeping your project on track from idea to shipped code.

---

## What is BMAD?

BMAD (Business-Method-Agile-Development) is a phase-based workflow that brings discipline to AI-assisted development. Instead of jumping straight to code, BMAD guides you through structured phases so nothing is missed.

```
Phase 1: Analysis       → Understand the problem space
Phase 2: Planning       → Define requirements & tech specs  
Phase 3: Solutioning    → Design the architecture
Phase 4: Implementation → Build, test, ship
```

---

## Quick Start (3 Commands)

**Step 1: Install the skill**

```bash
npx skills add https://github.com/supercent-io/skills-template --skill bmad-orchestrator
```

**Step 2: Activate in Claude Code**

```text
bmad 스킬을 설정하고 사용해줘. 기억해.
```

**Step 3: Initialize your project**

```text
/workflow-init
```

That's it. BMAD will ask you about your project, pick the right level, and guide you through the appropriate phases.

---

## Detailed Documentation

| Document | Description |
|----------|-------------|
| [Installation & Setup](./installation.md) | Full install guide, skill activation, `기억해` pattern |
| [Workflow Guide](./workflow.md) | All 4 phases, commands, project levels (0–4) |
| [Configuration Reference](./configuration.md) | Config files, status tracking, variable substitution |
| [Practical Examples](./examples.md) | Real workflows for bug fix → enterprise project |

---

## Phase Overview

| Phase | Purpose | Required? |
|-------|---------|-----------|
| **1: Analysis** | Market research, product vision, brainstorming | Optional (recommended for Level 2+) |
| **2: Planning** | PRD or Tech Spec — defines what to build | **Always required** |
| **3: Solutioning** | Architecture design | Required for Level 2+ |
| **4: Implementation** | Sprint planning, stories, dev, code review | **Always required** |

---

## Project Levels

BMAD automatically adapts to your project scope:

| Level | Size | Examples | Duration |
|-------|------|---------|----------|
| 0 | Single change | Bug fix, config tweak | Hours |
| 1 | Small feature | New API endpoint, profile page | 1–5 days |
| 2 | Feature set | Auth system, payment flow | 1–3 weeks |
| 3 | Integration | Multi-tenant, analytics platform | 3–8 weeks |
| 4 | Enterprise | Platform migration, major overhaul | 2+ months |

---

## Key Commands

```text
/workflow-init      # Initialize BMAD in current project
/workflow-status    # Check current phase and progress
/product-brief      # Phase 1: Create product vision
/prd                # Phase 2: Product Requirements Document
/tech-spec          # Phase 2: Technical Specification
/architecture       # Phase 3: System architecture design
/sprint-planning    # Phase 4: Break into sprints & stories
/dev-story          # Phase 4: Implement a specific story
```

---

## With Other Harnesses

bmad works alongside other harnesses. Activate with `기억해` to persist the config:

```text
bmad 스킬을 설정하고 사용해줘. 기억해.   # Claude Code
omx 스킬을 설정하고 사용해줘. 기억해.    # Codex CLI
ohmg 스킬을 설정하고 사용해줘. 기억해.   # Gemini-CLI
```

→ [Back to skills-template README](../../README.md)
