
# https://www.terraform.io/docs/providers/google/r/container_cluster.html

resource "google_container_cluster" "k8s_cluster" {
  name               = "${var.name}-k8s"
  network            = "${var.name}-vpc"
  subnetwork         = "${var.name}-${var.region}-app1"
  zone               = "${var.zone}"
  initial_node_count = "${var.k8s_initial_node_count}"

  node_config {
    machine_type = "${var.k8s_machine_type}"
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_write",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    labels {

    }
  }
}

resource "null_resource" "k8s_login" {
  depends_on    = ["google_container_cluster.k8s_cluster"]

  provisioner "local-exec" {
    interpreter = ["sh", "-c"]
    command = <<EOF
    # get cluster credentials
    gcloud container clusters get-credentials ${var.name}-k8s \
    --zone ${var.zone} --project ${var.project}

    # install helm
    helm init
    sleep 60

    # deploy cert-manager
    helm update
    helm install \
    --name certs \
    --namespace kube-system \
    --set rbac.create=false \
    stable/cert-manager

    # deploy nginx-ingress
    helm install --name nginx stable/nginx-ingress
EOF
  }
}
