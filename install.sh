#!/usr/bin/env bash
# Northern Forest Terminal - Install Script
# Backs up existing configs before overwriting.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/.config/northern-forest-backup-$(date +%Y%m%d%H%M%S)"

backup() {
  local src="$1"
  if [[ -e "$src" ]]; then
    mkdir -p "$BACKUP_DIR"
    cp -r "$src" "$BACKUP_DIR/"
    echo "  Backed up $src -> $BACKUP_DIR/"
  fi
}

echo "=== Northern Forest Terminal - Installer ==="
echo ""

# --- Ghostty ---
echo "[1/3] Ghostty config"
backup "$HOME/.config/ghostty/config"
mkdir -p "$HOME/.config/ghostty"
cp "$REPO_DIR/ghostty/config" "$HOME/.config/ghostty/config"
echo "  Installed ghostty/config"

# --- Starship ---
echo "[2/3] Starship config"
backup "$HOME/.config/starship.toml"
cp "$REPO_DIR/starship/starship.toml" "$HOME/.config/starship.toml"
echo "  Installed starship.toml"

# --- Zsh ---
echo "[3/3] Zsh config"
backup "$HOME/.zshrc"
backup "$HOME/.zshenv"
cp "$REPO_DIR/zsh/.zshrc" "$HOME/.zshrc"
cp "$REPO_DIR/zsh/.zshenv" "$HOME/.zshenv"
echo "  Installed .zshrc and .zshenv"

echo ""
if [[ -d "$BACKUP_DIR" ]]; then
  echo "Backups saved to: $BACKUP_DIR"
fi
echo "Done! Restart your terminal to see the changes."
