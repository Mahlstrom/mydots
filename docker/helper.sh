dps() {
  {
    printf "NAME\tIMAGE\tMODE\n"
    docker ps --format $'{{if .Label "com.docker.swarm.service.name"}}{{.Label "com.docker.swarm.service.name"}}{{else}}{{.Names}}{{end}}\t{{.Image}}\t{{if .Label "com.docker.swarm.service.name"}}\e[32mSWARM\e[0m{{else}}\e[36mLOCAL\e[0m{{end}}'
  } | column -t -s $'\t'
}
