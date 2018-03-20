
# https://www.terraform.io/docs/provisioners/null_resource.html

resource "null_resource" "tf_environment" {
  depends_on    = [
    "google_compute_network.game_default_vpc",
    "google_compute_subnetwork.game_infra1",
    "google_compute_subnetwork.game_data1",
    "google_compute_subnetwork.game_app1"
  ]

  provisioner "local-exec" {
    interpreter = ["sh", "-c"]
    command = <<EOF
    (
    echo "# cloud credentials"
    echo "export project=${var.project}"
    echo "export credentials=${var.credentials}"
    echo
    echo "# project info"
    echo "export name=${var.name}"
    echo "export env=${var.env}"
    echo "export region=${var.region}"
    echo "export zone=${var.zone}"
    echo
    echo "# cloud dns"
    echo "export managed_zone=${var.managed_zone}"
    echo "export backend_domain=${var.backend_domain}"
    echo
    echo "# docker images"
    echo "export backend_app_img=${var.backend_app_img}"
    echo "export rdb_proxy_img=${var.rdb_proxy_img}"
    echo
    echo "# rethinkdb instances"
    echo "export rdb_machine_type=${var.rdb_machine_type}"
    echo "export rdb_target_size=${var.rdb_target_size}"
    echo
    echo "# kubernetes instances"
    echo "export k8s_machine_type=${var.k8s_machine_type}"
    echo "export k8s_initial_node_count=${var.k8s_initial_node_count}"
    )> ../.env
EOF
  }
}
