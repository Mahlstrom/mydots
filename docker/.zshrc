dps() {
  docker ps --format '{{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}' |
  awk -F'\t' '
  BEGIN {
    printf "%-12s %-20s %-25s %-22s %s\n",
           "CONTAINER ID", "NAME", "IMAGE", "STATUS", "PORT"
  }
  {
    ports = ($5 == "" ? "-" : $5)
    n = split(ports, p, ", ")

    for (i = 1; i <= n; i++) {
      printf "%-12s %-20s %-25s %-22s %s\n",
             (i == 1 ? substr($1,1,12) : ""),
             (i == 1 ? $2 : ""),
             (i == 1 ? $3 : ""),
             (i == 1 ? $4 : ""),
             p[i]
    }
  }'
}