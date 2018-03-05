# resource "google_compute_instance" "bastion" {
#   name         = "${var.name}-bastion"
#   zone         = "${var.bastion_zone}"
#   machine_type = "g1-small"
#
#   tags = ["${var.name}-bastion", "${var.region}"]
#
#   boot_disk {
#     initialize_params {
#       image = "centos-cloud/centos-7"
#     }
#   }
#
#   network_interface {
#     subnetwork = "${var.name}-${var.region}-data1"
#
#     access_config {
#       // Ephemeral IP
#     }
#   }
#
#   metadata {
#     foo = "bar"
#   }
#
#   service_account {
#     scopes = ["userinfo-email", "compute-rw", "storage-rw"]
#   }
# }
