source /etc/profile.d/bash_completion.sh
eval "$(mise activate bash)"
eval "$(fzf --bash)"
source <(op completion bash)
