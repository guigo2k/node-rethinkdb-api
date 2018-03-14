
# https://www.terraform.io/docs/providers/google/r/compute_firewall.html

resource "google_compute_firewall" "allow-ssh" {
  depends_on    = [
    "google_compute_network.game_default_vpc"
  ]

  project       = "${var.project}"
  name          = "ssh-access"
  network       = "${var.name}-vpc"

  allow {
    protocol    = "tcp"
    ports       = ["22"]
  }
}
