# manual-plugins

Claude Code plugins managed by BlackArrowLabsInc.

## Plugins

### load-skills

Loads skills from a repo's `origin/terminal-skills` branch into a local cache (`/tmp/<repo>/terminal-skills/`) so Claude can read them before starting work.

### File overview

| File | Purpose |
|------|---------|
| `.claude-plugin/marketplace.json` | Marketplace manifest — registers this repo as a plugin source |
| `load-skills/.claude-plugin/plugin.json` | Plugin metadata (name, version, author, skills path) |
| `load-skills/scripts/load.sh` | Bash script that extracts skill directories from `origin/terminal-skills` via `git archive` and caches them locally |
| `load-skills/skills/load-skills/SKILL.md` | Skill definition — tells Claude to run `load.sh` then read each cached `SKILL.md` before doing any work |

## Installation

```sh
/plugin marketplace add BlackArrowLabsInc/manual-plugins
/plugin install load-skills@BlackArrowLabsInc-load-skills
```
