# sesh-sessions function
function sesh-sessions() {
  local session
  session=$(sesh list -t -c | fzf --height 40% --reverse --border --border-label ' sesh ' --prompt '⚡  ')
  [[ -z "$session" ]] && return
  sesh connect $session
}

zle -N sesh-sessions
bindkey -M emacs '\es' sesh-sessions
bindkey -M vicmd '\es' sesh-sessions
bindkey -M viins '\es' sesh-sessions
