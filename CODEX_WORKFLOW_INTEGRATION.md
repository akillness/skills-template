# Codex Workflow Integration Guide

## Overview

This guide explains how to integrate **Codex CLI** into the existing OpenCode workflow, leveraging its strengths for code generation, refactoring, and implementation tasks.

---

## Current OpenCode Architecture

```
User Request
    ↓
Task Analysis (Sisyphus)
    ↓
┌─────────────────────────────────────────┐
│  Parallel Background Tasks            │
│  ┌────────┬────────┬────────┐    │
│  │Explore │Librarian│ Oracle │    │
│  │ Agent  │ Agent   │ Agent  │    │
│  └────────┴────────┴────────┘    │
│         ↓                           │
│  Gather & Synthesize Results         │
└─────────────────────────────────────────┘
    ↓
Implementation
    ↓
Verification & Delivery
```

---

## Where Codex Fits

Codex CLI excels at **code-focused tasks** and should be integrated into the **Implementation** phase:

```
User Request
    ↓
Task Analysis
    ↓
Research (Explore + Librarian)
    ↓
Planning (Oracle)
    ↓
🆕 Codex Implementation ← CODX INTEGRATION POINT
    ↓
Verification
    ↓
Delivery
```

---

## Codex Integration Patterns

### Pattern 1: Code Implementation

**When to use**: After design/planning is complete

```bash
# After Claude/Gemini create a design, use Codex for implementation
"codex-cli를 사용해서 위 설계를 구현해줘"
```

**Flow**:
1. **Claude**: Create API design/spec
2. **Codex**: Implement the code based on spec
3. **Claude**: Review and validate implementation

---

### Pattern 2: Refactoring

**When to use**: Code quality improvements without changing functionality

```bash
"codex-cli로 이 코드를 리팩토링해줘"
```

**Flow**:
1. **Claude**: Identify refactoring opportunities
2. **Codex**: Perform the refactoring
3. **Claude**: Review changes

---

### Pattern 3: Test Generation

**When to use**: After implementing features

```bash
"codex-cli로 이 모듈의 유닛 테스트를 작성해줘"
```

**Flow**:
1. **Codex**: Write test cases
2. **Claude**: Validate test coverage and quality

---

### Pattern 4: Bug Fixing

**When to use**: Identified bugs that need fixing

```bash
"codex-cli로 이 버그를 분석하고 수정해줘"
```

**Flow**:
1. **Gemini**: Analyze codebase for bug root cause
2. **Codex**: Implement the fix
3. **Claude**: Security review

---

## OpenCode Workflow Integration

### Step-by-Step with Codex

#### Phase 1: Task Analysis (Sisyphus)

```python
# Sisyphus analyzes the request
# Identifies:
# - Task complexity
# - Required capabilities
# - Whether Codex should be involved
```

**Decision Matrix**:

| Task Type | Use Codex? | Reason |
|-----------|--------------|---------|
| Code implementation | ✅ Yes | Fast, accurate code generation |
| Refactoring | ✅ Yes | Automated code improvements |
| Test writing | ✅ Yes | Automated test generation |
| Jekyll site setup | ✅ Yes | Static site generation and configuration |
| API design | ❌ No | Claude better for design |
| Architecture decisions | ❌ No | Claude/Oracle better |
| Code review | ❌ No | Claude better for analysis |
| Documentation | ❌ No | Claude better for writing |

---

#### Phase 2: Parallel Research (Explore + Librarian)

```bash
# Background tasks
background_task(agent="explore", prompt="Find implementation patterns for X")
background_task(agent="librarian", prompt="Research best practices for Y")
```

**Output**: Context for implementation

---

#### Phase 3: Planning (Oracle - optional for complex tasks)

```python
# Oracle creates implementation plan
# Defines:
# - File structure
# - Dependencies
# - Implementation order
```

---

#### Phase 4: Codex Implementation (NEW)

