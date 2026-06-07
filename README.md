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
3. Pushes the branch and opens a PR via `gh pr create`

## Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) installed and running
- [GitHub CLI (`gh`)](https://cli.github.com/) installed and authenticated (`gh auth login`) — required by `/pr`
- Git configured with a remote

## Installation

Clone this repo, then run the install script:

```bash
bash install.sh
```

This symlinks each skill directory into `~/.claude/skills/` so Claude Code can discover and invoke them.

> **Windows note:** `ln -s` requires Developer Mode enabled or an elevated terminal. To enable it: Settings > System > For Developers > Developer Mode. Alternatively, run the terminal as Administrator.

## Usage

Open Claude Code inside any git repo and invoke a skill by name:

```
/branch
/commit
/pr
```
