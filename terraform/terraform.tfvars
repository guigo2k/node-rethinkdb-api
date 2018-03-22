# cloud credentials
project     = "YOUR GOOGLE CLOUD PROJECT"
credentials = "YOUR SERVICE ACCOUT (JSON) FILE"

# project info
name   = "sym-gce-test"                          # project name
env    = "dev"                                   # project environment
region = "us-west1"                              # project region
zone   = "us-west1-b"                            # default project zone

# cloud dns
managed_zone    = "sym-gce-test"                 # managed zone name
backend_domain  = "app.sym-gce-test.ml"          # backend app domain

# docker images
backend_app_img = "guigo2k/node-rethinkdb-api"   # backend app image
rdb_proxy_img   = "guigo2k/rethinkdb-proxy"      # rethinkdb proxy image

# rethinkdb instances
rdb_machine_type = "n1-standard-1"               # rethinkdb instance type
rdb_target_size  = 3                             # rethinkdb cluster size

# kubernetes instances
k8s_machine_type       = "n1-standard-1"         # kubernetes instance type
k8s_initial_node_count = 3                       # kubernetes cluster size
