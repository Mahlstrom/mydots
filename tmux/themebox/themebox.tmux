#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

TMUX_DIR=$HOME/.config/tmux
tmux source-file $TMUX_DIR/themebox/default.conf
tmux source-file $TMUX_DIR/themebox/defaultw.conf

THEMES_DIR=$TMUX_DIR/themes
DEFAULT_THEME='nord'

declare -A themes=(
	[nord]=$THEMES_DIR/nordtheme/tmux/nord.tmux
	[demo2]=$THEMES_DIR/mahlstrom/demo2/tsb.tmux
	[2k]=$THEMES_DIR/2kabhishek/tmux2k/2k.tmux
	[kanagawa]=$THEMES_DIR/Nybkox/tmux-kanagawa/kanagawa.tmux
	[tomorrow_night_bright]=$THEMES_DIR/edouard-lopez/tmux-tomorrow/tomorrow-night-bright.tmux
	[tomorrow_night_eighties_blue]=$THEMES_DIR/edouard-lopez/tmux-tomorrow/tomorrow-night-eighties-blue.tmux
	[tomorrow_night_eighties]=$THEMES_DIR/edouard-lopez/tmux-tomorrow/tomorrow-night-eighties.tmux
	[tomorrow_night]=$THEMES_DIR/edouard-lopez/tmux-tomorrow/tomorrow-night.tmux
	[tomorrow]=$THEMES_DIR/edouard-lopez/tmux-tomorrow/tomorrow.tmux
	[gruvbox_tpm]=$THEMES_DIR/egel/tmux-gruvbox/gruvbox-tpm.tmux
	[dark_notify]=$THEMES_DIR/erikw/tmux-dark-notify/main.tmux
	[1mytokyo]=$THEMES_DIR/mahlstrom/mytokyo/mytokyo-night.tmux
	[tokyo_night]=$THEMES_DIR/fabioluciano/tmux-tokyo-night/tmux-tokyo-night.tmux
	[tokyo_night_tmux]=$THEMES_DIR/janoamaral/tokyo-night-tmux/tokyo-night.tmux
	[statusline]=$THEMES_DIR/jatap/tmux-base16-statusline/statusline.tmux
	[themepack]=$THEMES_DIR/jimeh/tmux-themepack/themepack.tmux
	[minimal]=$THEMES_DIR/niksingh710/minimal-tmux-status/minimal.tmux
	[nova]=$THEMES_DIR/o0th/tmux-nova/nova.tmux
	[rose_pine]=$THEMES_DIR/rose-pine/tmux/rose-pine.tmux
	[tmuxcolors]=$THEMES_DIR/seebi/tmux-colors-solarized/tmuxcolors.tmux
	[tmux_power]=$THEMES_DIR/wfxr/tmux-power/tmux-power.tmux
)

theme=${1:-''}
tmux set-option -g @themepack 'powerline/double/magenta'
tmux set-option -g @tmux2k-theme 'catppuccin'
if [[ "$theme" == "--list" ]]; then
  for key in "${!themes[@]}"; do
    echo "$key"
  done
  exit 0
fi

if [[ -z "$theme" ]]; then
	source $($THEMES_DIR/nordtheme/tmux/nord.tmux)
	echo "No theme specified, using default theme"
	exit 0
else
	echo "Theme specified: $theme"
fi

if [[ -v themes["$theme"] ]]; then
	echo "Theme $theme found, running it"
	theme_file=${themes["$theme"]}
	echo "Theme file: $theme_file"
	if head -n 1 "$theme_file" | grep -q '^#!'; then
		echo "Running $theme_file"
		source "$theme_file"

		echo "Done running $theme_file"
	else
		echo "Sourcing $theme_file"
		tmux source-file "$theme_file"
		echo "Done sourcing $theme_file"
	fi
else
	echo "Theme $theme not found, using default theme"
	source "$THEMES_DIR/nordtheme/tmux/nord.tmux"
fi