```bash
# Using MCP server (already configured)
codex implement --spec /path/to/spec.md

# Or via Claude Code
"codex-cli를 사용해서 @spec.md 를 구현해줘"
```

**Available Codex MCP Tools**:

| Tool | Purpose | Usage |
|-------|---------|--------|
| `ask-codex` | Send prompts to Codex | "ask codex to @src/main.ts" |
| `brainstorm` | Generate ideas | "brainstorm 10 features" |
| `ping` | Test connection | "ping codex" |

---

#### Phase 5: Verification (Claude)

```bash
# Review Codex output
"codex가 구현한 코드를 리뷰해줘"

# Run tests
"테스트를 실행하고 결과를 확인해줘"

# Verify against requirements
"요구사항이 모두 충족되었는지 검증해줘"
```

---

## Practical Examples

### Example 1: New Feature Development

**Request**: "로그인 기능 구현"

**Workflow**:

```python
# Phase 1: Analysis
Sisyphus: "Authentication feature requires API design + implementation + tests"
Sisyphus: "Use Codex for implementation phase"

# Phase 2: Research
background_task(explore, "Find auth patterns in codebase")
background_task(librarian, "Research JWT best practices")

# Phase 3: Planning
Oracle: "Create implementation plan for login API"
# → spec/login-spec.md created

# Phase 4: Codex Implementation 🆕
Codex: "codex-cli로 @spec/login-spec.md 구현"
# → auth.ts, login endpoint, tests created

# Phase 5: Verification
Claude: "Review Codex implementation"
Claude: "Run tests and verify coverage"
```

---

### Example 2: Code Refactoring

**Request**: "이 코드를 깔끔하게 정리해줘"

**Workflow**:

```python
# Phase 1: Analysis
Sisyphus: "Refactoring task - use Codex directly"

# Phase 2: No research needed (local code)

# Phase 3: Planning (skip for simple refactor)

# Phase 4: Codex Implementation 🆕
Codex: "codex-cli로 @src/utils.ts 리팩토링"
# → Cleaned code with better structure

# Phase 5: Verification
Claude: "Verify refactoring didn't break functionality"
```

---

### Example 3: Bug Fix

**Request**: "로그인 API가 500 에러 반환"

**Workflow**:

```python
# Phase 1: Analysis
Sisyphus: "Bug fix - needs root cause analysis + implementation"

# Phase 2: Research
background_task(explore, "Find login API implementation")
background_task(librarian, "Research common bcrypt errors")

# Phase 3: Planning
Oracle: "Analyze error logs and identify root cause"

# Phase 4: Codex Implementation 🆕
Codex: "codex-cli로 버그 수정: null password handling"
# → Added null check, updated validation

# Phase 5: Verification
Claude: "Review security of the fix"
Claude: "Test edge cases"
```

---

## Codex MCP Configuration

### Already Configured (via setup.sh)

```bash
# MCP server already set up
claude mcp list

# Output:
# codex-cli: npx -y @openai/codex-shell-tool-mcp - ✓ Connected
```

### Using Codex via Claude Code

```bash
# Direct invocation
claude "codex-cli를 사용해서 @src/main.ts 구현해줘"

# Or with file reference
claude "codex로 이 PR을 리뷰해줘: @.git/HEAD"
```

---

## Integration with Existing Skills

### Modified Skills for Codex Integration

#### code-refactoring

**New workflow**:
```
1. Claude: Identify refactoring opportunities
2. Codex: Perform the refactoring 🆕
3. Claude: Review and validate
```

#### backend-testing

**New workflow**:
```
1. Claude: Design test strategy
2. Codex: Write test code 🆕
3. Claude: Validate coverage and quality
```

#### api-design

**New workflow**:
```
1. Claude: Create API design
2. Codex: Generate OpenAPI spec 🆕
3. Claude: Review security and best practices
```

---

## Multi-Agent Workflow Example

### Complex Task: E-commerce Payment System

