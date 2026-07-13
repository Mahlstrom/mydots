# Define a helper to check and alias
_safe_alias() {
    if command -v "$2" >/dev/null 2>&1; then
        alias "$1"="$2"
    fi
}
