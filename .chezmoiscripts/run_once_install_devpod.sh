#!/usr/bin/env bash
set -euo pipefail

LOCAL_BIN="$HOME/.local/bin"
DEVPOD_BIN="$LOCAL_BIN/devpod"

if [ -x "$DEVPOD_BIN" ]; then
  echo "Devpod already installed"
  exit 0
fi

echo "Installing Devpod..."
curl -L -o devpod "https://github.com/loft-sh/devpod/releases/latest/download/devpod-linux-amd64" && sudo install -c -m 0755 devpod "$LOCAL_BIN" && rm -f devpod

devpod ide use none

devpod context set-options -o DOTFILES_URL=https://github.com/bear-jordan/dotfiles.git
