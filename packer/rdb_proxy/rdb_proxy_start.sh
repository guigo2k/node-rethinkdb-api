#!/bin/bash
# Author: Guilherme Jaccoud <guigo2k@guigo2k.com>

rdb_hosts="${rdb_hosts:-"[ERROR] Missing 'rdb_hosts' environment variable"}"
rdb_proxy_cmd() {
  echo -n "rethinkdb proxy --bind all "
  for host in $(echo $rdb_hosts); do
    echo -n "--join $host "
  done
}

exec=$(rdb_proxy_cmd)
exec $exec
