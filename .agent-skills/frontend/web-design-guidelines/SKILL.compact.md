---
name: web-design-guidelines
description: Review UI code for Web Interface Guidelines compliance
---

# Web Design Guidelines Review

## Core Workflow
1. **Fetch Guidelines**: WebFetch `https://raw.githubusercontent.com/vercel-labs/web-interface-guidelines/main/command.md`
2. **Read Files**: User-specified files or patterns
3. **Apply Rules**: Check against all fetched guidelines
4. **Output**: `file:line` format violations

## Input
- File path or glob pattern (e.g., `src/**/*.tsx`)

## Output Format
```
src/Button.tsx:15 - Button should have aria-label
src/Modal.tsx:42 - Modal should trap focus
```

## Key Rules
- Always fetch fresh guidelines before review
- Apply ALL rules from fetched content
- Report violations with exact file:line location

## References
- [Vercel Web Interface Guidelines](https://github.com/vercel-labs/web-interface-guidelines)
