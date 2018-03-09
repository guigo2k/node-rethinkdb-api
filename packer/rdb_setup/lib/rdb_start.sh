#!/bin/bash
# Author: Guilherme Jaccoud <guigo2k@guigo2k.com>

set -e

readonly metadata_url="http://metadata.google.internal/computeMetadata/v1"
readonly metadata_header="Metadata-Flavor: Google"

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

# display all cluster members (sort ascending)
get_cluster_instances() {
  local name=$(echo ${HOSTNAME} | rev | cut -d'-' -f2- | rev)
  local cmd="gcloud compute instances list --filter='name:${name}*' --sort-by='creationTimestamp' --format='[no-heading]'"

  if [[ "$1" == '--short' ]]; then
    eval "${cmd}" | awk '{print $1}'
  else
    eval "${cmd}"
  fi
}

# wait all instances to be up and running
wait_cluster_instances() {
  local cmd="get_cluster_instances | grep 'RUNNING' | wc -l"
  local instances=($(get_cluster_instances --short))

  log_info "Waiting all instances to be running..."
  while [[ ! $(eval "${cmd}") == ${#instances[@]} ]]; do
    sleep 3
  done
}

# get the value at a specific instance metadata path
get_metadata_value() {
  local readonly path="$1"
  curl --silent --show-error --location --header "${metadata_header}" "${metadata_url}/${path}"
}

# get the value of the given metadata Key
get_custom_metadata() {
  local readonly key="$1"
  get_metadata_value "instance/attributes/${key}"
}

# get the IP address of the current instance
get_instance_ip_address() {
  local network_interface="$1"
  if [[ -z "$network_interface" ]]; then
    network_interface=0
  fi
  get_metadata_value "instance/network-interfaces/${network_interface}/ip"
}

# ==============================================================================
# RethinkDB Functions
# ==============================================================================

rethinkdb_config() {
  local private_ip=$(get_instance_ip_address)
  local hostname=$(get_metadata_value "instance/name")
  local instances=($(get_cluster_instances --short))
  local conf_path="/etc/rethinkdb/instances.d"

  log_info "Creating RethinkDB config file"
  (
    echo "bind=all"
    echo "canonical-address=${private_ip}"
    for i in ${instances[@]}; do
      if [[ "$i" != "$hostname" ]]; then
        echo "join=${i}"
      fi
    done
  ) >${conf_path}/${hostname}.conf
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

  rethinkdb_config
  service rethinkdb start || true
  log_info "RethinkDB startup complete!"
}

main "$@"
