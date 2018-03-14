
# https://www.terraform.io/docs/provisioners/null_resource.html

resource "null_resource" "tf_env" {
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
    echo "#project"
    echo "export project=${var.project}"
    echo "export credentials=${var.credentials}"
    echo
    echo "#global"
    echo "export env=${var.env}"
    echo "export name=${var.name}"
    echo "export region=${var.region}"
    echo "export zone=${var.zone}"
    )> ../.env
EOF
  }
}
