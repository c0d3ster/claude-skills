---
description: Create a new git branch with a descriptive kebab-case name
allowed-tools: Bash(git *)
---

Create a new git branch with a type prefix (e.g. `feat/user-auth`, `fix/login-redirect`).

**Type prefixes:** feat, fix, chore, refactor, docs, test, hotfix

**Steps:**
1. Run `git diff HEAD --stat` to check for existing changes
   - If changes exist, infer the type prefix and a short description from the diff
   - If no changes exist and no description in $ARGUMENTS, ask the user: "What type and description? (e.g. feat: user auth)"
2. Build the branch name: `type/kebab-case-description`, under 50 chars total, no special characters
3. Run `git checkout -b <name>`
