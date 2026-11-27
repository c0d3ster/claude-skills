---
description: Create a pull request, branching and committing first if needed
disable-model-invocation: true
allowed-tools: Bash(git *) Bash(gh api *) Skill(branch) Skill(commit)
---

Create a pull request. Run these steps in order. Every GitHub call is `gh api` REST: never `gh pr` or `gh repo`, which use GraphQL and fail in Claude Code cloud sessions.

1. **Check branch**: Run `git branch --show-current`.
   - If on `main` or `master`, use the Skill tool to invoke the `branch` skill before continuing.

2. **Check for uncommitted changes**: Run `git status --short`.
   - If there are uncommitted or untracked files, use the Skill tool to invoke the `commit` skill before continuing.

3. **Find the repo**: Run `git remote get-url origin | sed -E 's#\.git$##; s#.*[:/]([^/]+/[^/]+)$#\1#'` and remember it as `<owner>/<repo>`. Get the default branch with `gh api repos/<owner>/<repo> --jq .default_branch` and remember it as `<base>`.

4. **Push and create PR**: Run `git push -u origin <branch>`, then open the PR with a descriptive title and a body summarizing the changes, the body in a HEREDOC:

   ```bash
   gh api -X POST repos/<owner>/<repo>/pulls -f head=<branch> -f base=<base> -f title='<title>' -F body=@- --jq .html_url <<'EOF'
   <body>
   EOF
   ```

   Show the user the URL it prints.
