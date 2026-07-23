# Plugins
source "$HOME/.config/zsh/zsh-autosuggestions.zsh"
ZSH_AUTOSUGGEST_STRATEGY=(history)

# Syntax highlighting (must be sourced last among plugins)
# Installed via: brew install zsh-syntax-highlighting
if [[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

bindkey -e
