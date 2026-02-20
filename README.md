# Agent Skills

> Modular skill system for AI agents.
> **66 Skills** · **TOON Format** · **Flat Skill Layout**

---

## Quick install

```bash
# Install all skills
npx skills add https://github.com/supercent-io/skills-template

# Install one skill
npx skills add https://github.com/supercent-io/skills-template --skill conductor-pattern
npx skills add https://github.com/supercent-io/skills-template --skill oh-my-codex
```

---

## Repository summary

This repository stores the `agentskills` package used by this workspace.

- `66` skills under `.agent-skills/`
- TOON format is the default output mode
- Flat skill layout (`.agent-skills/<skill-name>/`)
- Orchestration + workflow tooling in `scripts/`

---

## Scripts in this project

| Script | Purpose |
| --- | --- |
| `scripts/pipeline-check.sh` | Pre-flight check for conductor requirements (agent binaries, git worktree, tmux, etc.) |
| `scripts/conductor.sh` | Launch AI agents in parallel using git worktree |
| `scripts/conductor-pr.sh` | Create branch/commit/push and open PR for each agent result |
| `scripts/conductor-cleanup.sh` | Remove worktrees, tmux sessions, and local branches |
| `scripts/pipeline.sh` | End-to-end pipeline: `check -> conductor -> pr` (with optional `plan`, `copilot`) |
| `scripts/copilot-setup-workflow.sh` | Configure Copilot coding-agent workflow and required GitHub labels/secrets |
| `scripts/copilot-assign-issue.sh` | Assign an existing issue to Copilot coding agent |
| `scripts/vibe-kanban-start.sh` | Start Vibe Kanban UI |
| `scripts/hooks/pre-conductor.sh` | Pre-hook example (defaults to blocking on failure) |
| `scripts/hooks/post-conductor.sh` | Post-hook example (warn-only on failure) |

---

## Core command set

```bash
# 1) Pre-check
bash scripts/pipeline-check.sh --agents=claude,codex

# 2) Conductor workflow
bash scripts/conductor.sh <feature-name> <base-branch> <agent-list>
# ex) bash scripts/conductor.sh auth-refactor main claude,codex

bash scripts/conductor-pr.sh <feature-name> <base-branch>
# ex) bash scripts/conductor-pr.sh auth-refactor main

bash scripts/conductor-cleanup.sh <feature-name>
# ex) bash scripts/conductor-cleanup.sh auth-refactor

# 3) Full pipeline
bash scripts/pipeline.sh <feature-name> --stages check,conductor,pr
bash scripts/pipeline.sh <feature-name> --stages check,plan,conductor,pr --no-attach
bash scripts/pipeline.sh <feature-name> --dry-run

# 4) Copilot + Kanban
bash scripts/copilot-setup-workflow.sh
bash scripts/copilot-assign-issue.sh <issue-number>
bash scripts/vibe-kanban-start.sh --port 3001
```

---

## Skills list (66 total)

### Orchestration & Workflow
`agent-browser`, `agent-configuration`, `agent-evaluation`, `agentic-development-principles`, `agentic-principles`, `agentic-workflow`, `bmad`, `bmad-orchestrator`, `changelog-maintenance`, `conductor-pattern`, `copilot-coding-agent`, `environment-setup`, `file-organization`, `git-submodule`, `git-workflow`, `npm-git-install`, `opencontext`, `oh-my-codex`, `ohmg`, `omc`, `plannotator`, `prompt-repetition`, `ralph`, `skill-standardization`, `workflow-automation`

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

> Full manifest + descriptions are in `.agent-skills/skills.json` and each folder’s `SKILL.md`.

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
│   ├── [66 skill folders]
│   └── react-best-practices/AGENTS.md
├── docs/
│   ├── installation.md
│   ├── script-reference.md
│   ├── usage-guide.md
│   ├── bmad/
│   ├── conductor-pattern/
│   ├── copilot-coding-agent/
│   ├── harness/
│   ├── omc/
│   ├── plannotator/
│   ├── ralph/
│   └── vibe-kanban/
├── scripts/
│   ├── hooks/
│   └── *.sh
├── install.sh / flatten_skills.py
└── README.md
```

---

## Related docs

- [Installation guide](docs/installation.md)
- [Usage guide](docs/usage-guide.md)
- [Script reference](docs/script-reference.md)
- [Conductor Pattern docs](docs/conductor-pattern/README.md)
- [Ralph loop docs](docs/ralph/README.md)
- [Vibe Kanban docs](docs/vibe-kanban/README.md)
- [Copilot coding agent docs](docs/copilot-coding-agent/README.md)

---

**Version**: Local repository sync | **Updated**: 2026-02-20
