
# https://www.terraform.io/docs/providers/google/index.html

provider "google" {
  credentials = "${file("${var.credentials}")}"
  project     = "${var.project}"
  region      = "${var.region}"
}
