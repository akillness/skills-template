---
name: subagent-creation
description: Create and configure Claude Code subagents for specialized task delegation. Use when defining expert AI assistants with focused responsibilities, custom prompts, and specific tool permissions.
tags: [claude-code, subagent, delegation, automation, workflow, configuration]
platforms: [Claude]
---

# Claude Code Subagent Creation

## When to use this skill
- Defining specialized AI experts for specific tasks
- Creating reusable agent configurations for team workflows
- Implementing task delegation patterns
- Setting up automated code review, debugging, or analysis workflows
- Creating agents with custom prompts and tool permissions

## Instructions

### Step 1: Understanding Subagents

Claude Code subagents are pre-configured AI experts that the main Claude delegates work to.

**Core benefits**:
- **Context isolation**: Each agent has separate 200K token context
- **Specialized expertise**: Focused prompts for specific domains
- **Reusability**: Share agents via Git across projects
- **Flexible permissions**: Control which tools each agent can use
- **No nesting**: Prevents infinite loops - subagents cannot spawn more subagents

**Agent types**:
- **Built-in agents**: Explore (read-only, Haiku), Plan (research), General-purpose (Sonnet)
- **Custom agents**: User-defined with custom prompts and permissions

### Step 2: Agent Configuration File

Subagents are defined as Markdown files with YAML frontmatter.

**File location** (priority order):
1. Project-level: `.claude/agents/{agent-name}.md`
2. User-level: `~/.claude/agents/{agent-name}.md`

**File format**:
```markdown
---
name: code-reviewer
description: Review code changes for quality, security, and best practices. Use immediately after code changes.
tools: [Read, Grep, Glob, Bash, LSP]
model: inherit
---

# Code Reviewer

You are a senior code reviewer with expertise in:
- Code quality and maintainability
- Security vulnerabilities
- Performance optimization
- Best practices and design patterns

## Review Checklist

- [ ] Does the code follow project conventions?
- [ ] Are there any security vulnerabilities?
- [ ] Is the code readable and maintainable?
- [ ] Are there performance concerns?
- [ ] Are tests adequate?
- [ ] Is documentation complete?

## Review Guidelines

1. **Prioritize critical issues**: Security bugs, data races, memory leaks
2. **Be constructive**: Provide clear explanations and suggestions
3. **Consider trade-offs**: Don't optimize prematurely
4. **Reference standards**: Link to relevant docs/style guides

## Output Format

```
## Critical Issues (Must Fix)
- Issue: Description
  File: path/to/file.ts:123
  Suggestion: How to fix

## Suggestions (Should Fix)
...

## Nice to Have
...
```
```

### Step 3: YAML Frontmatter Configuration

**Required fields**:

| Field | Type | Description |
|-------|------|-------------|
| `name` | string | Agent identifier (kebab-case) |
| `description` | string | When to use this agent (1-2 sentences) |
| `tools` | list | Tools the agent can access (omit to inherit) |

**Optional fields**:

| Field | Type | Description | Default |
|-------|------|-------------|----------|
| `model` | string | Model to use | `inherit` |
| `version` | string | Agent version | None |

**Model options**:
- `inherit`: Use same model as main Claude
- `sonnet`: Claude 3.5 Sonnet
- `haiku`: Claude 3 Haiku (faster, cheaper)
- `opus`: Claude 3 Opus

**Tool options**: `Read`, `Write`, `Edit`, `Grep`, `Glob`, `Bash`, `LSP` tools

### Step 4: System Prompt Writing

**Best practices**:

1. **Define role clearly**: "You are a [role] with expertise in [domains]"

2. **Include checklist**: Concrete steps for evaluation/execution

3. **Provide examples**: Show input-output pairs

4. **Specify format**: Define exactly how results should be presented

5. **Set boundaries**: What the agent should NOT do

**Example prompt structure**:
```markdown
You are a [ROLE] specializing in [DOMAIN].

## Responsibilities
- Task 1
- Task 2

## Process
1. Step 1: ...
2. Step 2: ...

## Checklist
- [ ] Item 1
- [ ] Item 2

## Output Format
[Template]

## Constraints
- Constraint 1
- Constraint 2
```

### Step 5: Creating Common Agent Types

#### Agent 1: Code Reviewer

`.claude/agents/code-reviewer.md`:
```markdown
---
name: code-reviewer
description: Review code changes for quality, security, and best practices.
tools: [Read, Grep, Glob, LSP]
model: inherit
---

# Code Reviewer

Review code changes focusing on:
1. **Security**: Authentication, authorization, injection risks
2. **Quality**: Clean code principles, maintainability
3. **Performance**: Time/space complexity, bottlenecks
4. **Tests**: Coverage, edge cases

## Priority Levels
- **Critical**: Security vulnerabilities, data corruption
- **High**: Performance issues, logic errors
- **Medium**: Code smell, missing tests
- **Low**: Style, minor improvements
```

#### Agent 2: Debugger

