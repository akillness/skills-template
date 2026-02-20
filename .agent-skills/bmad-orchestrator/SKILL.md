---
name: bmad-orchestrator
keyword: bmad
description: Orchestrates BMAD workflows for structured AI-driven development. Routes work across Analysis, Planning, Solutioning, and Implementation phases.
allowed-tools: [Read, Write, Bash, Grep, Glob]
tags: [bmad, orchestrator, workflow, planning, implementation]
platforms: [Claude, Gemini, Codex, OpenCode]
version: 1.0.0
source: user-installed skill
---

# bmad-orchestrator - BMAD Workflow Orchestration

## When to use this skill

- Initializing BMAD in a new project
- Checking and resuming BMAD workflow status
- Routing work across Analysis, Planning, Solutioning, and Implementation
- Managing structured handoff between phases

---

## Installation

```bash
npx skills add https://github.com/supercent-io/skills-template --skill bmad-orchestrator
```

---

## BMAD Execution Commands

Use these in your AI session:

```text
/workflow-init
/workflow-status
```

Typical flow:

1. Run `/workflow-init` to bootstrap BMAD config.
2. Move through phases in order: Analysis -> Planning -> Solutioning -> Implementation.
3. Run `/workflow-status` any time to inspect current phase and progress.

---

## Quick Reference

| Action | Command |
|--------|---------|
| Initialize BMAD | `/workflow-init` |
| Check BMAD status | `/workflow-status` |
