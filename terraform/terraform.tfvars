
# project
project     = "sym-dev-ic"
credentials = "~/.gce/sym-dev-ic.json"

# global
env    = "dev"
name   = "centos-test"
region = "us-west1"

# # infra
bastion_zone = "us-west1-b"

# kubernetes
k8s_zone               = "us-west1-b"
k8s_machine_type       = "n1-standard-1"
k8s_initial_node_count = 3

# rethinkdb
rdb_zone         = "us-west1-b"
rdb_machine_type = "n1-standard-1"
rdb_source_image = "rdb-gce-2018-03-07-024542"
rdb_target_size  = 3
