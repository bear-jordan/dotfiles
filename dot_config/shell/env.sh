export OLDPWD="${OLDPWD:-$HOME}"
export GITHUB_TOKEN="$(gh auth token 2>/dev/null)"
export PATH="$HOME/.local/work-scripts:$HOME/.local/bin:${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export EDITOR="nvim"
export HISTSIZE=10000

if [ -n "$BASH_VERSION" ]; then
    export BASH_SILENCE_DEPRECATION_WARNING=1
    export HISTFILESIZE=20000
    export HISTCONTROL=ignoredups:erasedups
elif [ -n "$ZSH_VERSION" ]; then
    export SAVEHIST=20000
    setopt hist_ignore_dups hist_expire_dups_first
fi
