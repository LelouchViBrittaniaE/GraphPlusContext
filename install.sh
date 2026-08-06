#!/usr/bin/env bash
# GraphPlusContext installer
#
#   ./install.sh [VAULT_PATH]
#
# Installs the graph-method and context-vault skills for Claude Code (and Codex, if present),
# scaffolds a context vault, and prints the two config steps that need your hand.
# Default vault path: ~/context-vault
#
# Idempotent. Never overwrites an existing vault. Never edits your settings files for you —
# it prints exactly what to add.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VAULT_PATH="${1:-$HOME/context-vault}"
# Expand ~ and make absolute
VAULT_PATH="${VAULT_PATH/#\~/$HOME}"
VAULT_PATH="$(cd "$(dirname "$VAULT_PATH")" 2>/dev/null && pwd)/$(basename "$VAULT_PATH")" \
  || { echo "error: parent directory of '$VAULT_PATH' does not exist"; exit 1; }

say()  { printf '%s\n' "$*"; }
step() { printf '\n\033[1m%s\033[0m\n' "$*"; }

step "GraphPlusContext → vault at $VAULT_PATH"

# ---------------------------------------------------------------- skills
install_skill() {
  local target_root="$1" name="$2"
  [ -d "$target_root" ] || return 0
  mkdir -p "$target_root/$name"
  sed "s|__VAULT_PATH__|$VAULT_PATH|g" "$REPO_DIR/skills/$name/SKILL.md" \
    > "$target_root/$name/SKILL.md"
  say "  installed $name → $target_root/$name/SKILL.md"
}

step "Installing skills"
for root in "$HOME/.claude/skills" "$HOME/.codex/skills"; do
  if [ -d "$(dirname "$root")" ]; then
    mkdir -p "$root"
    install_skill "$root" graph-method
    install_skill "$root" context-vault
  fi
done
say "  (skills are plain markdown — copy them into any other agent tool that reads a skills dir)"

# ---------------------------------------------------------------- vault
step "Scaffolding vault"
if [ -e "$VAULT_PATH" ]; then
  say "  $VAULT_PATH already exists — leaving it untouched."
  say "  Compare against $REPO_DIR/vault-template/ if you want the newer template files."
else
  mkdir -p "$VAULT_PATH"
  cp -R "$REPO_DIR/vault-template/." "$VAULT_PATH/"
  # Point the templates at the real path
  find "$VAULT_PATH" -name '*.md' -exec sed -i.bak "s|<VAULT>|$VAULT_PATH|g" {} \;
  find "$VAULT_PATH" -name '*.md.bak' -delete
  say "  created $VAULT_PATH (boot.md, README.md, procedures.md, projects/, seats/)"
fi

# ---------------------------------------------------------------- manual steps
step "Two steps left — they touch your config, so they are yours to make"

say ""
say "1. Standing laws in every session. Append to ~/.claude/CLAUDE.md:"
say "     sed 's|__VAULT_PATH__|$VAULT_PATH|g' $REPO_DIR/snippets/CLAUDE.md.snippet >> ~/.claude/CLAUDE.md"
say "   Using Codex or another tool with a global instructions file? Same idea:"
say "     sed 's|__VAULT_PATH__|$VAULT_PATH|g' $REPO_DIR/snippets/AGENTS.md.snippet >> ~/.codex/AGENTS.md"
say ""
say "2. Optional but recommended — inject the live cursor at session start."
say "   Merge the \"hooks\" key from this file into ~/.claude/settings.json:"
say "     $REPO_DIR/snippets/sessionstart-hook.json   (replace __VAULT_PATH__ with $VAULT_PATH)"
say "   Requires jq. Verify with:"
say "     jq -e '.hooks.SessionStart' ~/.claude/settings.json"
say ""
step "Then fill in $VAULT_PATH/boot.md and one projects/<name>/index.md, and you are running."
say "Daily vocabulary:  \"<project>: <what you want>\"  ·  \"wind down\"  ·  \"verify the wind-down for <project>\""
