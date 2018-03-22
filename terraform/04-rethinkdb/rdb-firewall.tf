
# https://www.terraform.io/docs/providers/google/r/compute_firewall.html

resource "google_compute_firewall" "rdb_firewall" {
  name          = "${var.name}-vpc-fw-rdb"
  network       = "${var.name}-vpc"

  allow {
    protocol    = "tcp"
    ports       = ["28015", "29015", "8080"]
  }

  target_tags   = ["${var.name}-rdb-cluster"]
  source_ranges = ["10.0.0.0/22", "10.0.4.0/22", "10.0.8.0/22"]
}
