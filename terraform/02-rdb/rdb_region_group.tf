
# https://www.terraform.io/docs/providers/google/r/compute_instance_group_manager.html

# resource "google_compute_health_check" "autohealing" {
#   name                = "autohealing-health-check"
#   check_interval_sec  = 5
#   timeout_sec         = 5
#   healthy_threshold   = 2
#   unhealthy_threshold = 10   # 50 seconds
#
#   http_health_check {
#     request_path = "/"
#     port         = "8080"
#   }
# }

resource "google_compute_region_instance_group_manager" "rdb_cluster" {
  name               = "${var.name}-rdb"
  base_instance_name = "${var.name}-rdb"

  region             = "${var.region}"
  target_size        = "${var.rdb_target_size}"
  target_pools       = ["${google_compute_target_pool.rdb_pool.self_link}"]
  instance_template  = "${google_compute_instance_template.rdb_template.self_link}"

  named_port {
    name = "cluster"
    port = 29015
  }

  named_port {
    name = "client"
    port = 28015
  }

  named_port {
    name = "admin"
    port = 8080
  }

  # auto_healing_policies {
  #   health_check      = "${google_compute_health_check.autohealing.self_link}"
  #   initial_delay_sec = 300
  # }

}

# https://www.terraform.io/docs/providers/google/r/compute_target_pool.html

resource "google_compute_target_pool" "rdb_pool" {
  name = "${var.name}-rdb-pool"
}
