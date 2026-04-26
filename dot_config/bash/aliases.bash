alias c="clear"
alias cm-sync="chezmoi update"
alias cm="chezmoi"
alias k="kubectl"
alias lg="lazygit"
alias ll="ls -alh"
alias ls="ls --color=auto"
alias sb="source ~/.bashrc"
alias st="tmux source-file ~/.config/tmux/tmux.conf"

function cd_up() {
    cd "$(printf "%0.s../" $(seq 1 "${1:-1}"))"
}
alias 'cd..'='cd_up'
