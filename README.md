# Agent Skills

> Modular skill system for AI agents.
> **63 Skills** · **TOON Format** · **Flat Skill Layout**

---

## Quick install

```bash
# Install all skills
npx skills add https://github.com/akillness/skills-template

# Install one skill
npx skills add https://github.com/akillness/skills-template --skill omc
npx skills add https://github.com/akillness/skills-template --skill oh-my-codex
npx skills add https://github.com/akillness/skills-template --skill plannotator
```

---

## Repository summary

This repository stores the `agentskills` package used by this workspace.

- `63` skills under `.agent-skills/`
- TOON format is the default output mode
- Flat skill layout (`.agent-skills/<skill-name>/`)

---

## Skills list (63 total)

### Orchestration & Workflow
`agent-browser`, `agent-configuration`, `agent-evaluation`, `agentic-development-principles`, `agentic-principles`, `agentic-workflow`, `bmad-orchestrator`, `changelog-maintenance`, `copilot-coding-agent`, `environment-setup`, `file-organization`, `git-submodule`, `git-workflow`, `npm-git-install`, `opencontext`, `oh-my-codex`, `ohmg`, `omc`, `plannotator`, `prompt-repetition`, `ralph`, `skill-standardization`, `vibe-kanban`, `workflow-automation`

### API / Backend
`api-design`, `api-documentation`, `authentication-setup`, `backend-testing`, `database-schema-design`

### Frontend
`design-system`, `react-best-practices`, `responsive-design`, `state-management`, `ui-component-patterns`, `web-accessibility`, `web-design-guidelines`

### Code quality
`code-refactoring`, `code-review`, `debugging`, `performance-optimization`, `testing-strategies`

### Search & analysis
`codebase-search`, `data-analysis`, `log-analysis`, `pattern-detection`

### Documentation
`changelog-maintenance`, `presentation-builder`, `technical-writing`, `user-guide-writing`

### Project management
`sprint-retrospective`, `standup-meeting`, `task-estimation`, `task-planning`

### Infrastructure
`deployment-automation`, `firebase-ai-logic`, `genkit`, `looker-studio-bigquery`, `monitoring-observability`, `security-best-practices`, `system-environment-setup`, `vercel-deploy`

### Creative
`image-generation`, `pollinations-ai`, `video-production`

### Marketing
`marketing-automation`

> Full manifest + descriptions are in `.agent-skills/skills.json` and each folder's `SKILL.md`.

---

## Structure

```text
.
├── .agent-skills/
│   ├── README.md
│   ├── skill_loader.py
│   ├── skill-query-handler.py
│   ├── skills.json
│   ├── skills.toon
│   └── [63 skill folders]
├── docs/
│   ├── installation.md
│   ├── usage-guide.md
│   ├── omc/
│   ├── plannotator/
│   ├── ralph/
│   └── vibe-kanban/
├── install.sh / flatten_skills.py
└── README.md
```

---

## Related docs

- [Installation guide](docs/installation.md)
- [Usage guide](docs/usage-guide.md)
- [OMC docs](docs/omc/README.md)
- [Ralph loop docs](docs/ralph/README.md)
- [Plannotator docs](docs/plannotator/README.md)
- [Vibe Kanban docs](docs/vibe-kanban/README.md)

---

**Version**: 4.5.0 | **Updated**: 2026-02-21
