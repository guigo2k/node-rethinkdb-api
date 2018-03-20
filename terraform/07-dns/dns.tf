


# https://www.terraform.io/docs/provisioners/null_resource.html
resource "null_resource" "get_nginx_external_ip" {
  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command = <<EOF
    nginx="nginx-nginx-ingress-controller"
    cmd="kubectl get svc $nginx -o json | jq -r '.status.loadBalancer.ingress | .[] | .ip'"
    until eval "$cmd" 2>/dev/null > backend_ip.txt; do
     sleep 3
    done
EOF
  }
}


resource "google_dns_record_set" "backend" {
  depends_on   = [ "null_resource.get_nginx_external_ip" ]

  managed_zone = "${var.managed_zone}"
  name         = "${var.backend_domain}."
  type         = "A"
  ttl          = 300

  rrdatas      = ["${chomp(file("backend_ip.txt"))}"]
}
