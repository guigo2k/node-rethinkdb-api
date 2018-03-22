
# https://www.terraform.io/docs/providers/google/r/compute_instance.html

resource "google_compute_instance" "bastion" {
  depends_on    = [
    "google_compute_subnetwork.game_infra1"
  ]

  name         = "${var.name}-vpc-jumpfox"
  zone         = "${var.zone}"
  machine_type = "g1-small"

  tags = ["${var.name}-vpc-jumpfox", "${var.region}"]

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
    }
  }

  network_interface {
    subnetwork = "${var.name}-${var.region}-infra1"

    access_config {
      // Ephemeral IP
    }
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro"]
  }
}
