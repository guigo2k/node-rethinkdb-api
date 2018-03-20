# cloud credentials
project     = "symphony-gce-test1"               # cloud project name
credentials = "~/.gce/symphony-gce-test1.json"   # service accout json file

# project info
name   = "centos-test"                           # the project name
env    = "dev"                                   # project environment
region = "us-west1"                              # project region
zone   = "us-west1-b"                            # default project zone

# cloud dns
managed_zone    = "sym-gce-test"                 # cloud dns managed zone
backend_domain  = "app.sym-gce-test.ml"          # backend app domain

# docker images
backend_app_img = "guigo2k/node-rethinkdb-api"   # backend app docker image
rdb_proxy_img   = "guigo2k/rethinkdb-proxy"      # rethinkdb proxy docker image

# rethinkdb instances
rdb_machine_type = "n1-standard-1"               # rethinkdb instance type
rdb_target_size  = 3                             # rethinkdb cluster size

# kubernetes instances
k8s_machine_type       = "n1-standard-1"         # kubernetes instance type
k8s_initial_node_count = 3                       # kubernetes cluster size
