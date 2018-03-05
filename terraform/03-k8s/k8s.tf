
# https://www.terraform.io/docs/providers/google/r/container_cluster.html

resource "google_container_cluster" "k8s_cluster" {
  name               = "${var.name}-k8s"
  network            = "${var.name}-vpc"
  subnetwork         = "${var.name}-${var.region}-app1"
  zone               = "${var.k8s_zone}"
  initial_node_count = "${var.k8s_initial_node_count}"

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_write",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    labels {}

  machine_type = "${var.k8s_machine_type}"

  }
}