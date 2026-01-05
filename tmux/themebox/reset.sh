#!/usr/bin/env bash
# Get all the @xxx options and remove them
TMUX_USER_OPTIONS=$(tmux show-options -g | grep -E "^@.*" | awk '{print $1}' | tr '\n' ' ')
for option in $TMUX_USER_OPTIONS; do
  tmux set-option -gu $option
done