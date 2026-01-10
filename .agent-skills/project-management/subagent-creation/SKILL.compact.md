# subagent-creation

> Create and configure Claude Code subagents for specialized task delegation. Use when defining expert AI assistants with focused responsibilities, c...

## When to use this skill
• Defining specialized AI experts for specific tasks
• Creating reusable agent configurations for team workflows
• Implementing task delegation patterns
• Setting up automated code review, debugging, or analysis workflows
• Creating agents with custom prompts and tool permissions

## Instructions
▶ S1: Understanding Subagents
Claude Code subagents are pre-configured AI experts that the main Claude delegates work to.
**Core benefits**:
• **Context isolation**: Each agent has separate 200K token context
• **Specialized expertise**: Focused prompts for specific domains
• **Reusability**: Share agents via Git across projects
• **Flexible permissions**: Control which tools each agent can use
• **No nesting**: Prevents infinite loops - subagents cannot spawn more subagents
**Agent types**:
• **Built-in agents**: Explore (read-only, Haiku), Plan (research), General-purpose (Sonnet)
• **Custom agents**: User-defined with custom prompts and permissions
▶ S2: Agent Configuration File
Subagents are defined as Markdown files with YAML frontmatter.
**File location** (priority order):
1. Project-level: `.claude/agents/{agent-name}.md`
2. User-level: `~/.claude/agents/{agent-name}.md`
**File format**:
