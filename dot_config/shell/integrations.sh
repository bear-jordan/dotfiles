set -o vi

if [ -n "$BASH_VERSION" ]; then
    _shell="bash"
elif [ -n "$ZSH_VERSION" ]; then
    _shell="zsh"
    autoload -Uz compinit && compinit
fi

if [ "$(uname -s)" = "Darwin" ]; then
    if [ -x /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -x /usr/local/bin/brew ]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
    eval "$(sesh completion "$_shell")"
else
    eval "$(mise activate "$_shell")"
fi
eval "$(starship init "$_shell")"
eval "$(zoxide init "$_shell")"
eval "$(yq shell-completion "$_shell")"

unset _shell
