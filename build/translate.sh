#!/usr/bin/env bash
# translate.sh - Generate OpenCode-compatible files from Claude Code plugin sources
#
# Usage: ./build/translate.sh
#
# This script translates Claude Code plugin commands and agents into
# OpenCode-compatible format:
#   - Commands: /pm:command → /pm-command naming
#   - Agents: Claude frontmatter → OpenCode frontmatter
#   - Strips allowed-tools/argument-hint from frontmatter
#   - Adjusts model references (sonnet → anthropic/claude-sonnet, etc.)
#
# Output goes to .opencode/commands/ and .opencode/agents/

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
OPENCODE_DIR="$PLUGIN_ROOT/.opencode"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[translate]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[translate]${NC} $1"; }
log_error() { echo -e "${RED}[translate]${NC} $1"; }

# Create output directories
mkdir -p "$OPENCODE_DIR/commands"
mkdir -p "$OPENCODE_DIR/agents"

# ─────────────────────────────────────────────
# Translate commands
# ─────────────────────────────────────────────

command_count=0

for cmd_file in "$PLUGIN_ROOT/commands/"*.md; do
  basename="$(basename "$cmd_file" .md)"

  # Map command filenames: pm.md stays pm.md, others get pm- prefix
  if [[ "$basename" == "pm" ]]; then
    out_name="pm.md"
  else
    out_name="pm-${basename}.md"
  fi

  out_path="$OPENCODE_DIR/commands/$out_name"

  # Extract description from frontmatter
  description=$(sed -n '/^---$/,/^---$/{ /^description:/{ s/^description: *//; p; } }' "$cmd_file")

  if [[ -z "$description" ]]; then
    log_warn "Skipping $basename (no description)"
    continue
  fi

  # Build simplified frontmatter
  {
    echo "---"
    echo "description: $description"
    echo "---"
    echo ""
  } > "$out_path"

  # Extract body (everything after second ---)
  # and apply command name translations
  awk 'BEGIN{c=0} /^---$/{c++; if(c==2) { getline; found=1 } } found{print}' "$cmd_file" | \
    sed 's|/pm:|/pm-|g' | \
    sed 's|/design:|/pm-|g' | \
    sed 's|/backlog:|/pm-|g' >> "$out_path"

  command_count=$((command_count + 1))
  log_info "Translated command: $basename → $out_name"
done

# ─────────────────────────────────────────────
# Translate agents
# ─────────────────────────────────────────────

agent_count=0

for agent_file in "$PLUGIN_ROOT/agents/"*.md; do
  basename="$(basename "$agent_file" .md)"
  out_path="$OPENCODE_DIR/agents/$basename.md"

  # Extract description and model from Claude frontmatter
  description=$(sed -n '/^---$/,/^---$/{ /^description:/{ s/^description: *//; p; } }' "$agent_file")
  model=$(sed -n '/^---$/,/^---$/{ /^model:/{ s/^model: *//; p; } }' "$agent_file")

  if [[ -z "$description" ]]; then
    log_warn "Skipping agent $basename (no description)"
    continue
  fi

  # Map model names
  case "$model" in
    sonnet) oc_model="anthropic/claude-sonnet" ;;
    haiku)  oc_model="anthropic/claude-haiku" ;;
    opus)   oc_model="anthropic/claude-opus" ;;
    *)      oc_model="anthropic/claude-sonnet" ;;
  esac

  # Build OpenCode frontmatter
  {
    echo "---"
    echo "description: $description"
    echo "mode: subagent"
    echo "model: $oc_model"
    echo "tools:"
    echo "  read: true"
    echo "  glob: true"
    echo "  grep: true"
    echo "  bash: true"
    echo "  write: false"
    echo "  edit: false"
    echo "---"
    echo ""
  } > "$out_path"

  # Extract body and apply command name translations
  awk 'BEGIN{c=0} /^---$/{c++; if(c==2) { getline; found=1 } } found{print}' "$agent_file" | \
    sed 's|/pm:|/pm-|g' >> "$out_path"

  agent_count=$((agent_count + 1))
  log_info "Translated agent: $basename"
done

# ─────────────────────────────────────────────
# Summary
# ─────────────────────────────────────────────

echo ""
log_info "Translation complete!"
log_info "  Commands: $command_count → $OPENCODE_DIR/commands/"
log_info "  Agents:   $agent_count → $OPENCODE_DIR/agents/"
