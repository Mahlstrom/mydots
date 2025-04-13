#!/usr/bin/env zsh

# Define arrays for formulae and casks
formulae=(
  bat
  curl
  php
  composer
  coreutils
  direnv
  eza
  fd
  fzf
  gh
  git
  gum
  jq
  less
  ripgrep
  starship
  tig
  tmux
  watch
  wget
  zoxide
  zsh
  zsh-autosuggestions
)

casks=(
  1password
  1password-cli
  aerospace
  font-jetbrains-mono
  font-meslo-lg-nerd-font
  google-chrome
)

# Install formulae if not already installed
for formula in $formulae; do
  if ! brew list --formula | grep -q "^$formula\$"; then
    echo "Installing formula: $formula"
    # brew install "$formula"
  else
    echo "Formula already installed: $formula"
  fi
done

# Install casks if not already installed
for cask in $casks; do
  if ! brew list --cask | grep -q "^$cask\$"; then
    echo "Installing cask: $cask"
    # brew install --cask "$cask"
  else
    echo "Cask already installed: $cask"
  fi
done

