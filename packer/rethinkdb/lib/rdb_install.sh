#!/bin/bash
# Author: Guilherme Jaccoud <guigo2k@guigo2k.com>

set -e

sys_thp="false"
sys_numa="false"
sys_selinux="false"
sys_lang="en_US.UTF-8"
sys_keepalive="120"
sys_maxsize="65536"
sys_requirements=( 'wget' 'numactl' 'jq' )

# ==============================================================================
# Helper Functions
# ==============================================================================

print_usage() {
  cat <<EOF
Usage: ${script_name} [COMMAND] [OPTIONS]

This script can be used to install RethinkDB.
It has been tested with CentOS 7.

Examples:
  # Install a specific RethinkDB version
  ${script_name} install --version 2.3.6-0

EOF
}

# ==============================================================================
# System Config.
# ==============================================================================

# system locale
sys_config_locale() {
	local sys_lang="${1:-$sys_lang}"
	log_info "Setting locale to '${sys_lang}'"
	echo LANG=\"${sys_lang}\" > /etc/locale.conf
}

# disable SELinux
sys_config_selinux() {
  local sys_selinux="${1:-$sys_selinux}"
  if [[ "$sys_selinux" == 'false' ]]; then
    log_info "Disabeling SELinux"
  	sed -i --follow-symlinks 's/^SELINUX=.*/SELINUX=disabled/g' /etc/sysconfig/selinux
  	setenforce 0
  fi
}

# kernel tuning
sys_config_thp() {
  local sys_thp="${1:-$sys_thp}"
  if [[ "$sys_thp" == 'false' ]]; then
    log_info "Disabeling Transparent Huge Pages (THP)"
  	echo never > /sys/kernel/mm/transparent_hugepage/enabled
  	echo never > /sys/kernel/mm/transparent_hugepage/defrag
  fi
}

# NUMA optimizations
sys_config_numa() {
  local sys_numa="${1:-$sys_numa}"
  if [[ "$sys_numa" == 'true' ]]; then
    log_info "Configuring Non-Uniform Memory Access (NUMA)"
  	yum install -y numactl
  	echo 0 | sudo tee /proc/sys/vm/zone_reclaim_mode
  	sudo sysctl -w vm.zone_reclaim_mode=0
  fi
}

# shorter keepalives
sys_config_keepalive() {
	local sys_keepalive="${1:-$sys_keepalive}"
	log_info "Setting IPv4 TCP keepalive to '${sys_keepalive}'"
	sysctl -w net.ipv4.tcp_keepalive_time=${sys_keepalive}
	cat <<EOF > /etc/sysctl.conf
net.ipv4.tcp_keepalive_time = ${sys_keepalive}
EOF
	sysctl -p
}

# file limits > 20,000
sys_config_maxsize() {
	local sys_maxsize="${1:-$sys_maxsize}"
	log_info "Setting security limits to '${sys_maxsize}'"
	echo "fs.file-max = ${sys_maxsize}" >> /etc/sysctl.conf
	cat <<EOF > /etc/security/limits.conf
* soft     nproc          ${sys_maxsize}
* hard     nproc          ${sys_maxsize}
* soft     nofile         ${sys_maxsize}
* hard     nofile         ${sys_maxsize}
EOF
}

# ==============================================================================
# RethinkDB Install
# ==============================================================================

# install rethinkdb
rethinkdb_install() {
	log_info "Installing RethinkDB ${rdb_version}"
  curl http://download.rethinkdb.com/centos/7/`uname -m`/rethinkdb.repo \
    -o /etc/yum.repos.d/rethinkdb.repo

	yum -y update
	yum -y install ${sys_requirements[@]}
	yum -y install rethinkdb-${rdb_version}
}

# ==============================================================================
# Main Function
# ==============================================================================

main() {

	while [[ $# > 0 ]]; do
	  local key="$1"
	  case "${key}" in
	    --version | -v )
	      rdb_version="$2"
	      shift
	      ;;
	    --help | -h )
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

	assert_not_empty "--version" "${rdb_version}"

  sys_config_locale
  sys_config_selinux
  sys_config_thp
  sys_config_numa
  sys_config_keepalive
  sys_config_maxsize

  rethinkdb_install

	systemctl status rethinkdb || true

	log_info "RethinkDB setup complete!"
}

main "$@"
