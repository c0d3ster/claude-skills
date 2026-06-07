#!/usr/bin/env bash
set -euo pipefail

SKILLS_DIR="${HOME}/.claude/skills"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Git Bash on Windows defaults to copying directories for `ln -s` unless
# winsymlinks is set to native mode. Developer Mode alone is not enough.
if [[ -n "${MSYSTEM:-}" || "${OSTYPE:-}" == msys* ]]; then
  export MSYS="${MSYS:-winsymlinks:nativestrict}"
fi

mkdir -p "$SKILLS_DIR"

link_skill() {
  local skill_dir="$1"
  local skill_name="$2"
  local target="$SKILLS_DIR/$skill_name"

  if [[ -L "$target" ]]; then
    if [[ "$(readlink "$target")" == "$skill_dir" ]]; then
      echo "Already linked: $skill_name"
      return
    fi
    rm "$target"
    echo "Replacing stale link: $skill_name"
  elif [[ -e "$target" ]]; then
    rm -rf "$target"
    echo "Replacing copy with symlink: $skill_name"
  fi

  ln -s "$skill_dir" "$target"
  echo "Linked: $skill_name -> $skill_dir"
}

for skill_dir in "$REPO_DIR"/skills/*/; do
  skill_name="$(basename "$skill_dir")"

  # Skip non-skill directories (no SKILL.md)
  [[ ! -f "$skill_dir/SKILL.md" ]] && continue

  link_skill "$skill_dir" "$skill_name"
done

echo "Done."
