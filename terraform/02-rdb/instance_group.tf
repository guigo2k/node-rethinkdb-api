
# https://www.terraform.io/docs/providers/google/r/compute_instance_group_manager.html

resource "google_compute_health_check" "autohealing" {
  name                = "autohealing-health-check"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10   # 50 seconds

  http_health_check {
    request_path = "/"
    port         = "8080"
  }
}

resource "google_compute_region_instance_group_manager" "rethinkdb" {
  name               = "${var.name}-rdb"
  base_instance_name = "${var.name}-rdb"
  instance_template  = "${google_compute_instance_template.rethinkdb.self_link}"
  region             = "${var.region}"
  target_pools       = ["${google_compute_target_pool.rethinkdb.self_link}"]
  target_size        = "${var.rdb_target_size}"

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

  auto_healing_policies {
    health_check      = "${google_compute_health_check.autohealing.self_link}"
    initial_delay_sec = 300
  }
}

# https://www.terraform.io/docs/providers/google/r/compute_target_pool.html

resource "google_compute_target_pool" "rethinkdb" {
  name = "rethinkdb-pool"

  health_checks = [
    "${google_compute_http_health_check.rethinkdb.name}",
  ]
}

resource "google_compute_http_health_check" "rethinkdb" {
  name               = "rethinkdb"
  request_path       = "/"
  port               = 8080
  check_interval_sec = 1
  timeout_sec        = 1
}
