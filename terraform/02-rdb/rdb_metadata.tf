
# https://www.terraform.io/docs/providers/google/r/compute_project_metadata_item.html

resource "google_compute_project_metadata_item" "rdb_metadata" {
  depends_on    = [
    "google_compute_region_instance_group_manager.rdb_cluster",
    "google_compute_target_pool.rdb_pool",
  ]

  count   = "${length(google_compute_target_pool.rdb_pool.instances)}"
  key     = "${var.name}-rdb-${count.index + 1}"
  value   = "${element(google_compute_target_pool.rdb_pool.instances, count.index)}"
}

resource "google_compute_project_metadata_item" "rdb_status" {
  depends_on    = ["google_compute_project_metadata_item.rdb_metadata"]

  key     = "${var.name}-rdb-status"
  value   = "READY"
}
