export BASH_SILENCE_DEPRECATION_WARNING=1
export OLDPWD="${OLDPWD:-$HOME}"
export GITHUB_TOKEN="$(gh auth token 2>/dev/null)"
export PATH="$HOME/.local/bin:$PATH"
export EDITOR="nvim"
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoredups:erasedups
