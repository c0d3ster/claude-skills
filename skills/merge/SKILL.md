---
description: Rebase-merge the current branch's PR into main, delete the branch, and pull latest
allowed-tools: Bash(git *) Bash(gh *)
---

Rebase-merge the current branch into main. Run these steps in order:

1. **Check branch**: Run `git branch --show-current`.
   - If on `main` or `master`, stop and tell the user there is nothing to merge.

2. **Check for uncommitted changes**: Run `git status --short`.
   - If there are uncommitted or untracked files, stop and tell the user to commit or stash their changes first.

3. **Rebase merge**: Run `gh pr merge --rebase --delete-branch`.
   - This replays the branch's commits onto main and deletes the remote branch.
   - Rebase (not squash) preserves per-commit content, so any other branch stacked on top of this one can later run a plain `git rebase main` and have its already-merged commits auto-skipped as empty patches, instead of duplicating them.

4. **Switch to main and pull**: Run `git checkout main && git pull`.

5. **Report success**: show the branch that was merged and confirm the user is now on a clean, up-to-date `main`.
