#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Install chezmoi
if ! command -v chezmoi &>/dev/null; then
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
fi

# Apply dotfiles
"$HOME/.local/bin/chezmoi" init --apply --source="$DOTFILES_DIR"

# Install mise
if ! command -v mise &>/dev/null; then
    curl https://mise.run | sh
fi

export PATH="$HOME/.local/bin:$PATH"

# Install node first (required for npm-based mason LSP servers)
mise install node

# Install remaining tools
mise install
