---
description: Stage, commit, and push changes using Angular commit format
allowed-tools: Bash(git *) Skill(branch)
---

Stage, commit, and push changes following Angular commit format: `type(scope): subject`

**Types:** feat, fix, docs, style, refactor, perf, test, chore
**Rules:**
- Subject: lowercase, imperative mood, no trailing period, under 72 chars
- Scope: optional, refers to the module/area changed (e.g. `feat(auth): ...`)
- Add a body for breaking changes or non-obvious context

**Flags:**
- `--no-push`: skip pushing after committing

**Steps:**
1. Run `git branch --show-current`. If on `main` or `master`, use the Skill tool to invoke the `branch` skill before continuing.
2. `git status` to see what changed
3. `git diff` to understand the changes
4. Stage relevant files
5. Commit with the formatted message
6. Unless `--no-push` was passed, run `git push -u origin <branch>` to push the branch
