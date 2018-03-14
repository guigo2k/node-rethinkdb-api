
# project
variable "project" {}
variable "credentials" {}

# global
variable "env" {}
variable "name" {}
variable "region" {}
variable "zone" {}

# kubernetes
variable "k8s_machine_type" {}
variable "k8s_initial_node_count" {}

# rethinkdb
variable "rdb_machine_type" {}
variable "rdb_target_size" {}
