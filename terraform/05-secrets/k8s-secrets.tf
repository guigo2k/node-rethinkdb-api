
# https://www.terraform.io/docs/providers/kubernetes/r/secret.html

resource "kubernetes_secret" "rdb_hosts" {
  depends_on    = [
    "google_compute_project_metadata_item.rdb_metadata"
  ]

  metadata {
    name = "rethinkdb-hosts"
  }

  data {
    RDB_HOSTS = "${local.rdb_hosts}"
  }
}

resource "kubernetes_config_map" "rdb_env" {
  depends_on    = [
    "google_compute_project_metadata_item.rdb_metadata"
  ]

  metadata {
    name = "rethinkdb-environment"
  }

  data {
    NODE_ENV = "production"
    DB_HOST  = "rethinkdb-proxy"
    DB_PORT  = 28015
    DB_NAME  = "game"
  }
}

resource "kubernetes_secret" "cloud_dns" {
  metadata {
    name = "clouddns-service-account"
  }
  data {
    service-account = "${file(var.credentials)}"
  }
}
