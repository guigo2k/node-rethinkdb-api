
# https://www.terraform.io/docs/providers/google/r/compute_project_metadata_item.html

resource "google_compute_project_metadata_item" "rethinkdb" {
  depends_on    = [
    "google_compute_region_instance_group_manager.rethinkdb",
    "google_compute_target_pool.rethinkdb",
  ]

  count   = "${length(google_compute_target_pool.rethinkdb.instances)}"
  key     = "${var.name}-rdb-${count.index + 1}"
  value   = "${element(google_compute_target_pool.rethinkdb.instances, count.index)}"
}
