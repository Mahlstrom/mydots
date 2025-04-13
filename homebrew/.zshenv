# Possible paths for brew
BREW_PATHS=(
    "/opt/homebrew/bin/brew"
    "/usr/local/bin/brew"
    "$HOME/homebrew/bin/brew"
)

# Find the first valid brew path
for thepath in "${BREW_PATHS[@]}"; do
    if [[ -x "$thepath" ]]; then
        eval "$("$thepath" shellenv)"
        break
    fi
done
