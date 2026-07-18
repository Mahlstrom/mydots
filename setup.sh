#!/usr/bin/env zsh
# Load Zsh's built-in color module
autoload -U colors && colors

# for namn in ${(k)color}; do
for k in ${(k)color[(I)fg-*]};do;fg[${k#fg-}_l]="\e[$(($color[$k]+60))m";done
fg[black_r]="\e[38;5;16m"
for k in ${(k)color[(I)bg-*]};do;bg[${k#bg-}_l]="\e[$(($color[$k]+60))m";done

# Default to dry run unless the first argument is explicitly "apply"
dry_run=1
if [[ "$1" == "apply" ]]; then
  dry_run=0
fi
BGC=(black_l blue blue_l cyan cyan_l)
FGC=(white_l white_l white_l black_r black_r)
PHASE=0

# PHASE=$PHASE+2
PHASE_BG="blue"

echo ""
if [[ $dry_run -eq 1 ]]; then
  echo -e "🔹 ${bold_color}[SIMULATION]${RESET} We are running dry... (Run with 'apply' to execute changes)"
else
  echo "🚀 $bold_color [LIVE MODE]$reset_color  Executing setup changes..."
fi
echo "========================================="

function print_line() {
  local the_text="$1"
  echo "$bg[$BGC[$PHASE]]  $reset_color${(r:$COLUMNS-12:: :)the_text}"
}

function print_phase() {
  PHASE=$PHASE+1
  PHASE_BG=$bg[$BGC[$PHASE]]
  PHASE_FG=$fg[$FGC[$PHASE]]
  local phase_text="$1"
  echo ""
  echo "$PHASE_BG$PHASE_FG${(r:$COLUMNS-10:: :)phase_text}$reset_color"
}

# Central function to execute or simulate commands with error handling
function run() {
  if [[ "$dry_run" -eq 1 ]]; then
    print_line "    🚧 dry-run: Would execute: $*"
  else
    eval "$@"
    local exit_status=$? 
    if [ $exit_status -ne 0 ]; then
      echo ""
      echo "  $bold_color❌ ERROR:$reset_color Command failed with exit code $exit_status: $*" >&2
      echo ""
      exit $exit_status
    fi
  fi
}

typeset -U path cdpath fpath manpath

# Helper function to backup old configuration and clone the new one
function backup_and_clone() {
  local reason="$1"
  local timestamp=$(date +"%Y-%m-%d_%H:%M:%S")
  
  print_line "  $reason"
  run "mv '$CONFIG_DIR' '${CONFIG_DIR}_$timestamp'"
  run "git clone '$REMOTE_URL' '$CONFIG_DIR'"
}

function check_dotconfig() {
  CONFIG_DIR="$HOME/.config"
  REMOTE_URL="https://github.com"
  REMOTE_IDENTIFIER="Mahlstrom/mydots"

  # Case 1: Directory does not exist -> Clone directly and exit
  if [ ! -d "$CONFIG_DIR" ]; then
    print_line "  🔹 Config directory missing, preparing fresh clone..."
    run "git clone '$REMOTE_URL' '$CONFIG_DIR'"
    return 0
  fi

  print_line "  ✅ Config directory already exists."

  # Case 2: Not a git repository -> Backup and clone
  if ! git -C "$CONFIG_DIR" rev-parse >/dev/null 2>&1; then
    backup_and_clone "🔹 Existing directory is not a git repository. Backing up..."
    return 0
  fi

  # Case 3: Old nix repository -> Warn and exit
  if git -C "$CONFIG_DIR" remote get-url origin 2>/dev/null | grep -iq "Mahlstrom/dotfiles.nix"; then
    print_line "  🔹 Old config (dotfiles.nix) detected. Convert when done!"
    return 0
  fi

  # Case 4: Git repository, but wrong remote URL -> Backup and clone
  if ! git -C "$CONFIG_DIR" remote get-url origin 2>/dev/null | grep -iq "$REMOTE_IDENTIFIER"; then
    backup_and_clone "🔹 Repository URL mismatch. Backing up existing repo..."
    return 0
  fi

  # Case 5: Correct repository! Handle local changes or perform a pull
  print_line "  ✨ Repository URL verified successfully."
  if [[ $(git -C "$CONFIG_DIR" status --porcelain) ]]; then
    print_line "  🔹 You have uncommitted changes in your dotfiles directory!"
  else
    print_line "  🔄 Pulling latest changes from remote..."
    run "git -C '$CONFIG_DIR' pull --ff-only"
  fi
}

function checksymlink() {
  local ln_path="$1"
  local target="$2"
  
  print_line "  🔗 Link: ${ln_path} ➔ ${target}"
  
  if [ "$ln_path" -ef "$target" ]; then
    print_line "    ✅ Already correctly linked."
    return 0
  fi

  # If the file/link exists but points to the wrong place, remove it first
  if [ -e "$ln_path" ] || [ -L "$ln_path" ]; then
    print_line "    🔹 Path exists but points elsewhere. Clearing old path..."
    run "rm -f '$ln_path'"
  fi

  run "ln -s '$target' '$ln_path'"
}

function check_install() {
  local thecmd="$1"
  local the_installcmd="$2"
  
  if ! command -v "$thecmd" &>/dev/null; then
    print_line "  📦 $thecmd is missing. Starting installation..."
    run "$the_installcmd"
  else
    print_line "  ✅ $thecmd is already installed."
  fi
}

# --- EXECUTION STARTS HERE ---

print_phase "💎 Phase 1: Checking Git"
check_install "git" "xcode-select --install"

print_phase "💎 Phase 2: 📁 Checking dotfiles configuration ($HOME/.config)"
check_dotconfig

# If the file does not exist during dry-run (e.g., on a brand new Mac), avoid crashing the script on source
if [ -f "$HOME/.config/homebrew/.zshenv" ]; then
  echo "  💎 Sourcing Homebrew environment..."
  source "$HOME/.config/homebrew/.zshenv"
fi

print_phase "💎 Phase 3: Package Management & CLI Apps"
check_install "brew" '/bin/bash -c "$(curl -fsSL https://githubusercontent.com)"'

pushd "$HOME/.config" || exit

check_install "gum" "brew install gum"
check_install "ghostty" "brew install --cask ghostty"

print_phase "💎 Phase 4: Creating Symlinks"
checksymlink "$HOME/.zshrc" "$HOME/.config/zsh/zshrc"
checksymlink "$HOME/.zshenv" "$HOME/.config/zsh/zshenv"
checksymlink "$HOME/.zprofile" "$HOME/.config/zsh/zprofile"
checksymlink "$HOME/.ideavimrc" "$HOME/.config/ideavim/ideavimrc"

# Run the init script if it is actually found (prevents crash if the directory is empty during dry-run)
if : */init.sh(N); then
  print_phase "💎 Phase 4: Running Initialization Scripts"
  for init_script in */init.sh(N); do
    print_line "  🔄 Sourcing initialization script: $init_script"
    run "source '$init_script'"
  done
fi

popd || exit

echo ""
echo "========================================="
echo "$bold_color🎉 Setup script finished successfully!$reset_color"
echo ""
