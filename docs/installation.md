# Installation Guide

## Overview

This guide documents the standard installation flow for `agentskills` and community-contributed skill sources used by this repository.

---

## 1) 기본 설치 명령

Install all skills from this template:

```bash
npx skills add https://github.com/akillness/skills-template
```

Install only one skill:

```bash
npx skills add https://github.com/akillness/skills-template --skill omc
npx skills add https://github.com/akillness/skills-template --skill oh-my-codex
npx skills add https://github.com/akillness/skills-template --skill plannotator
npx skills add https://github.com/akillness/skills-template --skill vibe-kanban
```

---

## 2) 특수/커뮤니티 스킬

Some external skills are not part of the base template and must be added separately.

```bash
# Awesome Claude Skills source
npx skills add https://github.com/ComposioHQ/awesome-claude-skills --skill github-automation
npx skills add https://github.com/ComposioHQ/awesome-claude-skills --skill slack-automation
```

Some tools require independent sources:

```bash
# Playwright-based browser automation
npx -y skills add remorses/playwriter

# Vercel-labs agent-browser package
npx skills add vercel-labs/agent-browser
```

---

## 3) 설치 유효성 확인

```bash
# List installed skills
python3 .agent-skills/skill_loader.py list

# Search by keyword
python3 .agent-skills/skill_loader.py search "rest api"

# Query skill index
python3 .agent-skills/skill-query-handler.py query "api design"
```

---

## 4) 설치 후 권장 점검

- Confirm `agentskills/.agent-skills/README.md` metadata (category/count/version) matches your installation result.
- If `npx` is unavailable, install Node.js and retry.
- `skills.json` is a manifest file; avoid manual editing unless necessary.

---

**Updated**: 2026-02-21
