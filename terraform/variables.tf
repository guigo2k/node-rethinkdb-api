# cloud credentials
variable "project" {}
variable "credentials" {}

# project info
variable "env" {}
variable "name" {}
variable "region" {}
variable "zone" {}

# cloud dns
variable "managed_zone" {}
variable "backend_domain" {}

# docker images
variable "backend_app_img" {}
variable "rdb_proxy_img" {}

# rethinkdb instances
variable "k8s_machine_type" {}
variable "k8s_initial_node_count" {}

# rethinkdb instances
variable "rdb_machine_type" {}
variable "rdb_target_size" {}
