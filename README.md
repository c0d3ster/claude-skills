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

## Installation

Run the install script to symlink all skills into `~/.claude/skills/`:

```bash
bash install.sh
```

This creates a symlink for each skill directory in this repo under `~/.claude/skills/`, so Claude Code can discover and invoke them.

## Structure

```
claude-skills/
├── skills/
│   ├── branch/
│   │   └── SKILL.md
│   ├── commit/
│   │   └── SKILL.md
│   └── pr/
│       └── SKILL.md
├── install.sh
├── plugin.json
└── README.md
```
