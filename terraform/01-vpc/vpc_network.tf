
# https://www.terraform.io/docs/providers/google/r/compute_network.html

resource "google_compute_network" "game_default_vpc" {
  name                    = "${var.name}-vpc"
  description             = "${var.name}-vpc"
  auto_create_subnetworks = "false"
}

# https://www.terraform.io/docs/providers/google/r/compute_subnetwork.html

resource "google_compute_subnetwork" "game_infra1" {
  name          = "${var.name}-${var.region}-infra1"
  description   = "${var.name}-${var.region}-infra1"
  network       = "${google_compute_network.game_default_vpc.self_link}"
  region        = "${var.region}"
  ip_cidr_range = "10.0.0.0/22"
}

resource "google_compute_subnetwork" "game_data1" {
  name          = "${var.name}-${var.region}-data1"
  description   = "${var.name}-${var.region}-data1"
  network       = "${google_compute_network.game_default_vpc.self_link}"
  region        = "${var.region}"
  ip_cidr_range = "10.0.4.0/22"
}

resource "google_compute_subnetwork" "game_app1" {
  name          = "${var.name}-${var.region}-app1"
  description   = "${var.name}-${var.region}-app1"
  network       = "${google_compute_network.game_default_vpc.self_link}"
  region        = "${var.region}"
  ip_cidr_range = "10.0.8.0/22"
}
