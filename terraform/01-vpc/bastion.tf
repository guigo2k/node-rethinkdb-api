
# https://www.terraform.io/docs/providers/google/r/compute_instance.html

resource "google_compute_instance" "bastion" {
  name         = "${var.name}-bastion"
  zone         = "${var.bastion_zone}"
  machine_type = "g1-small"

  tags = ["${var.name}-bastion", "${var.region}"]

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
    scopes = ["userinfo-email"]
  }
}
