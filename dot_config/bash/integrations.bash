set -o vi

eval "$(mise activate bash)"
eval "$(starship init bash)"
eval "$(zoxide init bash)"
eval "$(fzf --bash)"
eval "$(sesh completion bash)"
eval "$(yq shell-completion bash)"
