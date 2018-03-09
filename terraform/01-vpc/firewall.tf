
# https://www.terraform.io/docs/providers/google/r/compute_firewall.html

# resource "google_compute_firewall" "allow-all" {
#   depends_on    = ["google_compute_network.game-default-vpc"]
#
#   name          = "allow-all"
#   project       = "${var.project}"
#   network       = "${var.name}-vpc"
#   source_ranges = ["${var.allow_all}"]
#
#   allow {
#     protocol    = "all"
#   }
# }

resource "google_compute_firewall" "allow-ssh" {
  depends_on    = ["google_compute_network.game-default-vpc"]

  project       = "${var.project}"
  name          = "ssh-access"
  network       = "${var.name}-vpc"

  allow {
    protocol    = "tcp"
    ports       = ["22"]
  }
}

resource "google_compute_firewall" "rethinkdb" {
  depends_on    = ["google_compute_network.game-default-vpc"]

  name          = "rethinkdb"
  network       = "${var.name}-vpc"

  allow {
    protocol    = "tcp"
    ports       = ["28015", "29015", "8080"]
  }

  target_tags   = ["rethinkdb-cluster"]
  source_ranges = ["10.0.0.0/22", "10.0.4.0/22", "10.0.8.0/22"]
}
