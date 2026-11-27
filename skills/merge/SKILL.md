---
description: Rebase-merge the current branch's PR, retarget any stacked PRs, delete the branch, and pull latest
allowed-tools: Bash(git *) Bash(gh api *)
---

Rebase-merge the current branch into its base. Run these steps in order. Every GitHub call is `gh api` REST: never `gh pr` or `gh repo`, which use GraphQL and fail in Claude Code cloud sessions.

1. **Check branch**: Run `git branch --show-current` and remember the name as `<branch>`.
   - If on `main` or `master`, stop and tell the user there is nothing to merge.

2. **Check for uncommitted changes**: Run `git status --short`.
   - If there are uncommitted or untracked files, stop and tell the user to commit or stash their changes first.

3. **Find the repo and the PR**: Run `git remote get-url origin | sed -E 's#\.git$##; s#.*[:/]([^/]+/[^/]+)$#\1#'` and remember it as `<owner>/<repo>`. Then run `gh api 'repos/<owner>/<repo>/pulls?state=open&head=<owner>:<branch>' --jq '.[] | {number, base: .base.ref}'` and remember them as `<number>` and `<base>`.
   - If it prints nothing, stop and tell the user `<branch>` has no open PR.

4. **Find stacked PRs**: Run `gh api --paginate 'repos/<owner>/<repo>/pulls?state=open&base=<branch>&per_page=100' --jq '.[].number'`.
   - Do this before merging. Once the branch is deleted, GitHub closes any PR that still targets it instead of retargeting it.

5. **Rebase merge**: Run `gh api -X PUT repos/<owner>/<repo>/pulls/<number>/merge -f merge_method=rebase`.
   - Rebase (not squash) preserves per-commit content, so any other branch stacked on top of this one can later run a plain `git rebase <base>` and have its already-merged commits auto-skipped as empty patches, instead of duplicating them.
   - If it fails (HTTP 405: not mergeable, or checks or reviews pending; HTTP 409: the branch moved), stop and show the user GitHub's message.

6. **Retarget stacked PRs**: For each PR number from step 4, run `gh api -X PATCH repos/<owner>/<repo>/pulls/<n> -f base=<base> --jq .base.ref`.
   - This must happen before step 7. Deleting the branch first closes dependent PRs rather than retargeting them.
   - If any retarget fails, stop. Do not run step 7, and tell the user which PRs still target `<branch>` so they can fix it first.

7. **Delete the remote branch**: Run `git push origin --delete <branch>`.
   - Best-effort: some environments (Claude Code cloud sessions) refuse branch deletes. If it fails, warn the user that `<branch>` is still on origin and needs deleting from GitHub, then carry on. The merge already succeeded.

8. **Switch to base and pull**: Run `git checkout <base> && git pull`.

9. **Report success**: show the branch that was merged and confirm the user is now on a clean, up-to-date `<base>`.
   - If the remote delete was refused, repeat that `<branch>` still needs deleting on GitHub.
   - If any PRs were retargeted, list them and remind the user that each stacked branch still needs `git rebase <base>` and `git push --force-with-lease` before its own merge.
