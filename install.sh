#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Install chezmoi
if ! command -v chezmoi &>/dev/null; then
    if command -v curl &>/dev/null; then
        sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
    else
        sh -c "$(wget -qO- get.chezmoi.io)" -- -b "$HOME/.local/bin"
    fi
fi

# Apply dotfiles
"$HOME/.local/bin/chezmoi" init --apply --force --source="$DOTFILES_DIR"

export PATH="$HOME/.local/bin:$PATH"

# Install TPM (tmux plugin manager)
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if [ -z $REMOTE_CONTAINERS ]; then
    echo "Installing for host systems."
    exit 0
fi
echo "Installing for devcontainers."

# Dev container only: install mise and tools
if ! command -v mise &>/dev/null; then
    if command -v curl &>/dev/null; then
        curl https://mise.run | sh
    else
        wget -qO- https://mise.run | sh
    fi
fi

mise install node
mise install
tv channel update
