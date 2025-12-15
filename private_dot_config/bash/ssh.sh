export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
ssh-add "$HOME/.ssh/yubikey" &> /dev/null
