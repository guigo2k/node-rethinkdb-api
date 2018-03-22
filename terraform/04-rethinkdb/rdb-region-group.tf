
# https://www.terraform.io/docs/providers/google/r/compute_target_pool.html
resource "google_compute_target_pool" "rdb_pool" {
  name = "${var.name}-rdb-pool"
}

# https://www.terraform.io/docs/providers/google/r/compute_instance_group_manager.html
resource "google_compute_region_instance_group_manager" "rdb_cluster" {
  name               = "${var.name}-rdb"
  base_instance_name = "${var.name}-rdb"

  region             = "${var.region}"
  target_size        = "${var.rdb_target_size}"
  target_pools       = ["${google_compute_target_pool.rdb_pool.self_link}"]
  instance_template  = "${google_compute_instance_template.rdb_template.self_link}"

  named_port {
    name = "cluster"
    port = 29015
  }

  named_port {
    name = "client"
    port = 28015
  }

  named_port {
    name = "admin"
    port = 8080
  }

}

# https://www.terraform.io/docs/provisioners/null_resource.html
resource "null_resource" "wait_rdb_instances" {
  depends_on    = [
    "google_compute_region_instance_group_manager.rdb_cluster",
    "google_compute_target_pool.rdb_pool"
  ]

  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command = <<EOF
    echo "Waiting instances to be running..."
    instances="gcloud compute instances list --filter='name:${var.name}-rdb*' --format='[no-heading]'"
    cmd="$instances | grep 'RUNNING' | wc -l | tr -d '[:space:]'"
    while [[ $(eval "$cmd") != "${var.rdb_target_size}" ]]; do
      sleep 3
    done
EOF
  }
}
