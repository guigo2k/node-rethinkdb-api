
# project
project     = "symphony-gce-test1"
credentials = "~/.gce/symphony-gce-test1.json"

# global
env    = "dev"
name   = "centos-test"
region = "us-west1"

# vpc_network
jumpfox_zone = "us-west1-b"

# rethinkdb
rdb_machine_type = "n1-standard-1"
rdb_source_image = "rdb-gce-2018-03-11-115629"
rdb_target_size  = 3

# kubernetes
k8s_zone               = "us-west1-b"
k8s_machine_type       = "n1-standard-1"
k8s_initial_node_count = 3
