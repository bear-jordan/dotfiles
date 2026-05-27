alias c="clear"
alias cm-sync="chezmoi update"
alias cm="chezmoi"
alias k="kubectl"
alias lg="lazygit"
alias ll="ls -alh"
alias u="uv run"
alias ls="ls --color=auto"
alias st="tmux source-file ~/.config/tmux/tmux.conf"
alias p="podman"
alias pc="podman-compose"

if [ -n "$BASH_VERSION" ]; then
    alias sb="source ~/.bashrc"
elif [ -n "$ZSH_VERSION" ]; then
    alias sb="source ~/.zshrc"
fi

function cd_up() {
    cd "$(printf "%0.s../" $(seq 1 "${1:-1}"))"
}
alias 'cd..'='cd_up'
