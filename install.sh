#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Install chezmoi
if ! command -v chezmoi &>/dev/null; then
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
fi

# Apply dotfiles
"$HOME/.local/bin/chezmoi" init --apply --source="$DOTFILES_DIR"

export PATH="$HOME/.local/bin:$PATH"

# Install TPM (tmux plugin manager)
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if [ -z $REMOTE_CONTAINERS ]; then
    exit 0
fi

# Dev container only: install mise and tools
if ! command -v mise &>/dev/null; then
    curl https://mise.run | sh
fi

mise install node
mise install
