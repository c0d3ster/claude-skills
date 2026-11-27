# claude-skills

Custom skills for [Claude Code](https://github.com/anthropics/claude-code).

## Skills

### `/branch`
Creates a new git branch with a type-prefixed kebab-case name.

- Infers the type prefix and description from staged changes if they exist
- Prompts if no changes and no description is provided
- Format: `type/kebab-case-description` (max 50 chars)
- Types: `feat`, `fix`, `chore`, `refactor`, `docs`, `test`, `hotfix`

### `/commit`
Stages and commits changes using Angular commit format.

- Format: `type(scope): subject`
- Subject: lowercase, imperative mood, no trailing period, under 72 chars
- Types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`

### `/pr`
Creates a pull request, automatically chaining `/branch` and `/commit` as needed.

1. If on `main` or `master`, calls `/branch` first
2. If there are uncommitted changes, calls `/commit` first
3. Pushes the branch and opens a PR against the default branch via the REST API (`gh api`)

### `/merge`
Rebase-merges the current branch's PR, retargets any PRs stacked on it, then cleans up.

1. Stops if on `main`/`master` or if there are uncommitted changes
2. Lists open PRs stacked on this branch (their base is this branch)
3. Rebase merges the PR through the REST API
4. Retargets each stacked PR to this PR's base
5. Deletes the remote branch (best-effort: a refused delete warns and carries on), then switches to the base branch and pulls

Retargeting happens before the branch is deleted because deleting it first closes stacked PRs instead of retargeting them.

### `/complete`
Closes out the current session. Makes no further edits or tool calls, and replies with a single `result:` line, which is what marks a background session as completed on the agent dashboard.

## Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) installed and running
- [GitHub CLI (`gh`)](https://cli.github.com/) installed and authenticated (`gh auth login`), required by `/pr` and `/merge`. They call only `gh api` REST, never `gh pr`, so they also work in Claude Code cloud sessions, which block GitHub GraphQL.
- Git configured with a remote

## Installation

Clone this repo, then run the install script:

```bash
bash install.sh
```

This symlinks each skill directory into `~/.claude/skills/` so Claude Code can discover and invoke them.

> **Git Bash on Windows:** Enable Developer Mode (Settings > System > For developers > Developer Mode). Git Bash also needs `MSYS=winsymlinks:nativestrict` for `ln -s` to create real symlinks instead of copying directories — `install.sh` sets this automatically. If you previously ran install and got copies, remove them first: `rm -rf ~/.claude/skills/{branch,commit,merge,pr}` then re-run `bash install.sh`.

## Usage

Open Claude Code inside any git repo and invoke a skill by name:

```
/branch
/commit
/pr
/merge
```
