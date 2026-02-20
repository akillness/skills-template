# GitHub Copilot Coding Agent Skill

## Overview

Automates GitHub Copilot Coding Agent assignment: create an issue, add the `ai-copilot` label, GitHub Actions assigns it to Copilot, and Copilot creates a Draft PR automatically.

## Prerequisites

- GitHub repository with Copilot Coding Agent enabled (Pro+, Business, or Enterprise plan)
- `gh` CLI installed and authenticated
- Personal Access Token with `repo` scope

## One-Time Setup

```bash
# Interactive setup: sets secret, deploys workflow, creates label
bash scripts/copilot-setup-workflow.sh
```

This script performs the following steps:

1. Sets `COPILOT_ASSIGN_TOKEN` repository secret
2. Deploys `.github/workflows/assign-to-copilot.yml`
3. Creates the `ai-copilot` label in your repo

## Usage

### Method 1: Via GitHub Actions (automatic)

```bash
# Create issue with ai-copilot label -> Copilot auto-assigned
gh issue create \
  --label ai-copilot \
  --title "Add user authentication" \
  --body "Implement JWT-based auth with refresh tokens"
```

### Method 2: Manual script (existing issues)

```bash
# Set token
export COPILOT_ASSIGN_TOKEN=<your-pat>

# Assign existing issue
bash scripts/copilot-assign-issue.sh 42
```

### Method 3: Label existing issue

```bash
gh issue edit 42 --add-label ai-copilot
```

## planno (plannotator) Integration — Optional, Independent

Review the issue spec with planno (plannotator) before assigning to Copilot (optional, runs independently):

```text
planno로 이슈 스펙을 검토하고 승인해줘
```

After approval, add the `ai-copilot` label to trigger automation.

## GitHub Actions Workflows

| Workflow | Trigger | Purpose |
|----------|---------|---------|
| `assign-to-copilot.yml` | Issue labeled `ai-copilot` | Assigns issue to Copilot bot via GraphQL |
| `copilot-pr-ci.yml` | PR opened/updated | Runs CI (build + test) on Copilot's PRs |

## How It Works (Technical)

1. Issue is labeled `ai-copilot`
2. GitHub Actions triggers `assign-to-copilot.yml`
3. Workflow queries Copilot bot's GraphQL ID
4. `replaceActorsForAssignable` mutation assigns Copilot to the issue
5. Copilot reads the issue, starts coding
6. Copilot opens a Draft PR with the implementation

Required GraphQL headers:

```
GraphQL-Features: issues_copilot_assignment_api_support,coding_agent_model_selection
```

## Constraints

- Requires GitHub **Pro+, Business, or Enterprise** plan
- Copilot Coding Agent must be enabled for the repository
- PAT requires `repo` scope
- First PR from Copilot requires manual approval in Actions

## Checking Results

```bash
# List Copilot's PRs
gh pr list --search 'head:copilot/'

# View specific issue
gh issue view 42
```
