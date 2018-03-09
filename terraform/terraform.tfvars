
# project
project     = "symphony-gce-test1"
credentials = "~/.gce/symphony-gce-test1.json"

# global
env    = "dev"
name   = "centos-test"
region = "us-west1"

# infra
allow_all    = "187.34.1.154/32"
bastion_zone = "us-west1-b"

# kubernetes
k8s_zone               = "us-west1-b"
k8s_machine_type       = "n1-standard-1"
k8s_initial_node_count = 3

# rethinkdb
rdb_machine_type = "n1-standard-1"
rdb_source_image = "rdb-gce-2018-03-08-033840"
rdb_target_size  = 3
