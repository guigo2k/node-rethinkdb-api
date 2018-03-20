.PHONY: req all dev vpc img-rdb-proxy img-rdb-server images kube rdb secrets app dns rm-vpc rm-kube rm-rdb rm-secrets rm-app rm-dns rm-fw rm-all

SHELL    := /bin/bash
required := jq docker gcloud kubectl packer terraform
tf_dir   := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

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

all:
	@$(MAKE) vpc
	@$(MAKE) imgs
	@$(MAKE) kube
	@$(MAKE) rdb
	@$(MAKE) data
	@$(MAKE) app
	@$(MAKE) dns

vpc: req
	@cd $(tf_dir)/01-vpc/ &&\
	terraform apply -auto-approve

img-rdb-proxy:
	@cd $(tf_dir)/02-images/ &&\
	source $(tf_dir)/.env &&\
	packer build rethinkdb-proxy.json

img-rdb-server: vpc
	@cd $(tf_dir)/02-images/ &&\
	source $(tf_dir)/.env &&\
	packer build rethinkdb-server.json

imgs:
	$(MAKE) img-rdb-proxy
	$(MAKE) img-rdb-server

kube:
	@cd $(tf_dir)/03-kubernetes/ &&\
	terraform apply -auto-approve

rdb:
	@cd $(tf_dir)/04-rethinkdb/ &&\
	terraform apply -auto-approve

data:
	@cd $(tf_dir)/05-secrets/ &&\
	terraform apply -auto-approve

app:
	@cd $(tf_dir)/06-containers/ &&\
	terraform apply -auto-approve

dns:
	@cd $(tf_dir)/07-dns/ &&\
	terraform apply -auto-approve

# ------------------------------------------------------------------------------
# DESTROY
# ------------------------------------------------------------------------------

rm-all:
	@$(MAKE) rm-dns
	@$(MAKE) rm-app
	@$(MAKE) rm-data
	@$(MAKE) rm-rdb
	@$(MAKE) rm-kube
	@$(MAKE) rm-vpc

rm-vpc: rm-fw
	@cd $(tf_dir)/01-vpc/ &&\
	terraform destroy -force

rm-kube:
	@cd $(tf_dir)/03-kubernetes/ &&\
	terraform destroy -force

rm-rdb:
	@cd $(tf_dir)/04-rethinkdb/ &&\
	terraform destroy -force

rm-data:
	@cd $(tf_dir)/05-secrets/ &&\
	terraform destroy -force

rm-app:
	@cd $(tf_dir)/06-containers/kube-render &&\
	kubectl delete -f . && cd .. &&\
	terraform destroy -force

rm-dns:
	@cd $(tf_dir)/07-dns/ &&\
	terraform destroy -force

rm-fw:
	@source $(tf_dir)/.env &&\
	cmd="gcloud compute firewall-rules list --filter='network:$${name}-vpc' --format=json | jq -r '.[] | .name'" &&\
	for rule in $$(eval "$$cmd"); do \
		gcloud compute firewall-rules delete -q "$$rule"; \
	done
