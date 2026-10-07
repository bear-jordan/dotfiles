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
    command -v sesh >/dev/null && eval "$(sesh completion "$_shell")"
else
    command -v mise >/dev/null && eval "$(mise activate "$_shell")"
fi
command -v starship >/dev/null && eval "$(starship init "$_shell")"
command -v zoxide >/dev/null && eval "$(zoxide init "$_shell")"
command -v yq >/dev/null && eval "$(yq shell-completion "$_shell")"
command -v direnv >/dev/null && eval "$(direnv hook "$_shell")"

unset _shell
