#!/usr/bin/env bash
#
# load.sh — Extract skills from origin/terminal-skills into a local cache.
#
# Usage: bash load.sh
#
# Each skill directory under .claude/skills/ that contains a SKILL.md
# is copied to /tmp/<repo>/terminal-skills/<skill-name>/.
# Already-cached skills are skipped.
#
set -e

# ── Config ──────────────────────────────────────────────────────────
REPO_NAME="$(basename "$(git rev-parse --show-toplevel)")"
CACHE_DIR="/tmp/${REPO_NAME}/terminal-skills"
BRANCH="origin/terminal-skills"

# ── Preflight: make sure the remote branch exists ───────────────────
if ! git show-ref --verify "refs/remotes/${BRANCH}" >/dev/null 2>&1; then
  echo "ERROR: No ${BRANCH} branch found. Run: git fetch origin"
  exit 1
fi

# ── Discover and extract skills ─────────────────────────────────────
LOADED=""

for skill_dir in $(git ls-tree --name-only "$BRANCH" .claude/skills/); do
  # Only process directories that contain a SKILL.md
  git ls-tree -r --name-only "$BRANCH" "${skill_dir}/" | grep -q SKILL.md || continue

  skill_name="$(basename "$skill_dir")"
  dest="${CACHE_DIR}/${skill_name}"

  # Skip if already cached
  if [ -d "$dest" ]; then
    LOADED="${LOADED}${skill_name} (cached) "
    continue
  fi

  # Extract via git-archive into a temp dir, then move into the cache
  tmp="$(mktemp -d)"
  git archive "$BRANCH" -- "${skill_dir}/" | tar -x -C "$tmp"
  mkdir -p "$CACHE_DIR"
  cp -r "$tmp/${skill_dir}" "$dest"
  rm -rf "$tmp"

  LOADED="${LOADED}${skill_name} (extracted) "
done

# ── Summary ─────────────────────────────────────────────────────────
echo "Skills loaded to ${CACHE_DIR}: ${LOADED}"
