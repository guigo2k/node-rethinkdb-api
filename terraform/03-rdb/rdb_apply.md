
#### 1. Instance Targets
```
terraform apply -auto-approve \
--target=google_compute_region_instance_group_manager.rdb_cluster \
--target=google_compute_instance_template.rdb_template \
--target=google_compute_target_pool.rdb_pool \
--target=google_compute_firewall.rdb_firewall
```

#### 2. Metadata Targets
```
terraform apply -auto-approve \
--target=google_compute_project_metadata_item.rdb_metadata \
--target=google_compute_project_metadata_item.rdb_status \
--target=kubernetes_secret.rdb_hosts \
--target=kubernetes_config_map.rdb_env
```
