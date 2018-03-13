
data "template_file" "startup_script" {
  template = <<EOF
#!/bin/bash -e
/opt/rethinkdb/rdb_service start
EOF
}

# https://www.terraform.io/docs/providers/google/r/compute_instance_template.html

resource "google_compute_instance_template" "rdb_template" {
  description = "This template is used to create rethinkdb instances."
  name        = "${var.name}-rdb"
  tags        = ["${var.name}-rdb-cluster", "${var.region}"]

  labels      = {
    environment = "${var.env}"
  }

  metadata_startup_script = "${data.template_file.startup_script.rendered}"
  instance_description    = "rethinkdb cluster instances"
  machine_type            = "${var.rdb_machine_type}"
  can_ip_forward          = false

  scheduling {
    preemptible         = false
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  // Create a new boot disk from an image
  disk {
    source_image = "${var.rdb_source_image}"
    auto_delete  = true
    boot         = true
    disk_size_gb = "30"
    disk_type    = "pd-ssd"
  }

  network_interface {
    subnetwork = "${var.name}-${var.region}-data1"

    # access_config {
    #   // Ephemeral IP
    # }
  }

  service_account {
    scopes = ["userinfo-email"]
  }
}
