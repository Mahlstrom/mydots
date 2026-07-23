typeset -ag precmd_functions
if [[ -z "${precmd_functions[(r)_update_brew_outdated_bg]}" ]]; then
    precmd_functions+=(_update_brew_outdated_bg)
fi