`.claude/agents/debugger.md`:
```markdown
---
name: debugger
description: Analyze errors and implement fixes. Use when encountering bugs or failures.
tools: [Read, Write, Edit, Bash, Grep, Glob, LSP]
model: inherit
---

# Debugger

Systematically debug issues:
1. **Understand the problem**: Read error messages, logs
2. **Reproduce**: Try to recreate the issue
3. **Analyze**: Identify root cause
4. **Fix**: Implement minimal fix
5. **Verify**: Confirm the fix works
6. **Test**: Check for regressions

## Debugging Strategy
- Use `grep` to search for error-related code
- Check recent changes with `git log`
- Add logging if needed to trace execution
- Fix one issue at a time
- Verify fix doesn't break existing functionality
```

#### Agent 3: Test Writer

`.claude/agents/test-writer.md`:
```markdown
---
name: test-writer
description: Write comprehensive unit and integration tests for new code.
tools: [Read, Write, Edit, Grep, Glob]
model: inherit
---

# Test Writer

Write tests following these principles:
1. **AAA pattern**: Arrange, Act, Assert
2. **Descriptive names**: Test names explain what they verify
3. **One assertion per test**: Clear failure reasons
4. **Test happy path**: Main functionality
5. **Test edge cases**: Boundary conditions, nulls, errors
6. **Mock external dependencies**: Isolate code under test

## Test Coverage Goals
- Unit tests: 80%+ coverage
- Integration tests: Critical user flows
- E2E tests: Key user journeys

## Framework-Specific Guidelines
**Jest**: Use `describe`, `test`, `expect`, `beforeEach`, `afterEach`
**Pytest**: Use `def test_`, `assert`, `@pytest.fixture`
**Go testing**: Use `TestXxx`, `t.Run`, `assert.Equal`
```

#### Agent 4: Performance Analyzer

`.claude/agents/performance-analyzer.md`:
```markdown
---
name: performance-analyzer
description: Analyze code performance and identify optimization opportunities.
tools: [Read, Grep, Glob, LSP]
model: sonnet
---

# Performance Analyzer

Focus on:
1. **Time complexity**: Algorithm efficiency
2. **Space complexity**: Memory usage
3. **Database queries**: N+1 queries, missing indexes
4. **I/O operations**: File system, network calls
5. **Caching**: Missed caching opportunities

## Analysis Steps
1. Profile code to find hotspots
2. Review algorithm choices
3. Check database query patterns
4. Look for redundant computations
5. Identify parallelization opportunities

## Report Format
```
## Performance Issues Found

### Critical (High Impact)
- [Issue]: [Location]
  Impact: [description]
  Suggestion: [optimization]

### Moderate (Medium Impact)
...

### Low (Minor)
...
```
```

#### Agent 5: Documentation Writer

`.claude/agents/doc-writer.md`:
```markdown
---
name: doc-writer
description: Write clear, comprehensive documentation for code, APIs, and features.
tools: [Read, Write, Edit, Grep, Glob]
model: inherit
---

# Documentation Writer

Write documentation that is:
- **Clear**: Simple language, avoid jargon
- **Complete**: Cover all use cases
- **Accurate**: Keep docs in sync with code
- **Actionable**: Include examples
- **Searchable**: Use consistent terminology

## Documentation Types
- **README**: Project overview, setup, usage
- **API docs**: Endpoints, parameters, examples
- **Code comments**: Why, not what
- **Changelog**: Version history, breaking changes

## Writing Guidelines
1. Start with user goals
2. Provide examples for each feature
3. Link related documentation
4. Update docs when code changes
5. Use active voice and present tense
```

### Step 6: CLI Configuration

Create agents via CLI for automation:

**Single agent**:
```bash
claude --agents '{
  "code-reviewer": {
    "description": "Review code changes for quality and security",
    "tools": ["Read", "Grep", "Glob", "LSP"],
    "model": "inherit"
  }
}'
```

**Multiple agents**:
```bash
claude --agents '{
  "code-reviewer": {"description": "...", "tools": ["Read"]},
  "debugger": {"description": "...", "tools": ["Read", "Write", "Edit"]},
  "test-writer": {"description": "...", "tools": ["Read", "Write"]}
}'
```

**Add hooks for automation**:
```bash
# PostToolUse hook - automatically invoke debugger on errors
claude --hooks '{
  "PostToolUse": {
    "onError": "debugger"
  }
}'
```

### Step 7: Using Subagents

#### Explicit Invocation

Directly call an agent:

```
"Use code-reviewer to review the recent authentication changes."
```

```
"Invoke debugger agent to fix the failing test."
```

#### Automatic Delegation

Claude automatically delegates based on agent descriptions:

```
"Refactor the authentication logic for better security."
→ Claude delegates to: code-reviewer (security expert)
```

```
"Fix the database connection timeout error."
→ Claude delegates to: debugger (error fixing)
```

#### Agent Chaining

Chain multiple agents for complex tasks:

```
"Use performance-analyzer to identify bottlenecks, then debugger to fix them."
```

```
"Let code-reviewer check the changes, then doc-writer update the documentation."
```

#### Resume Previous Context

Resume a previous agent session:

```
"Resume the code-reviewer session with agentId abc123 to continue where we left off."
```

