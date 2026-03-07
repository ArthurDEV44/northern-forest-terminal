#!/usr/bin/env bash
# Northern Forest Terminal - macOS Installer
# Installs dependencies via Homebrew, copies configs, and backs up existing files.

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

echo "=== Northern Forest Terminal - macOS Installer ==="
echo ""

# ---- Homebrew check ----
if ! command -v brew &>/dev/null; then
  echo "Homebrew is required but not installed."
  echo "Install it from https://brew.sh"
  exit 1
fi

# ---- Dependencies ----
echo "[1/4] Checking dependencies"

install_formula() {
  if brew list "$1" &>/dev/null; then
    echo "  $1 already installed"
  else
    echo "  Installing $1..."
    brew install "$1"
  fi
}

install_cask() {
  if brew list --cask "$1" &>/dev/null; then
    echo "  $1 already installed"
  else
    echo "  Installing $1..."
    brew install --cask "$1"
  fi
}

install_cask ghostty
install_formula starship
install_formula fastfetch
install_formula zsh-autosuggestions
install_formula zsh-syntax-highlighting
install_cask font-jetbrains-mono-nerd-font

# ---- Ghostty ----
echo "[2/4] Ghostty config"
backup "$HOME/.config/ghostty/config"
mkdir -p "$HOME/.config/ghostty"
# Remove Linux-specific shell command — macOS uses the default shell (zsh)
sed '/^command = /d' "$REPO_DIR/ghostty/config" > "$HOME/.config/ghostty/config"
echo "  Installed ghostty/config"

# ---- Starship ----
echo "[3/4] Starship config"
backup "$HOME/.config/starship.toml"
cp "$REPO_DIR/starship/starship.toml" "$HOME/.config/starship.toml"
echo "  Installed starship.toml"

# ---- Zsh ----
echo "[4/4] Zsh config"
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
