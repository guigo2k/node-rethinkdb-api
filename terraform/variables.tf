
# project
variable "project" {}
variable "credentials" {}

# # vpc
variable "jumpfox_zone" {}

# global
variable "env" {}
variable "name" {}
variable "region" {}

# kubernetes
variable "k8s_zone" {}
variable "k8s_machine_type" {}
variable "k8s_initial_node_count" {}

# rethinkdb
variable "rdb_machine_type" {}
variable "rdb_source_image" {}
variable "rdb_target_size" {}
