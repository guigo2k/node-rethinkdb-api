
# https://www.terraform.io/docs/providers/google/r/compute_firewall.html

resource "null_resource" "local_ip" {
  provisioner "local-exec" {
    interpreter = ["sh", "-c"]
    command = "echo -n `curl ifconfig.me`/32 > local_ip.txt"
  }
}

resource "google_compute_firewall" "allow-all" {
  depends_on    = ["google_compute_network.game-default-vpc"]

  name          = "allow-all"
  project       = "${var.project}"
  network       = "${var.name}-vpc"
  source_ranges = ["${chomp(file("local_ip.txt"))}"]

  allow {
    protocol = "all"
  }
}
