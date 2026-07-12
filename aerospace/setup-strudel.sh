#!/bin/bash

# 1. Grab the ID of the workspace you are currently coding on
CURRENT_WORKSPACE=$(aerospace list-workspaces --focused)

# 2. Stage the split on the right side of Ghostty
aerospace join-with right

# 3. Pull the newly spawned Strudel window into your active workspace
aerospace move-node-to-workspace "$CURRENT_WORKSPACE"

# 4. Pause briefly to allow macOS to finish stitching the windows together
sleep 0.15

# 5. Find the unique AeroSpace window ID for the Strudel tile
STRUDEL_ID=$(aerospace list-windows --workspace "$CURRENT_WORKSPACE" | grep "Strudel REPL" | awk '{print $1}')

# 6. If found, lock focus, apply sizing offset, and return to Neovim
if [ -n "$STRUDEL_ID" ]; then
  aerospace focus --window-id "$STRUDEL_ID"
  # Adjust this pixel offset depending on your monitor width
  aerospace resize width -250
  aerospace focus left
fi
