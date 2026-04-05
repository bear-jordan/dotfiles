#!/usr/bin/env bash
# Resets install.sh state for testing. Does NOT touch Homebrew or system packages.
set -e

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

echo "==> Done. Run ./install.sh to reinstall."
