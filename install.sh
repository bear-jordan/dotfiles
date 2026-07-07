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

# Set login shell: prefer zsh, fall back to bash
set_login_shell() {
  local target=""
  if command -v zsh &>/dev/null; then
    target="$(command -v zsh)"
  elif command -v bash &>/dev/null; then
    target="$(command -v bash)"
  else
    return 0
  fi

  [ "$SHELL" = "$target" ] && return 0

  if [ -r /etc/shells ] && ! grep -qx "$target" /etc/shells; then
    if [ "$(id -u)" = 0 ]; then
      echo "$target" >> /etc/shells
    elif command -v sudo &>/dev/null; then
      echo "$target" | sudo tee -a /etc/shells >/dev/null || return 0
    else
      return 0
    fi
  fi

  command -v chsh &>/dev/null && chsh -s "$target" "$USER" || true
}

set_login_shell

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
  mise exec -- tv update-channels
}

if ! command -v mise &>/dev/null; then
  # musl build: the gnu build needs glibc >= 2.39, newer than debian bookworm's 2.36
  fetch https://mise.run | MISE_INSTALL_MUSL=1 sh
fi

mise_install

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
mise exec -- kubectl krew install oidc-login
exit 0
