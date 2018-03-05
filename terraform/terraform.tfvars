
# project
project     = "symphony-gce-test1"
credentials = "~/.gcloud/symphony-gce-test1.json"

# global
env    = "dev"
name   = "centos-test"
region = "us-west1"

# infra
allow_all    = "189.0.121.10/32"
bastion_zone = "us-west1-b"

# kubernetes
k8s_zone               = "us-west1-b"
k8s_machine_type       = "n1-standard-1"
k8s_initial_node_count = 3

# rethinkdb
rdb_zone         = "us-west1-b"
rdb_machine_type = "n1-standard-1"
rdb_source_image = "centos-cloud/centos-7"
rdb_target_size  = 3
