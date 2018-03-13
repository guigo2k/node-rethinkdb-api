
# https://www.terraform.io/docs/providers/kubernetes/r/secret.html

resource "kubernetes_secret" "rdb_hosts" {
  depends_on    = [
    "google_compute_region_instance_group_manager.rdb_cluster",
    "google_compute_target_pool.rdb_pool",
  ]

  metadata {
    name = "rdb-hosts"
  }

  data {
    rdb_hosts = "${local.rdb_string}"
  }
}

resource "kubernetes_config_map" "rdb_env" {
  depends_on    = [
    "google_compute_region_instance_group_manager.rdb_cluster",
    "google_compute_target_pool.rdb_pool",
  ]

  metadata {
    name = "rdb-env"
  }

  data {
    NODE_ENV = "production"
    DB_HOST  = "rdb-proxy"
    DB_PORT  = 28015
    DB_NAME  = "game"
  }
}
