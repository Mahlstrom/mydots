# sesh-sessions function
sesh-sessions() {
    local session
    session=$(sesh list -t -c | fzf --height 40% --reverse --border --border-label ' sesh ' --prompt '⚡  ')
    [[ -z "$session" ]] && return
    sesh connect "$session"
}

# Keybinding for sesh-sessions (Alt-s)
bind -x '"\es": sesh-sessions'
