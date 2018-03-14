
data "google_compute_region_instance_group" "rdb" {
    name = "${var.name}-rdb"
}

locals {
  instances = "${data.google_compute_region_instance_group.rdb.instances}"
}

resource "null_resource" "lorem" {
  provisioner "local-exec" {
    interpreter = ["sh", "-c"]
    command = "echo ${join(" ", local.instances)}"
  }
}
