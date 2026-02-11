---
name: agent-browser
description: Fast headless browser CLI for AI agents. Supports deterministic element selection via accessibility tree snapshots and refs (@e1, @e2).
allowed-tools: [Read, Write, Bash, Grep, Glob]
tags: [browser-automation, headless-browser, ai-agent, playwright, web-scraping]
platforms: [Claude, Gemini, Codex, ChatGPT]
version: 1.0.0
source: vercel-labs/agent-browser
---

# agent-browser - Headless Browser for AI Agents

## When to use this skill

- Web automation and E2E testing
- Scraping data from modern web apps
- Deterministic element interaction using accessibility tree refs
- Isolated browser sessions for different agent tasks

---

## 1. Installation

```bash
npx skills add vercel-labs/agent-browser
# or
npm install -g agent-browser
agent-browser install
```

---

## 2. Core Workflow (Deterministic Interaction)

AI agents should use the snapshot + ref workflow for best results:

1. **Navigate**: `agent-browser open <url>`
2. **Snapshot**: `agent-browser snapshot -i` (Returns tree with refs like @e1, @e2)
3. **Interact**: `agent-browser click @e1` or `agent-browser fill @e2 "text"`
4. **Repeat**: Snapshot again if page changes

---

## 3. Key Commands

| Command | Description |
|---------|-------------|
| `open <url>` | Navigate to a URL |
| `snapshot` | Get accessibility tree with refs |
| `click <sel>` | Click element (by ref or CSS) |
| `fill <sel> <text>` | Clear and fill input |
| `screenshot [path]` | Take page screenshot |
| `close` | Quit browser session |

---

## 4. Advanced Features

- **Isolated Sessions**: Use `--session <name>` to isolate cookies/storage.
- **Persistent Profiles**: Use `--profile <path>` to persist login sessions.
- **Semantic Locators**: `find role button click --name "Submit"`
- **JavaScript Execution**: `eval "window.scrollTo(0, 100)"`

---

## Quick Reference

```bash
# Optimal AI Workflow
agent-browser open example.com
agent-browser snapshot -i --json
# (AI parses refs)
agent-browser click @e2
```
