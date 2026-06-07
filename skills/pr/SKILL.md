---
description: Create a pull request, branching and committing first if needed
disable-model-invocation: true
allowed-tools: Bash(git *) Bash(gh *) Skill(branch) Skill(commit)
---

Create a pull request. Run these steps in order:

1. **Check branch**: Run `git branch --show-current`.
   - If on `main` or `master`, use the Skill tool to invoke the `branch` skill before continuing.

2. **Check for uncommitted changes**: Run `git status --short`.
   - If there are uncommitted or untracked files, use the Skill tool to invoke the `commit` skill before continuing.

3. **Push and create PR**: Push the branch upstream, then run `gh pr create` with a descriptive title and body summarizing the changes. Use a HEREDOC for the body.
