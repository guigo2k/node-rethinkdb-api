.PHONY: req all vpc img-rdb-proxy img-rdb-server imgs kube rdb data app dns rm-vpc rm-kube rm-rdb rm-data rm-app rm-dns rm-fw rm-all render deploy rm-deploy rm-render

SHELL      := /bin/bash
required   := jq docker gcloud kubectl packer terraform
tf_dir     := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
tf_apply   := [[ ! -d '.terraform' ]] && terraform init; terraform apply -auto-approve
tf_destroy := terraform destroy -force

req:
	@for bin in "$(required)"; do \
		command -v $$bin > /dev/null; \
		if [[ $$? -ne 0 ]]; then \
			echo "error: '$$bin' is required"; \
			exit 1; \
		fi; \
	done

# ------------------------------------------------------------------------------
# APPLY
# ------------------------------------------------------------------------------

# deploy everything, cool!
all:
	@$(MAKE) -s vpc
	@$(MAKE) -s imgs
	@$(MAKE) -s kube
	@$(MAKE) -s rdb
	@$(MAKE) -s data
	@$(MAKE) -s app
	@$(MAKE) -s dns

# skip images, oh yeah...
less:
	@$(MAKE) -s vpc
	@$(MAKE) -s kube
	@$(MAKE) -s rdb
	@$(MAKE) -s data
	@$(MAKE) -s app
	@$(MAKE) -s dns

# deploy vpc, subnets, bastion and firewall :)
vpc: req
	@cd $(tf_dir)/01-vpc/ && $(tf_apply)

# build rethinkdb proxy docker image
img-rdb-proxy:
	@cd $(tf_dir)/02-images/ &&\
	source $(tf_dir)/.env &&\
	packer build rethinkdb-proxy.json

# build rethinkdb server gce image
img-rdb-server: vpc
	@cd $(tf_dir)/02-images/ &&\
	source $(tf_dir)/.env &&\
	packer build rethinkdb-server.json

# build all images, oh!
imgs:
	$(MAKE) img-rdb-proxy
	$(MAKE) img-rdb-server

# deploy kube cluster
kube:
	@cd $(tf_dir)/03-kubernetes/ && $(tf_apply)

# deploy rethinkdb cluster
rdb:
	@cd $(tf_dir)/04-rethinkdb/ && $(tf_apply)

# deploy secrets and metadata
data:
	@cd $(tf_dir)/05-secrets/ && $(tf_apply)

# render and deploy kube templates
app:
	@cd $(tf_dir)/06-containers/ && $(tf_apply)

# render kube templates
render:
	@cd $(tf_dir)/06-containers/ && $(tf_apply) \
	-target=template_dir.k8s_templates

# deploy kube templates
deploy:
	@cd $(tf_dir)/06-containers/ && $(tf_apply) \
	-target=null_resource.k8s_deploy

# create dns entry for the app
dns:
	@cd $(tf_dir)/07-dns/ && $(tf_apply)

# ------------------------------------------------------------------------------
# DESTROY
# ------------------------------------------------------------------------------

# destroy everything! ahh...
rm-all:
	@$(MAKE) -s rm-dns
	@$(MAKE) -s rm-app
	@$(MAKE) -s rm-data
	@$(MAKE) -s rm-rdb
	@$(MAKE) -s rm-kube
	@$(MAKE) -s rm-vpc

# destroy vpc, subnets, bastion and firewall :(
rm-vpc: rm-fw
	@cd $(tf_dir)/01-vpc/ && $(tf_destroy)

# destroy kube cluster
rm-kube:
	@cd $(tf_dir)/03-kubernetes/ && $(tf_destroy)

# destroy rethinkdb cluster
rm-rdb:
	@cd $(tf_dir)/04-rethinkdb/ && $(tf_destroy)

# delete secrets and metadata
rm-data:
	@cd $(tf_dir)/05-secrets/ && $(tf_destroy)

# delete app and templates
rm-app:
	@cd $(tf_dir)/06-containers/kube-render &&\
	kubectl delete -f . && cd .. && $(tf_destroy)

# delete app deployments
rm-deploy:
	@cd $(tf_dir)/06-containers/kube-render &&\
	kubectl delete -f .

# delete rendered templates
rm-render:
	@cd $(tf_dir)/06-containers/ && $(tf_destroy) \
	-target=template_dir.k8s_templates

# delete apps`s dns entry
rm-dns:
	@cd $(tf_dir)/07-dns/ && $(tf_destroy)

# delete ingresses firewall rules
rm-fw:
	@source $(tf_dir)/.env; \
	cmd="gcloud compute firewall-rules list --filter='network:$${name}-vpc' --format=json | jq -r '.[] | .name'"; \
	for rule in $$(eval "$$cmd"); do \
		gcloud compute firewall-rules delete -q "$$rule"; \
	done
