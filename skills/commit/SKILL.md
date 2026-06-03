---
description: Stage and commit changes using Angular commit format
allowed-tools: Bash(git *)
---

Create a git commit following Angular commit format: `type(scope): subject`

**Types:** feat, fix, docs, style, refactor, perf, test, chore
**Rules:**
- Subject: lowercase, imperative mood, no trailing period, under 72 chars
- Scope: optional, refers to the module/area changed (e.g. `feat(auth): ...`)
- Add a body for breaking changes or non-obvious context

**Steps:**
1. `git status` to see what changed
2. `git diff` to understand the changes
3. Stage relevant files
4. Commit with the formatted message
