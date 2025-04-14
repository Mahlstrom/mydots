#!/usr/bin/env zsh

if [ "$#" -gt 0 ]; then
  dry_run=1
fi
typeset -U path cdpath fpath manpath

function check_dotconfig() {
  CONFIG_DIR="$HOME/.config"
  REMOTE_URL="https://github.com/Mahlstrom/mydots"
  REMOTE_IDENTIFIER="Mahlstrom/mydots"
  echo "Checking for $HOME/.config"

  # Check if the directory exists
  if [ -d "$CONFIG_DIR" ]; then
    echo "Config directory already exists."
    # Check if it's a git repository
    if git -C "$CONFIG_DIR" rev-parse >/dev/null 2>&1; then
      # Check if Mahlstrom/dotfiles.nix
      if git -C "$CONFIG_DIR" remote get-url origin | grep -q "Mahlstrom/dotfiles.nix"; then
        echo "Old config. Convert when done!"
        return 0;
      fi
      # Check if the remote fetch origin contains the required identifier
      if git -C "$CONFIG_DIR" remote get-url origin | grep -q "$REMOTE_IDENTIFIER"; then
        echo "$CONFIG_DIR is already a valid git repository."
        pushd "$CONFIG_DIR" || exit
        if [[ $(git status --porcelain) ]]; then
          echo "You have changes in your dotfiles directory"
        else
          if [ "$dry_run" -eq 1 ]; then
            echo "Dry run: Would pull latest changes in $CONFIG_DIR."
          else
            git pull --ff-only
          fi
        fi
        popd || exit
      else
        # Rename the directory with current date and time
        TIMESTAMP=$(date +"%Y-%m-%d_%H:%M:%S")
        if [ "$dry_run" -eq 1 ]; then
          echo "Dry run: Would rename existing directory to ${CONFIG_DIR}_$TIMESTAMP."
        else
          mv "$CONFIG_DIR" "${CONFIG_DIR}_$TIMESTAMP"
          echo "Renamed existing directory to ${CONFIG_DIR}_$TIMESTAMP."
        fi
      fi
    else
      # Rename the directory if it's not a git repository
      TIMESTAMP=$(date +"%Y-%m-%d_%H:%M:%S")
      if [ "$dry_run" -eq 1 ]; then
        echo "Dry run: Would rename non-git directory to ${CONFIG_DIR}_$TIMESTAMP."
      else
        mv "$CONFIG_DIR" "${CONFIG_DIR}_$TIMESTAMP"
        echo "Renamed non-git directory to ${CONFIG_DIR}_$TIMESTAMP."
      fi
    fi
  fi

  if [ ! -d "$CONFIG_DIR" ]; then
    # Clone the repository
    if [ "$dry_run" -eq 1 ]; then
      echo "Dry run: Would clone repository from $REMOTE_URL into $CONFIG_DIR."
    else
      git clone "$REMOTE_URL" "$CONFIG_DIR"
      echo "Cloned repository into $CONFIG_DIR."
    fi
  fi
}

function checksymlink() {
  local ln_path="$1"
  local target="$2"
  echo $SHELL
  echo "checking if $ln_path is a symlink to $target"
  if [ "$ln_path" -ef "$target" ]; then
    echo "$ln_path is correctly symlinked"
  else
    if [ "$dry_run" -eq 1 ]; then
      echo "Dry run: Would create symlink from $ln_path to $target."
    else
      ln -s "$target" "$ln_path"
    fi
  fi
}

function check_install() {
  thecmd="$1"
  the_installcmd="$2"
  if ! command -v $thecmd 2>&1 >/dev/null; then
    echo "installing $thecmd"
    if [ "$dry_run" -eq 1 ]; then
      echo "Dry run: Would execute \"$the_installcmd\"."
    else
      eval "$the_installcmd"
    fi
  fi
}

check_install "git" "xcode-select --install"

check_dotconfig
source "$HOME/.config/homebrew/.zshenv"
check_install "brew" '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"'
pushd "$HOME/.config" || exit
check_install "gum" "brew install gum"
check_install "ghostty" "brew install --cask ghostty"
checksymlink "$HOME/.zshrc" "$HOME/.config/zsh/zshrc"
checksymlink "$HOME/.zshenv" "$HOME/.config/zsh/zshenv"
checksymlink "$HOME/.zprofile" "$HOME/.config/zsh/zprofile"

# checksymlink "$HOME/.config/nvim_files" "$HOME/github.com"
# git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

popd || exit
