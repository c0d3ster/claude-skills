---
description: Squash merge the current branch's PR into main, delete the branch, and pull latest
allowed-tools: Bash(git *) Bash(gh *)
---

Squash merge the current branch into main. Run these steps in order:

1. **Check branch**: Run `git branch --show-current`.
   - If on `main` or `master`, stop and tell the user there is nothing to merge.

2. **Check for uncommitted changes**: Run `git status --short`.
   - If there are uncommitted or untracked files, stop and tell the user to commit or stash their changes first.

3. **Check for open PR**: Run `gh pr view --json number,title,state`.
   - If no open PR exists, stop and tell the user to create a PR first (hint: `/pr`).

4. **Confirm with user**: Show the PR title and branch name, then ask the user to confirm before merging.

5. **Squash merge**: Run `gh pr merge --squash --delete-branch`.
   - This merges the PR on GitHub and deletes the remote branch.

6. **Switch to main and pull**: Run `git checkout main && git pull`.

7. **Delete local branch**: Run `git branch -d <branch-name>` using the branch name from step 1.
   - If it fails (unmerged warning), use `-D` since the squash merge won't be detected by git.

8. Report success: show the branch that was merged and confirm the user is now on a clean, up-to-date `main`.
