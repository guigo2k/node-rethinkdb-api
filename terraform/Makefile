.PHONY: req all vpc img-rdb-proxy img-rdb-server imgs kube rdb data app dns rm-vpc rm-kube rm-rdb rm-data rm-app rm-dns rm-fw rm-all

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
	@$(MAKE) -s vpc
	@$(MAKE) -s imgs
	@$(MAKE) -s kube
	@$(MAKE) -s rdb
	@$(MAKE) -s data
	@$(MAKE) -s app
	@$(MAKE) -s dns

vpc: req
	@cd $(tf_dir)/01-vpc/ &&\
	terraform init &&\
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
	terraform init &&\
	terraform apply -auto-approve

rdb:
	@cd $(tf_dir)/04-rethinkdb/ &&\
	terraform init &&\
	terraform apply -auto-approve

data:
	@cd $(tf_dir)/05-secrets/ &&\
	terraform init &&\
	terraform apply -auto-approve

app:
	@cd $(tf_dir)/06-containers/ &&\
	terraform init &&\
	terraform apply -auto-approve

dns:
	@cd $(tf_dir)/07-dns/ &&\
	terraform init &&\
	terraform apply -auto-approve

# ------------------------------------------------------------------------------
# DESTROY
# ------------------------------------------------------------------------------

rm-all:
	@$(MAKE) -s rm-dns
	@$(MAKE) -s rm-app
	@$(MAKE) -s rm-data
	@$(MAKE) -s rm-rdb
	@$(MAKE) -s rm-kube
	@$(MAKE) -s rm-vpc

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
