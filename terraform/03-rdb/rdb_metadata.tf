
# https://www.terraform.io/docs/providers/google/r/compute_project_metadata_item.html

resource "google_compute_project_metadata_item" "rdb_metadata" {
  depends_on    = [
    "google_compute_region_instance_group_manager.rdb_cluster",
    "google_compute_target_pool.rdb_pool"
  ]

  count   = "${length(local.rdb_list)}"
  key     = "${var.name}-rdb-${count.index + 1}"
  value   = "${element(local.rdb_list, count.index)}"
}

resource "google_compute_project_metadata_item" "rdb_status" {
  depends_on    = [
    "google_compute_project_metadata_item.rdb_metadata"
  ]

  key     = "${var.name}-status-rdb"
  value   = "active"
}

# https://www.terraform.io/docs/configuration/locals.html

locals {
  list       = "${join(",", google_compute_target_pool.rdb_pool.instances)}"
  search     = "${format("/%s-[[:alnum:]]//", google_compute_target_pool.rdb_pool.region)}"
  replace    = ""
  rdb_string = "${replace(local.list, local.search, local.replace)}"
  rdb_list   = "${split(",", local.rdb_string)}"
}
