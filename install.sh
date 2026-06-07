#!/usr/bin/env bash
set -euo pipefail

SKILLS_DIR="${HOME}/.claude/skills"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$SKILLS_DIR"

for skill_dir in "$REPO_DIR"/skills/*/; do
  skill_name="$(basename "$skill_dir")"

  # Skip non-skill directories (no SKILL.md)
  [[ ! -f "$skill_dir/SKILL.md" ]] && continue

  target="$SKILLS_DIR/$skill_name"

  if [[ -L "$target" ]]; then
    echo "Already linked: $skill_name"
  elif [[ -e "$target" ]]; then
    echo "Skipping $skill_name — target exists and is not a symlink: $target"
  else
    ln -s "$skill_dir" "$target"
    echo "Linked: $skill_name -> $target"
  fi
done

echo "Done."
