#!/usr/bin/env bash
set -euo pipefail

BREW_BIN="/home/linuxbrew/.linuxbrew/bin/brew"

if [ -x "$BREW_BIN" ]; then
  echo "Homebrew already installed"
  exit 0
fi

echo "Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

