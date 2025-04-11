function checksymlink() {
  local path="$1"
  local target="$2"
  if [ "$(readlink -- "$path")" = "$target" ]; then
    echo "$path is correctly symlinked"
  else
    echo "$path is not correct. Now: \"$(readlink -- "$path")\" Wanted: \"$target\""
  fi
}
function check_install() {
  thecmd="$1"
  the_installcmd="$2"
  if ! command -v $thecmd 2>&1 >/dev/null; then
    echo "installing $thecmd"
    echo "$the_installcmd"
  fi
}
check_install "git" "xcode-select --install"
check_install "brew" '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"'

checksymlink "$HOME/.config/nvim_files" "../github.com"
# git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