### Step 8: Version Control

Share agents via Git:

**Commit agents**:
```bash
cd /path/to/project
git add .claude/agents/
git commit -m "feat: add code-reviewer and debugger agents"
git push
```

**Clone project with agents**:
```bash
git clone https://github.com/myorg/project.git
# Agents are automatically available in .claude/agents/
```

## Examples

### Example 1: Complete Agent Creation Workflow

```bash
# 1. Create project-level agents directory
mkdir -p .claude/agents

# 2. Create code-reviewer agent
cat > .claude/agents/code-reviewer.md << 'EOF'
---
name: code-reviewer
description: Review code changes for quality, security, and best practices.
tools: [Read, Grep, Glob, LSP]
model: inherit
---

# Code Reviewer

Review code focusing on security, quality, performance, and tests.

## Priority
- Critical: Security vulnerabilities, data corruption
- High: Performance issues, logic errors
- Medium: Code smell, missing tests
- Low: Style improvements
EOF

# 3. Commit to Git
git add .claude/agents/code-reviewer.md
git commit -m "feat: add code-reviewer subagent"
git push
```

### Example 2: Automated Code Review Workflow

**Scenario**: After completing a feature, automatically review code.

**Setup**:
```bash
# Create post-commit hook
cat > .git/hooks/post-commit << 'EOF'
#!/bin/bash
claude --agents '{
  "code-reviewer": {
    "description": "Review HEAD commit for quality and security",
    "tools": ["Read", "Grep", "Glob", "LSP"],
    "model": "inherit"
  }
}' << INPUT
Review the changes in the most recent commit.
INPUT
EOF
chmod +x .git/hooks/post-commit
```

**Usage**:
```bash
git commit -m "feat: add user authentication"
# Post-commit hook automatically invokes code-reviewer
```

### Example 3: Multi-Agent Pipeline

**Scenario**: Code → Review → Test → Document

```markdown
In Claude Code:

"Here's the new payment processing code I just wrote. 

Use the following agents in sequence:
1. code-reviewer - Check for security issues and quality
2. test-writer - Write unit tests for the payment flow
3. doc-writer - Update API documentation

Return a summary of all findings."
```

### Example 4: Specialized Domain Agent

**`.claude/agents/database-expert.md`**:
```markdown
---
name: database-expert
description: Design and optimize database schemas, queries, and migrations.
tools: [Read, Write, Edit, Grep, Glob, Bash]
model: sonnet
---

# Database Expert

Expertise in:
- SQL design (PostgreSQL, MySQL, SQLite)
- NoSQL design (MongoDB, Redis, DynamoDB)
- Query optimization and indexing
- Migration strategies
- Data modeling and normalization

## Review Checklist
- [ ] Schema normalized? (3NF for relational DBs)
- [ ] Appropriate indexes?
- [ ] Query performance acceptable?
- [ ] Foreign keys/constraints defined?
- [ ] Migration reversible?
- [ ] Backup strategy documented?

## Optimization Tips
1. Use EXPLAIN ANALYZE to analyze query plans
2. Create composite indexes for multi-column WHERE clauses
3. Avoid SELECT * in production
4. Use connection pooling
5. Implement read replicas for read-heavy workloads
```

## Design Principles

1. **Single responsibility**: Each agent has one focused role
2. **Minimal permissions**: Only grant tools actually needed
3. **Detailed prompts**: Include checklists, steps, examples
4. **Model selection**: Choose model based on task complexity
5. **Version control**: Track agent configurations in Git
6. **Reusability**: Design agents to work across projects
7. **Clear descriptions**: Help Claude understand when to delegate

## Common Patterns

| Pattern | Use Case | Example |
|----------|-----------|----------|
| **Code → Review → Fix** | Iterative improvement | Code changes, review, implement fixes |
| **Analyze → Optimize** | Performance | Profile, identify issues, optimize |
| **Design → Implement → Test** | Feature development | Design, write code, test |
| **Document → Deploy** | Release | Update docs, deploy |

## Best Practices

1. **Start with tools**: Define what the agent needs, not what you think it needs
2. **Inherit model**: Use `model: inherit` unless you need specific behavior
3. **Test prompts**: Verify agents work as expected before relying on them
4. **Iterate**: Improve agent prompts based on real usage
5. **Document agent usage**: Add README notes on when/how to use each agent
6. **Use built-in agents**: Explore, Plan, General-purpose cover many common cases

## Common Pitfalls

- **Too broad scope**: Agents should focus on one domain, not do everything
- **Missing constraints**: Specify what agents should NOT do
- **Over-permissive tools**: Grant minimal tools needed for the task
- **Unclear descriptions**: Make descriptions specific so Claude knows when to delegate
- **No examples**: Show input/output patterns in prompts

## References

- [Claude Code Documentation](https://docs.anthropic.com/claude/docs/agents)
- [Agent Configuration Guide](https://docs.anthropic.com/claude/docs/agents-configuration)
- [YouTube: Subagents Tutorial](https://www.youtube.com/watch?v=opl0m4SVB80)
