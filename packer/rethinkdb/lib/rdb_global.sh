
log() {
	local readonly level="$1"
	local readonly message="$2"
	local readonly timestamp=$(date +"%Y-%m-%d %H:%M:%S")
	>&2 echo -e "${timestamp} [${level}] [${script_name}] ${message}"
}

log_info() {
	local readonly message="$1"
	log "INFO" "${message}"
}

log_warn() {
	local readonly message="$1"
	log "WARN" "${message}"
}

log_error() {
	local readonly message="$1"
	log "ERROR" "${message}"
}

assert_not_empty() {
	local readonly arg_name="$1"
	local readonly arg_value="$2"
	if [[ -z "${arg_value}" ]]; then
		log_error "The value for '${arg_name}' cannot be empty"
		print_usage
		exit 1
	fi
}
