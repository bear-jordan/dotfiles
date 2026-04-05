#!/usr/bin/env bash
# Resets install.sh state for testing. Removes all managed packages and dotfiles.
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "==> Removing chezmoi-managed dotfiles..."
if command -v chezmoi &>/dev/null; then
    chezmoi managed --include=files | while read -r file; do
        [ -f "$file" ] && rm -f "$file" && echo "  removed $file"
    done
    chezmoi managed --include=dirs | sort -r | while read -r dir; do
        [ -d "$dir" ] && rmdir "$dir" 2>/dev/null && echo "  removed $dir"
    done
fi

echo "==> Removing chezmoi binary..."
rm -f "$HOME/.local/bin/chezmoi"

echo "==> Removing TPM..."
rm -rf "$HOME/.tmux/plugins/tpm"

echo "==> Uninstalling Homebrew packages..."
if command -v brew &>/dev/null; then
    brew uninstall --force $(brew bundle list --brews --file="$DOTFILES_DIR/Brewfile") 2>/dev/null || true
    brew uninstall --cask --force $(brew bundle list --casks --file="$DOTFILES_DIR/Brewfile") 2>/dev/null || true
fi

echo "==> Done. Run ./install.sh to reinstall."
