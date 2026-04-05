alias ls="ls --color=auto"
alias ll="ls -alh"
alias c="clear"
alias k="kubectl"
alias sb="source ~/.bashrc"
alias cm="chezmoi"
alias cm-sync="chezmoi update"

function cd_up() {
    cd "$(printf "%0.s../" $(seq 1 "$1"))"
}
alias 'cd..'='cd_up'
