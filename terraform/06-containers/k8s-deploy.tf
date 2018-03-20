
# https://www.terraform.io/docs/providers/template/r/dir.html
resource "template_dir" "k8s_templates" {
  source_dir      = "${path.cwd}/kube-tmpl"
  destination_dir = "${path.cwd}/kube-render"

  vars {
    project         = "${var.project}"
    backend_domain  = "${var.backend_domain}"
    backend_app_img = "${var.backend_app_img}"
    rdb_proxy_img   = "${var.rdb_proxy_img}"
  }
}

# https://www.terraform.io/docs/provisioners/null_resource.html
resource "null_resource" "wait_rdb_instances" {
  depends_on    = [ "template_dir.k8s_templates" ]

  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command = <<EOF
    cd ${path.cwd}/kube-render
  	for f in $(ls); do
  		kubectl apply -f "$f"
  		sleep 5
  	done
EOF
  }
}
