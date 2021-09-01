<!-- BEGIN_TF_DOCS -->
# GCP Edge infrastructure

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | n/a |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_gke"></a> [gke](#module\_gke) | terraform-google-modules/kubernetes-engine/google//modules/private-cluster | 16.0.1 |
| <a name="module_memorystore-redis"></a> [memorystore-redis](#module\_memorystore-redis) | terraform-google-modules/memorystore/google | 4.0.0 |
| <a name="module_postgresql-db"></a> [postgresql-db](#module\_postgresql-db) | GoogleCloudPlatform/sql-db/google//modules/postgresql | 6.0.0 |
| <a name="module_private-service-access"></a> [private-service-access](#module\_private-service-access) | GoogleCloudPlatform/sql-db/google//modules/private_service_access | 6.0.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ./modules/vpc | n/a |

## Resources

| Name | Type |
|------|------|
| [kubernetes_secret.edge_db_secret](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.edge_redis_secret](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_service.edge_db_service](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [kubernetes_service.edge_redis_service](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [kubernetes_storage_class.ssd](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/storage_class) | resource |
| [null_resource.patch-standard-sc](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [google-beta_google_compute_zones.available](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/data-sources/google_compute_zones) | data source |
| [google_client_config.provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config) | data source |
| [google_container_cluster.gke_cluster](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/container_cluster) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The cluster name | `any` | n/a | yes |
| <a name="input_compute_engine_service_account"></a> [compute\_engine\_service\_account](#input\_compute\_engine\_service\_account) | Service account to associate to the nodes in the cluster | `string` | `"default"` | no |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | Default tags applied on all resources. If you wish to add tags DO NOT change this variable, instead change `tags` variable | `map` | <pre>{<br>  "terraform": "true"<br>}</pre> | no |
| <a name="input_external_db"></a> [external\_db](#input\_external\_db) | Whether to create and use external cloud managed db instance | `bool` | `true` | no |
| <a name="input_external_db_authorized_networks"></a> [external\_db\_authorized\_networks](#input\_external\_db\_authorized\_networks) | List of mapped public networks authorized to access to the instances. Default - short range of GCP health-checkers IPs | `list(map(string))` | <pre>[<br>  {<br>    "name": "sample-gcp-health-checkers-range",<br>    "value": "130.211.0.0/28"<br>  }<br>]</pre> | no |
| <a name="input_external_db_deletion_protection"></a> [external\_db\_deletion\_protection](#input\_external\_db\_deletion\_protection) | Used to block Terraform from deleting a SQL Instance. | `bool` | `true` | no |
| <a name="input_external_db_postgres_backup_configuration"></a> [external\_db\_postgres\_backup\_configuration](#input\_external\_db\_postgres\_backup\_configuration) | The backup\_configuration settings subblock for the database setings | <pre>object({<br>    enabled                        = bool<br>    start_time                     = string<br>    location                       = string<br>    point_in_time_recovery_enabled = bool<br>    transaction_log_retention_days = string<br>    retained_backups               = number<br>    retention_unit                 = string<br>  })</pre> | <pre>{<br>  "enabled": true,<br>  "location": null,<br>  "point_in_time_recovery_enabled": false,<br>  "retained_backups": 7,<br>  "retention_unit": null,<br>  "start_time": null,<br>  "transaction_log_retention_days": null<br>}</pre> | no |
| <a name="input_external_db_postgres_disk_autoresize"></a> [external\_db\_postgres\_disk\_autoresize](#input\_external\_db\_postgres\_disk\_autoresize) | Configuration to increase Posgres storage size. | `bool` | `true` | no |
| <a name="input_external_db_postgres_disk_size"></a> [external\_db\_postgres\_disk\_size](#input\_external\_db\_postgres\_disk\_size) | External database(cloud SQL) disk size | `string` | `"1000"` | no |
| <a name="input_external_db_postgres_machine_type"></a> [external\_db\_postgres\_machine\_type](#input\_external\_db\_postgres\_machine\_type) | External database(cloud SQL) machine type | `string` | `"db-custom-2-8192"` | no |
| <a name="input_external_db_postgres_version"></a> [external\_db\_postgres\_version](#input\_external\_db\_postgres\_version) | External database(cloud SQL) postgres version | `string` | `"POSTGRES_13"` | no |
| <a name="input_external_db_user_name"></a> [external\_db\_user\_name](#input\_external\_db\_user\_name) | The name of the default user for external db | `string` | `"edge"` | no |
| <a name="input_external_redis"></a> [external\_redis](#input\_external\_redis) | Whenever to create and use external cloud managed redis instance | `bool` | `false` | no |
| <a name="input_external_redis_configs"></a> [external\_redis\_configs](#input\_external\_redis\_configs) | external redis(memorystore) configuration parameters | `map` | `{}` | no |
| <a name="input_external_redis_memory_size_gb"></a> [external\_redis\_memory\_size\_gb](#input\_external\_redis\_memory\_size\_gb) | external redis(memorystore) memory size in GB per node | `number` | `64` | no |
| <a name="input_external_redis_tier"></a> [external\_redis\_tier](#input\_external\_redis\_tier) | external redis(memorystore) service tier of the instance. | `string` | `"BASIC"` | no |
| <a name="input_external_redis_transit_encryption_mode"></a> [external\_redis\_transit\_encryption\_mode](#input\_external\_redis\_transit\_encryption\_mode) | The TLS mode of the Redis instance, If not provided, TLS is disabled for the instance. | `string` | `"DISABLED"` | no |
| <a name="input_external_redis_version"></a> [external\_redis\_version](#input\_external\_redis\_version) | external redis(memorystore) version | `string` | `"REDIS_5_0"` | no |
| <a name="input_gke_cluster_autoscaling"></a> [gke\_cluster\_autoscaling](#input\_gke\_cluster\_autoscaling) | Cluster autoscaling configuration. See [more details](https://cloud.google.com/kubernetes-engine/docs/reference/rest/v1beta1/projects.locations.clusters#clusterautoscaling) | <pre>object({<br>    enabled             = bool<br>    autoscaling_profile = string<br>    min_cpu_cores       = number<br>    max_cpu_cores       = number<br>    min_memory_gb       = number<br>    max_memory_gb       = number<br>    gpu_resources = list(object({<br>      resource_type = string<br>      minimum       = number<br>      maximum       = number<br>    }))<br>  })</pre> | <pre>{<br>  "autoscaling_profile": "BALANCED",<br>  "enabled": false,<br>  "gpu_resources": [],<br>  "max_cpu_cores": 0,<br>  "max_memory_gb": 0,<br>  "min_cpu_cores": 0,<br>  "min_memory_gb": 0<br>}</pre> | no |
| <a name="input_gke_enable_private_nodes"></a> [gke\_enable\_private\_nodes](#input\_gke\_enable\_private\_nodes) | (Beta) Whether nodes have internal IP addresses only | `bool` | `true` | no |
| <a name="input_gke_ip_range_pods"></a> [gke\_ip\_range\_pods](#input\_gke\_ip\_range\_pods) | The _name_ of the secondary subnet ip range to use for pods | `string` | `""` | no |
| <a name="input_gke_ip_range_services"></a> [gke\_ip\_range\_services](#input\_gke\_ip\_range\_services) | The _name_ of the secondary subnet range to use for services | `string` | `""` | no |
| <a name="input_gke_nodegroup_base_machine_count"></a> [gke\_nodegroup\_base\_machine\_count](#input\_gke\_nodegroup\_base\_machine\_count) | gke base nodegroup max count of machines | `string` | `"1"` | no |
| <a name="input_gke_nodegroup_base_machinetype"></a> [gke\_nodegroup\_base\_machinetype](#input\_gke\_nodegroup\_base\_machinetype) | gke base nodegroup machine type | `string` | `"c2-standard-8"` | no |
| <a name="input_gke_nodegroup_cache_machine_count"></a> [gke\_nodegroup\_cache\_machine\_count](#input\_gke\_nodegroup\_cache\_machine\_count) | gke cache nodegroup max count of machines | `string` | `"1"` | no |
| <a name="input_gke_nodegroup_cache_machinetype"></a> [gke\_nodegroup\_cache\_machinetype](#input\_gke\_nodegroup\_cache\_machinetype) | gke cache nodegroup machine type | `string` | `"c2-standard-8"` | no |
| <a name="input_gke_nodegroup_db_machine_count"></a> [gke\_nodegroup\_db\_machine\_count](#input\_gke\_nodegroup\_db\_machine\_count) | gke db nodegroup max count of machines | `string` | `"1"` | no |
| <a name="input_gke_nodegroup_db_machinetype"></a> [gke\_nodegroup\_db\_machinetype](#input\_gke\_nodegroup\_db\_machinetype) | gke db nodegroup machine type | `string` | `"c2-standard-8"` | no |
| <a name="input_gke_nodegroup_dynamic_machine_count"></a> [gke\_nodegroup\_dynamic\_machine\_count](#input\_gke\_nodegroup\_dynamic\_machine\_count) | gke dynamic nodegroup max count of machines | `string` | `"1"` | no |
| <a name="input_gke_nodegroup_dynamic_machinetype"></a> [gke\_nodegroup\_dynamic\_machinetype](#input\_gke\_nodegroup\_dynamic\_machinetype) | gke dynamic nodegroup machine type | `string` | `"c2-standard-8"` | no |
| <a name="input_gke_version"></a> [gke\_version](#input\_gke\_version) | gke Kubernetes version | `string` | `"1.19.12-gke.2100"` | no |
| <a name="input_gke_zones"></a> [gke\_zones](#input\_gke\_zones) | The zones for gke control plane | `list` | `[]` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project ID to host all resources in | `any` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region to host all resources in | `string` | `"us-east1"` | no |
| <a name="input_regional"></a> [regional](#input\_regional) | Whether is a regional cluster (zonal cluster if set false. WARNING: changing this after cluster creation is destructive!) | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Any tags the user wishes to add to all resources | `map(string)` | n/a | yes |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Name to be used on all the resources as identifier | `string` | `"identiq-vpc"` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | The zone to host the cluster in (required if is a zonal cluster) | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_gke_connect"></a> [gke\_connect](#output\_gke\_connect) | command to generate gke kubeconfig |
| <a name="output_nat_ip"></a> [nat\_ip](#output\_nat\_ip) | n/a |
| <a name="output_network_name"></a> [network\_name](#output\_network\_name) | The name of the VPC being created |
<!-- END_TF_DOCS -->