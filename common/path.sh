# path.sh - Shared PATH management for Zsh and Bash

# Helper for Bash (Zsh uses typeset -U path)
_add_to_path() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        export PATH="$1:$PATH"
    fi
}

if [ -n "$ZSH_VERSION" ]; then
    # Zsh optimized path management
    typeset -U path
    path=(
        /opt/homebrew/bin
        /opt/homebrew/sbin
        $HOME/.config/composer/vendor/bin
        $HOME/github.com/mahlstrom/php-bin/bin
        /opt/homebrew/opt/mysql-client/bin
        /Users/mahlstrom/github.com/mahlstrom/argbash
        /Applications/PhpStorm.app/Contents/MacOS
        /usr/local/bin
        /usr/local/sbin
        $path
    )
else
    # Bash path management
    _add_to_path "/usr/local/sbin"
    _add_to_path "/usr/local/bin"
    _add_to_path "/Applications/PhpStorm.app/Contents/MacOS"
    _add_to_path "/Users/mahlstrom/github.com/mahlstrom/argbash"
    _add_to_path "/opt/homebrew/opt/mysql-client/bin"
    _add_to_path "$HOME/github.com/mahlstrom/php-bin/bin"
    _add_to_path "$HOME/.config/composer/vendor/bin"
    _add_to_path "/opt/homebrew/sbin"
    _add_to_path "/opt/homebrew/bin"
fi
