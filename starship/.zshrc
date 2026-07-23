export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
fi

function set_starship_theme() {
  local new_Palette=$1
  local theme_file="$HOME/.config/starship/themes/$new_Palette.toml"
  
  echo "Trying $theme_file"
  if [[ -f "$theme_file" ]]; then
    # Combine the main layout and the standalone theme file into a temporary file
    # cat "$HOME/.config/starship/starship_new.toml" "$theme_file" > "$HOME/.cache/starship_active.toml"
 yq eval-all -p toml -o toml 'select(fi == 0).palette = "'$new_Palette'" | . as $item ireduce ({}; . * $item)' "$HOME/.config/starship/starship_new.toml" ~/.config/starship/themes/$new_Palette.toml > ~/.cache/starship_active.toml

    # Point Starship to use the generated configuration
    export STARSHIP_CONFIG="$HOME/.cache/starship_active.toml"
  else
    echo "Theme not found!"
  fi
}
