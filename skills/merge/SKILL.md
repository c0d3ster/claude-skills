---
description: Rebase-merge the current branch's PR, retarget any stacked PRs, delete the branch, and pull latest
allowed-tools: Bash(git *) Bash(gh *)
---

Rebase-merge the current branch into main. Run these steps in order:

1. **Check branch**: Run `git branch --show-current` and remember the name as `<branch>`.
   - If on `main` or `master`, stop and tell the user there is nothing to merge.

2. **Check for uncommitted changes**: Run `git status --short`.
   - If there are uncommitted or untracked files, stop and tell the user to commit or stash their changes first.

3. **Find stacked PRs**: Get this PR's base with `gh pr view --json baseRefName --jq .baseRefName` (call it `<base>`), then list open PRs stacked on this branch with `gh pr list --base <branch> --state open --json number --jq '.[].number'`.
   - Do this before merging. Once the branch is deleted, GitHub closes any PR that still targets it instead of retargeting it.

4. **Rebase merge**: Run `gh pr merge --rebase`. Do not pass `--delete-branch`.
   - Rebase (not squash) preserves per-commit content, so any other branch stacked on top of this one can later run a plain `git rebase <base>` and have its already-merged commits auto-skipped as empty patches, instead of duplicating them.

5. **Retarget stacked PRs**: For each PR number from step 3, run `gh pr edit <number> --base <base>`.
   - This must happen before step 6. `gh pr merge --delete-branch` deletes the branch through the API, which closes dependent PRs rather than retargeting them.
   - If any retarget fails, stop. Do not run step 6, and tell the user which PRs still target `<branch>` so they can fix it first.

6. **Delete the remote branch**: Run `git push origin --delete <branch>`.

7. **Switch to base and pull**: Run `git checkout <base> && git pull`.

8. **Report success**: show the branch that was merged and confirm the user is now on a clean, up-to-date `<base>`.
   - If any PRs were retargeted, list them and remind the user that each stacked branch still needs `git rebase <base>` and `git push --force-with-lease` before its own merge.
