# ==========================
# Alias file compatible with Bash & Zsh
# ==========================

# --------------------------
# Navigation
# --------------------------
alias cd=z
alias dcd='docker-compose down'
alias dcu='docker-compose up -d'
alias dot='cd ~/.config/'
alias sb='cd ~/Documents/doc/'
alias ob="cd '/Users/mahlstrom/Library/Mobile Documents/iCloud~md~obsidian/Documents/Privat'"

# --------------------------
# Git
# --------------------------
alias gaa='git add .'
alias gla='eza --icons --git-ignore --git -lF --git-repos -a'
alias gll='eza --icons --git-ignore --git -lF --git-repos'
alias gss='git status -sb'

# --------------------------
# Kubernetes
# --------------------------
alias k='kubectl'
alias kg='kubectl get'
alias kgp='kubectl get pods'
alias kgs='kubectl get service'

# --------------------------
# eza / ls
# --------------------------
alias l='eza --icons --git -lF'
alias la='eza -a'
alias ll='eza --icons --git -lF --time-style=long-iso'
alias lla='eza --icons --git -lF -a'
alias ls='ls --color=auto -F'
alias lt='eza --tree'

# --------------------------
# PHP / Composer / Laravel
# --------------------------
alias pa='php artisan'
alias c='composer'

# --------------------------
# Neovim
# --------------------------
alias v=nvim
alias vv='NVIM_APPNAME=$NVIM_APPNAME2 nvim'

# --------------------------
# Azure / Remote
# --------------------------
alias remote-login='az webapp create-remote-connection --resource-group rg-login-swe -n app-login-swe -p 49152'

# --------------------------
# sesh
# --------------------------
alias s="sesh connect \"\$(sesh list -i | gum filter --limit 1 --placeholder 'Pick a sesh' --prompt '>')\""
