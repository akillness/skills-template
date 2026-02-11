---
name: bmad
description: AI-driven agile development framework with 26+ specialized agents, 68+ guided workflows, and scale-adaptive intelligence. Transforms "vibe coding" into structured, multi-agent orchestrated development through four-phase methodology.
allowed-tools: [Read, Write, Edit, Bash, Grep, Glob, LSP]
tags: [bmad, agile-ai, multi-agent, orchestration, workflow-automation]
platforms: [Claude, Gemini, ChatGPT, Codex, Cursor, Opencode]
version: 1.0.0
source: https://github.com/bmad-code-org/BMAD-METHOD
---

# BMAD-METHOD: Breakthrough Method for Agile AI-Driven Development

## When to use this skill

- **Planning complex software projects**: Coordinating multiple AI agents in structured workflows.
- **Reducing hallucinations**: Using spec-driven development (SDD) to ensure precision.
- **Scaling development**: From simple bug fixes to enterprise-grade systems.
- **Enterprise applications**: Projects requiring compliance and multi-team coordination.
- **Legacy modernization**: Brownfield development with incremental migration.
- **Team collaboration**: Enabling multiple agents and humans to work together efficiently.

---

## 1. Core Concepts

### Four-Phase Methodology
1. **Phase 1: Analysis (Optional)**: Exploration and research using `/brainstorm-project`, `/research`, `/product-brief`.
2. **Phase 2: Planning (Required)**: Requirements definition using `/prd`, `/tech-spec`, `/create-ux-design`.
3. **Phase 3: Solutioning (Track-Dependent)**: Architecture design using `/create-architecture`.
4. **Phase 4: Implementation (Required)**: Sprint execution using `/sprint-plan`, `/story-breakdown`.

### Multi-Agent Orchestration
Coordinates 26+ specialized agents. Use `/load-agent [name]` or `/party-mode [names...]`.

| Agent | Phase | Responsibility |
|-------|-------|-----------------|
| **Analyst** | Analysis | Market research, competitive analysis |
| **Product Manager** | Planning | PRD creation, requirements definition |
| **Architect** | Solutioning | Technical design, ADRs, system decisions |
| **Developer** | Implementation | Code implementation, technical execution |
| **QA Specialist** | Implementation | Test design, quality assurance |
| **Barry** | Quick Flow | Solo development track specialist |

### Scale-Adaptive Intelligence
Automatically adjusts planning depth (Simple, BMad Method, Enterprise) based on complexity.

---

## 2. Step-by-Step Instructions

### Step 1: Initialize BMAD
Ensure Node.js v20+ is installed and initialize BMAD at the project level.

```bash
# Check prerequisites
node --version
git --version

# Install BMAD-METHOD
npx bmad-method install
```

### Step 2: Verification (Installation Check)
Verify the setup is ready for operation.

```bash
# Check installation manifest
cat .bmad-manifest.json

# Get interactive guidance
/bmad-help
```

### Step 3: Start a Workflow
Execute the phase-appropriate command.

```bash
# Start with ideation
/brainstorm-project

# Move to requirements
/prd
```

### Step 4: Multi-Agent Collaboration
Use Party Mode for complex planning.

```bash
/party-mode analyst pm architect
```

---

## 3. Code Examples

### Example 1: Quick Flow Implementation
Scenario: Rapid feature development using the Barry agent.

```bash
# 1. Load Barry
/load-agent barry

# 2. Generate lightweight spec
/tech-spec

# 3. Implement and verify
/sprint-plan
```

### Example 2: CI/CD Non-Interactive Installation
Scenario: Automated environment setup.

```bash
npx bmad-method install \
  --directory ./my-project \
  --modules bmm,bmb \
  --tools "Claude Code" \
  -y
```

---

## 4. Best Practices

- **SDD First**: Never code before producing a spec (PRD or Tech Spec).
- **Isolation**: Use project-level installation for configuration consistency.
- **Quality Gates**: Run QA workflows before merging or deploying.
- **Human Governance**: Agents are expert collaborators; humans provide final approval.

---

## 5. Troubleshooting

| Issue | Cause | Solution |
|-------|-------|----------|
| `Command not found` | BMAD not installed | Run `npx bmad-method install` |
| `Hallucinations` | Vague spec | Refine `/prd` or `/tech-spec` output |
| `Workflow stuck` | State conflict | Run `/bmad-help` or check `sprint-status.yaml` |
| `Missing Agent` | Module not installed | Re-run install with `--modules` flag |

---

## 6. References

- [Official Documentation](https://docs.bmad-method.org/)
- [GitHub Repository](https://github.com/bmad-code-org/BMAD-METHOD)
- [Workflow Map](https://github.com/bmad-code-org/BMAD-METHOD/blob/main/docs/reference/workflow-map.md)
- [Agent Reference](https://deepwiki.com/bmad-code-org/BMAD-METHOD/9-workflow-reference)
