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

# --- dev container: config files and the shared mise tools, nothing else ---
if [ -n "$REMOTE_CONTAINERS" ]; then
  echo "Installing for devcontainers."

  # chezmoi --force replaces ~/.bashrc, dropping whatever postCreateCommand appended to it
  # (infrastructure's TF_VAR exports). Carry the non-skel lines into local.sh, which
  # dot_bashrc sources and chezmoi leaves alone.
  if [ -f "$HOME/.bashrc" ]; then
    mkdir -p "$HOME/.config/shell"
    grep -vxFf <(cat /etc/skel/.bashrc "$DOTFILES_DIR/dot_bashrc" 2>/dev/null) "$HOME/.bashrc" \
      >>"$HOME/.config/shell/local.sh" || true
  fi

  sh -c "$(fetch get.chezmoi.io)" -- -b "$HOME/.local/bin" \
    init --apply --force --purge-binary --source="$DOTFILES_DIR"

  if ! command -v mise &>/dev/null; then
    # musl build: the gnu build needs glibc >= 2.39
    fetch https://mise.run | MISE_INSTALL_MUSL=1 sh
  fi
  export PATH="$HOME/.local/bin:$PATH"
  mise install
  mise exec -- tv update-channels
  exit 0
fi

# --- host ---
echo "Installing for host systems."

if ! command -v chezmoi &>/dev/null; then
  sh -c "$(fetch get.chezmoi.io)" -- -b "$HOME/.local/bin"
fi

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

exit 0
