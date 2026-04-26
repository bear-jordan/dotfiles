set -o vi

if [[ "$(uname -s)" == "Darwin" ]]; then
    if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
    eval "$(sesh completion bash)"
else
    eval "$(mise activate bash)"
fi
eval "$(starship init bash)"
eval "$(zoxide init bash)"
eval "$(yq shell-completion bash)"
