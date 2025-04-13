#!/usr/bin/env zsh

for file in $HOME/.config/*/.zshrc(N); do
  if [[ -f $file ]]; then
    echo "$file"
  fi
done
