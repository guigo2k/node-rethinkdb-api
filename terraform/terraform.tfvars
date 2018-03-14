
# project
project     = "symphony-gce-test1"
credentials = "~/.gce/symphony-gce-test1.json"

# global
name   = "centos-test"
env    = "prod"

region = "us-west1"
zone   = "us-west1-b"

# rethinkdb instances
rdb_machine_type = "n1-standard-1"
rdb_target_size  = 3

# kubernetes instances
k8s_machine_type       = "n1-standard-1"
k8s_initial_node_count = 3
