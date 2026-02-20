# Agent Skills

Modular skill system for AI agents.

---

## Installation (one-liners)

```bash
# Install all skills
npx skills add https://github.com/supercent-io/skills-template

# Install one skill
npx skills add https://github.com/supercent-io/skills-template --skill conductor-pattern
npx skills add https://github.com/supercent-io/skills-template --skill oh-my-codex
```

### Quick command patterns

```bash
# All-in-one usage
npx skills add <repo-url> --skill <skill-name>
# Example: install ralph loop skill
npx skills add https://github.com/supercent-io/skills-template --skill ralph

# Install community extension from Awesome Claude Skills
npx skills add https://github.com/ComposioHQ/awesome-claude-skills --skill github-automation
```

### Validate installation

```bash
python3 .agent-skills/skill_loader.py list
python3 .agent-skills/skill_query_handler.py query "REST API"
```

---

## Core usage (recommended paths)

### 1) Conductor Pattern (parallel execution workflow)

```bash
# Prerequisite check
bash scripts/pipeline-check.sh --agents=claude,codex

# Run parallel agents and create branches
bash scripts/conductor.sh my-feature main claude,codex

# Create PRs from completed worktrees
bash scripts/conductor-pr.sh my-feature main

# Clean up worktrees/branches
bash scripts/conductor-cleanup.sh my-feature
```

### 2) Full pipeline in one step

```bash
bash scripts/pipeline.sh my-feature --stages check,conductor,pr
bash scripts/pipeline.sh my-feature --stages check,plan,conductor,pr --no-attach
bash scripts/pipeline.sh my-feature --dry-run
```

### 3) Copilot coding agent integration

```bash
# Setup
bash scripts/copilot-setup-workflow.sh

# Assign existing issue to Copilot
bash scripts/copilot-assign-issue.sh 42
```

---

## Quick structure

- `scripts/`: 실행 스크립트 모음 (`pipeline.sh`, `conductor.sh` 등)
- `.agent-skills/`: 실습 가능한 스킬 정의와 manifest
- `docs/`: 상세 가이드 모음 (아래 참조)

---

## Detailed docs

이 README는 핵심 명령어만 정리했습니다. 자세한 설치/사용/스크립트 사양은 아래 문서를 사용하세요.

- [Installation Guide](docs/installation.md)
- [Usage Guide](docs/usage-guide.md)
- [Script Reference](docs/script-reference.md)
- [Conductor Pattern Guide](docs/conductor-pattern/README.md)
- [Skill set overview (.agent-skills)](.agent-skills/README.md)

---

## Quick checks

```bash
# Show current repo skills
python3 .agent-skills/skill_loader.py list
python3 .agent-skills/skill_loader.py search "agentic-workflow"

# Show token-optimized index and stats
python3 .agent-skills/skill_loader.py stats
python3 .agent-skills/skill_query_handler.py stats
```

