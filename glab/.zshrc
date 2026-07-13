#glab fix
function glab_auto() {
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1 && git remote get-url origin >/dev/null 2>&1; then
    repo_url=$(git remote get-url origin)
    if [[ "$repo_url" == *ufly.se* ]]; then
      api_url=${repo_url/git@git.lab.ufly.se:/https:\/\/git.lab.ufly.se\/}
      api_url=${api_url/gitssh.lab.ufly.se/git.lab.ufly.se}
      command glab "$@" --repo "$api_url"
      return
    fi
  fi
  command glab "$@"
}

alias glab=glab_auto


