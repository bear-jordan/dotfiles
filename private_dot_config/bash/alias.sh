alias ls="ls --color"
alias c="clear"
alias ll="ls -al"
alias pytree="tree -I venv -I __pycache__"
alias tms="tmux-sessionizer"
alias sb="source ~/.bashrc"
alias cm="chezmoi"

function cd_up() {
    cd $(printf "%0.s../" $(seq 1 $1))
}
alias 'cd..'='cd_up'

