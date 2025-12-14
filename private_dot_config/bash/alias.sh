alias ls="ls --color"
alias c="clear"
alias ll="ls -al"
alias pytree="tree -I venv -I __pycache__"
alias ff="fastfetch"
alias tms="tmux-sessionizer"
alias sb="source ~/.bashrc"
alias k="kubectl"
alias a="arduino-cli"

function cd_up() {
    cd $(printf "%0.s../" $(seq 1 $1))
}
alias 'cd..'='cd_up'

