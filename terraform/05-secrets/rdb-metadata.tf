
# https://www.terraform.io/docs/providers/google/r/compute_project_metadata_item.html

resource "google_compute_project_metadata_item" "rdb_metadata" {
  count   = "${length(local.rdb_instances)}"
  key     = "${var.name}-rdb-${count.index + 1}"
  value   = "${element(local.rdb_instances, count.index)}"
}

resource "google_compute_project_metadata_item" "rdb_status" {
  depends_on    = [
    "google_compute_project_metadata_item.rdb_metadata"
  ]

  key     = "${var.name}-status-rdb"
  value   = "active"
}

# https://www.terraform.io/docs/providers/google/d/datasource_compute_region_instance_group.html

data "google_compute_region_instance_group" "rdb_data" {
  name = "${var.name}-rdb"
}

data "template_file" "rdb_instances" {
  count = "${length(data.google_compute_region_instance_group.rdb_data.instances)}"
  template = "${basename(lookup(data.google_compute_region_instance_group.rdb_data.instances[count.index], "instance"))}"
}

locals {
  rdb_instances = "${data.template_file.rdb_instances.*.rendered}"
  rdb_hosts     = "${join(",", local.rdb_instances)}"
}

output "rdb_instances" {
  value = "${local.rdb_instances}"
}