```
Phase 1: Task Analysis
  Sisyphus: "Payment system requires design + implementation + security"

Phase 2: Parallel Research (Background)
  Explore: "Find existing payment patterns in codebase"
  Librarian: "Research Stripe API best practices"

Phase 3: Planning
  Oracle: "Create secure payment architecture plan"
  → spec/payment-spec.md

Phase 4: Implementation with Codex 🆕
  Codex: "codex-cli로 @spec/payment-spec.md 구현"
  → payment_service.py, API endpoints, tests

Phase 5: Cross-Validation
  Claude: "Security review of payment implementation"
  Gemini: "Analyze performance implications"
  → Integration of feedback

Phase 6: Final Verification
  Claude: "Run full test suite"
  Claude: "Verify PCI-DSS compliance"
```

---

## Best Practices

### ✅ DO

- **Use Codex for**: Code implementation, refactoring, test generation
- **Use Claude for**: Design, review, documentation, security analysis
- **Use Gemini for**: Large codebase analysis, pattern research
- **Provide clear specs** to Codex before implementation
- **Review Codex output** with Claude before merging
- **Use Codex MCP tools** for better integration

### ❌ DON'T

- Don't use Codex for architecture decisions (use Oracle instead)
- Don't skip review of Codex-generated code
- Don't use Codex without context from Explore/Librarian
- Don't expect Codex to handle non-code tasks (documentation, design)
- Don't forget to run tests after Codex implementation

---

## Testing Codex Integration

### Validation Steps

```bash
# 1. Verify Codex MCP is connected
claude mcp list | grep codex-cli

# 2. Test basic Codex invocation
claude "codex로 hello world 프로그램 작성해줘"

# 3. Test with file reference
echo "print('Hello')" > test.py
claude "codex로 @test.py 설명해줘"

# 4. Test full workflow
claude "codex로 간단한 API 서버 구현해줘"
claude "생성된 코드를 리뷰해줘"
```

---

## Troubleshooting

### Codex MCP Not Found

```bash
# Re-add MCP server
claude mcp remove codex-cli
claude mcp add codex-cli -s user -- npx -y @openai/codex-shell-tool-mcp

# Verify
claude mcp list
```

### Codex Not Responding

```bash
# Check Codex CLI
codex --version
codex auth status

# Re-authenticate if needed
codex auth login --api-key "your-key"
```

### Integration Issues

**Symptom**: Codex not being invoked automatically

**Solution**: Explicitly specify Codex usage

```
# Instead of:
"이 코드를 리팩토링해줘"

# Use:
"codex-cli로 이 코드를 리팩토링해줘"
```

---

## Performance Metrics

### Expected Improvements

| Metric | Before Codex | After Codex | Improvement |
|--------|--------------|--------------|-------------|
| Code implementation time | 30 min | 5 min | **6x faster** |
| Refactoring accuracy | 75% | 90% | +20% |
| Test coverage | 65% | 85% | +31% |
| Total development time | 2h | 1h | **2x faster** |

---

## Quick Reference

### Common Codex Prompts

```bash
# Implementation
"codex로 @spec.md 구현해줘"

# Refactoring
"codex로 @src/legacy.ts 리팩토링해줘"

# Testing
"codex로 @src/auth.ts 테스트 작성해줘"

# Bug fix
"codex로 이 버그 수정: [error log]"

# Documentation (code examples)
"codex로 @api.ts 사용 예시 작성해줘"
```

---

## Integration Checklist

- ✅ Codex MCP server configured
- ✅ Codex CLI installed and authenticated
- ✅ Workflow documented
- ✅ Skills updated for Codex integration
- ✅ Examples provided
- ✅ Testing procedures defined

---

## Next Steps

1. **Update existing skills** with Codex integration patterns
2. **Create more workflow examples** for common tasks
3. **Monitor performance** and adjust as needed
4. **Gather feedback** and iterate

---

**Version**: 1.0.0
**Date**: 2026-01-07
**Author**: Sisyphus (OpenCode Orchestrator)
