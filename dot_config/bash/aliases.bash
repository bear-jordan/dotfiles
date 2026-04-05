alias ls="ls --color=auto"
alias ll="ls -alh"
alias c="clear"
alias k="kubectl"
alias sb="source ~/.bashrc"
alias cm="chezmoi"
alias cm-sync="chezmoi update"
ff() {
    if [[ "$1" == "--help" ]]; then
        echo "ff — find files"
        echo "  enter    open in nvim"
        echo "  ctrl-s   open in horizontal split (new tmux pane)"
        echo "  ctrl-v   open in vertical split (new tmux pane)"
        echo "  ctrl-y   copy path (tv native)"
        return
    fi
    local out key file
    out=$(tv files --expect='ctrl-s' --expect='ctrl-v')
    key=$(head -1 <<< "$out")
    file=$(tail -1 <<< "$out")
    [[ -z "$file" ]] && return
    case "$key" in
        ctrl-s) tmux split-window -v -c "$(pwd)" "nvim '$file'" ;;
        ctrl-v) tmux split-window -h -c "$(pwd)" "nvim '$file'" ;;
        *)      nvim "$file" ;;
    esac
}

fa() {
    if [[ "$1" == "--help" ]]; then
        echo "fa — find all files (including hidden)"
        echo "  enter    open in nvim"
        echo "  ctrl-s   open in horizontal split (new tmux pane)"
        echo "  ctrl-v   open in vertical split (new tmux pane)"
        echo "  ctrl-y   copy path (tv native)"
        return
    fi
    local out key file
    out=$(tv files-hidden --expect='ctrl-s' --expect='ctrl-v')
    key=$(head -1 <<< "$out")
    file=$(tail -1 <<< "$out")
    [[ -z "$file" ]] && return
    case "$key" in
        ctrl-s) tmux split-window -v -c "$(pwd)" "nvim '$file'" ;;
        ctrl-v) tmux split-window -h -c "$(pwd)" "nvim '$file'" ;;
        *)      nvim "$file" ;;
    esac
}

fo() {
    if [[ "$1" == "--help" ]]; then
        echo "fo — podman images"
        echo "  enter    run with bash (interactive)"
        echo "  ctrl-s   run with sh (interactive)"
        echo "  ctrl-r   run detached"
        echo "  ctrl-p   pull image"
        echo "  ctrl-d   delete image (rmi)"
        echo "  ctrl-y   copy image name (tv native)"
        return
    fi
    local out key image
    out=$(tv podman-images --expect='ctrl-s' --expect='ctrl-r' --expect='ctrl-p' --expect='ctrl-d')
    key=$(head -1 <<< "$out")
    image=$(tail -1 <<< "$out")
    [[ -z "$image" ]] && return
    case "$key" in
        ctrl-s) podman run -it --rm "$image" sh ;;
        ctrl-r) podman run -d "$image" ;;
        ctrl-p) podman pull "$image" ;;
        ctrl-d) podman rmi "$image" ;;
        *)      podman run -it --rm "$image" bash ;;
    esac
}

fc() {
    if [[ "$1" == "--help" ]]; then
        echo "fc — podman containers (running)"
        echo "  enter    exec into container (bash)"
        echo "  ctrl-s   exec into container (sh)"
        echo "  ctrl-l   follow logs"
        echo "  ctrl-t   stop container"
        echo "  ctrl-r   restart container"
        echo "  ctrl-d   remove container (rm -f)"
        echo "  ctrl-y   copy container name (tv native)"
        return
    fi
    local out key line name
    out=$(tv podman-containers --expect='ctrl-s' --expect='ctrl-l' --expect='ctrl-t' --expect='ctrl-r' --expect='ctrl-d')
    key=$(head -1 <<< "$out")
    line=$(tail -1 <<< "$out")
    name=$(echo "$line" | cut -d' ' -f1)
    [[ -z "$name" ]] && return
    case "$key" in
        ctrl-s) podman exec -it "$name" sh ;;
        ctrl-l) podman logs -f "$name" ;;
        ctrl-t) podman stop "$name" ;;
        ctrl-r) podman restart "$name" ;;
        ctrl-d) podman rm -f "$name" ;;
        *)      podman exec -it "$name" bash ;;
    esac
}

fe() {
    tv env
}

function cd_up() {
    cd "$(printf "%0.s../" $(seq 1 "$1"))"
}
alias 'cd..'='cd_up'
