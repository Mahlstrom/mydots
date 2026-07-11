_update_brew_outdated_bg() {
    local cache_file="$HOME/.brew_outdated_count"
    local current_time=$(date +%s)
    local last_update=0

    if pgrep -f 'executable/brew|\bwbrew\b|/brew\.rb' >/dev/null 2>&1; then
        return 0
    fi

    if [ -f "$cache_file" ]; then
        if [[ "$OSTYPE" == "darwin"* ]]; then
            last_update=$(stat -f "%m" "$cache_file")
        else
            last_update=$(stat -c "%Y" "$cache_file")
        fi
    fi

    if (( current_time - last_update > 3600 )); then
        touch "$cache_file" 
        
        (brew update >/dev/null 2>&1 && brew outdated | wc -l | tr -d ' ' > "$cache_file" 2>/dev/null &)
    fi
}

typeset -ag precmd_functions
if [[ -z "${precmd_functions[(r)_update_brew_outdated_bg]}" ]]; then
    precmd_functions+=(_update_brew_outdated_bg)
fi
