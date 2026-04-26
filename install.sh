#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

fetch() {
    if command -v curl &>/dev/null; then
        curl -fsLS "$1"
    else
        wget -qO- "$1"
    fi
}

# Install chezmoi
if ! command -v chezmoi &>/dev/null; then
    sh -c "$(fetch get.chezmoi.io)" -- -b "$HOME/.local/bin"
fi

# Apply dotfiles
"$HOME/.local/bin/chezmoi" init --apply --force --source="$DOTFILES_DIR"

export PATH="$HOME/.local/bin:$PATH"

# Install TPM (tmux plugin manager)
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if [ -z "$REMOTE_CONTAINERS" ]; then
    echo "Installing for host systems."
    exit 0
fi
echo "Installing for devcontainers."

# Dev container only: install mise and tools
mise_install() {
    mise install
    mise exec -- tv channel update
}

if ! command -v mise &>/dev/null; then
    fetch https://mise.run | sh
fi

mise_install
