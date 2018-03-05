
# https://www.terraform.io/docs/providers/google/r/compute_firewall.html

resource "google_compute_firewall" "allow-all" {
  depends_on = ["google_compute_network.game-default-vpc"]
  project    = "${var.project}"
  name       = "allow-all"
  network    = "${var.name}-vpc"

  allow {
    protocol = "all"
  }

  source_ranges = ["${var.allow_all}"]
}
