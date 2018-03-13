#!/bin/bash
# Author: Guilherme Jaccoud <guigo2k@guigo2k.com>

set -e

readonly metadata_url="http://metadata.google.internal/computeMetadata/v1"
readonly metadata_header="Metadata-Flavor: Google"

instance_default_network_interface="0"
metadata_status_key_sufix="status-rdb"
metadata_status_value="active"

# ==============================================================================
# Helper Functions
# ==============================================================================

print_usage() {
  cat <<EOF
Usage: ${script_name} start [OPTIONS]

This script can be used to start RethinkDB on GCE.
It has been tested with CentOS 7.

Examples:
  # Start RethinkDB
  ${script_name} start

EOF
}

# get the value at a specific metadata path
get_metadata_value() {
  local readonly path="$1"
  curl -s -S -L -H "${metadata_header}" "${metadata_url}/${path}"
}

# get instance related metadata
get_instance_metadata() {
  local readonly path="$1"
  get_metadata_value "instance/${path}"
}

# get project metadata at a given key
get_project_metadata() {
  local readonly key="$1"
  get_metadata_value "project/${key}"
}

# get the ip address of the current instance
get_instance_ip_address() {
  local network_interface="${1:-$instance_default_network_interface}"
  get_metadata_value "instance/network-interfaces/${network_interface}/ip"
}

# get all cluster instances
get_cluster_members() {
  local readonly name=$(echo $HOSTNAME | rev | cut -d'-' -f2- | rev)
  get_project_metadata "attributes" | grep "$name"
}

# wait cluster metadata
wait_metadata_status() {
  log_info "Waiting cluster metadata info..."
  local readonly key="$(echo $HOSTNAME | rev | cut -d'-' -f3- | rev)-${metadata_status_key_sufix}"
  local readonly cmd="get_project_metadata attributes/${key} | grep '${metadata_status_value}'"
  until eval "$cmd"; do
    sleep 3
  done
}

# ==============================================================================
# RethinkDB Functions
# ==============================================================================

rethinkdb_config() {
  log_info "Creating RethinkDB config"
  local readonly instances=($(get_cluster_members))
  local readonly private_ip=$(get_instance_ip_address)
  local readonly name=$(get_metadata_value "instance/name")
  (
    echo "bind=all"
    echo "canonical-address=${private_ip}"
    for i in ${instances[@]}; do
      local host=$(get_project_metadata "attributes/${i}")
      if [[ "$host" != "$name" ]]; then
        echo "join=${host}"
      fi
    done
  ) >/etc/rethinkdb/instances.d/${name}.conf
}

# ==============================================================================
# Main Function
# ==============================================================================

main() {
  while [[ $# > 0 ]]; do
    local key="$1"
    case "${key}" in
    --help | -h)
      print_usage
      exit
      ;;
    *)
      log_error "Unrecognized argument: ${key}"
      print_usage
      exit 1
      ;;
    esac
    shift
  done

  log_info "Starting RethinkDB setup..."
  wait_metadata_status
  rethinkdb_config
  service rethinkdb start || true
  log_info "RethinkDB setup complete."
}

main "$@"
