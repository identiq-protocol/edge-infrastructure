<!-- BEGIN_TF_DOCS -->
# Azure Edge infrastructure

This Terraform module creates Identiq's edge infrastructure on which the edge application will deployed on.
The infstructarue consists of the following components:
 * [AKS](https://docs.microsoft.com/en-us/azure/aks/intro-kubernetes) cluster
 * PostgreSQL (Containerized or Azure PostgreSQL)
 * Redis (Containerized or Azure Cache for Redis)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | =1.6.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | =2.74.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | =2.4.1 |
| <a name="requirement_local"></a> [local](#requirement\_local) | =2.1.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | =3.1.0 |
| <a name="requirement_template"></a> [template](#requirement\_template) | =2.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | =1.6.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | =2.74.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | =2.4.1 |
| <a name="provider_local"></a> [local](#provider\_local) | =2.1.0 |
| <a name="provider_random"></a> [random](#provider\_random) | =3.1.0 |
| <a name="provider_template"></a> [template](#provider\_template) | =2.2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aks"></a> [aks](#module\_aks) | Azure/aks/azurerm | n/a |
| <a name="module_network"></a> [network](#module\_network) | Azure/network/azurerm | n/a |
| <a name="module_postgresql"></a> [postgresql](#module\_postgresql) | ../terraform-azurerm-db-postgresql | n/a |
| <a name="module_redis"></a> [redis](#module\_redis) | claranet/redis/azurerm | n/a |

## Resources

| Name | Type |
|------|------|
| [azuread_application.app](https://registry.terraform.io/providers/hashicorp/azuread/1.6.0/docs/resources/application) | resource |
| [azuread_service_principal.app](https://registry.terraform.io/providers/hashicorp/azuread/1.6.0/docs/resources/service_principal) | resource |
| [azuread_service_principal_password.app](https://registry.terraform.io/providers/hashicorp/azuread/1.6.0/docs/resources/service_principal_password) | resource |
| [azurerm_kubernetes_cluster_node_pool.base](https://registry.terraform.io/providers/hashicorp/azurerm/2.74.0/docs/resources/kubernetes_cluster_node_pool) | resource |
| [azurerm_kubernetes_cluster_node_pool.cache](https://registry.terraform.io/providers/hashicorp/azurerm/2.74.0/docs/resources/kubernetes_cluster_node_pool) | resource |
| [azurerm_kubernetes_cluster_node_pool.db](https://registry.terraform.io/providers/hashicorp/azurerm/2.74.0/docs/resources/kubernetes_cluster_node_pool) | resource |
| [azurerm_kubernetes_cluster_node_pool.dynamic](https://registry.terraform.io/providers/hashicorp/azurerm/2.74.0/docs/resources/kubernetes_cluster_node_pool) | resource |
| [azurerm_nat_gateway.nat_gw](https://registry.terraform.io/providers/hashicorp/azurerm/2.74.0/docs/resources/nat_gateway) | resource |
| [azurerm_nat_gateway_public_ip_prefix_association.example](https://registry.terraform.io/providers/hashicorp/azurerm/2.74.0/docs/resources/nat_gateway_public_ip_prefix_association) | resource |
| [azurerm_private_endpoint.db_private_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/2.74.0/docs/resources/private_endpoint) | resource |
| [azurerm_public_ip_prefix.nat_ip](https://registry.terraform.io/providers/hashicorp/azurerm/2.74.0/docs/resources/public_ip_prefix) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/2.74.0/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.assignment](https://registry.terraform.io/providers/hashicorp/azurerm/2.74.0/docs/resources/role_assignment) | resource |
| [azurerm_subnet_nat_gateway_association.nat_gw_a](https://registry.terraform.io/providers/hashicorp/azurerm/2.74.0/docs/resources/subnet_nat_gateway_association) | resource |
| [kubernetes_config_map.version](https://registry.terraform.io/providers/hashicorp/kubernetes/2.4.1/docs/resources/config_map) | resource |
| [kubernetes_endpoints.external-db-endpoint](https://registry.terraform.io/providers/hashicorp/kubernetes/2.4.1/docs/resources/endpoints) | resource |
| [kubernetes_endpoints.external-redis-endpoint](https://registry.terraform.io/providers/hashicorp/kubernetes/2.4.1/docs/resources/endpoints) | resource |
| [kubernetes_secret.edge_db_secret](https://registry.terraform.io/providers/hashicorp/kubernetes/2.4.1/docs/resources/secret) | resource |
| [kubernetes_secret.edge_redis_secret](https://registry.terraform.io/providers/hashicorp/kubernetes/2.4.1/docs/resources/secret) | resource |
| [kubernetes_service.edge_db_service](https://registry.terraform.io/providers/hashicorp/kubernetes/2.4.1/docs/resources/service) | resource |
| [kubernetes_service.edge_redis_service](https://registry.terraform.io/providers/hashicorp/kubernetes/2.4.1/docs/resources/service) | resource |
| [local_file.kubeconfig](https://registry.terraform.io/providers/hashicorp/local/2.1.0/docs/resources/file) | resource |
| [random_password.db_password](https://registry.terraform.io/providers/hashicorp/random/3.1.0/docs/resources/password) | resource |
| [template_file.kubeconfig](https://registry.terraform.io/providers/hashicorp/template/2.2.0/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ad_application_dispaly_name"></a> [ad\_application\_dispaly\_name](#input\_ad\_application\_dispaly\_name) | The display name for the application | `string` | `"identiq-sa"` | no |
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | The address space that is used by the virtual network | `string` | `"10.0.0.0/16"` | no |
| <a name="input_aks_base_agents_max_pods"></a> [aks\_base\_agents\_max\_pods](#input\_aks\_base\_agents\_max\_pods) | The maximum number of pods that can run on each agent in 'base' node pool. Changing this forces a new resource to be created | `number` | `100` | no |
| <a name="input_aks_base_agents_node_count"></a> [aks\_base\_agents\_node\_count](#input\_aks\_base\_agents\_node\_count) | The number of Agents that should exist in the 'base' Agent Pool. Please set `agents_count` `null` while `enable_auto_scaling` is `true` to avoid possible `agents_count` changes | `number` | `1` | no |
| <a name="input_aks_base_agents_node_min_count"></a> [aks\_base\_agents\_node\_min\_count](#input\_aks\_base\_agents\_node\_min\_count) | AKS 'base' node pool minimum number of nodes in 'default' node pool | `number` | `1` | no |
| <a name="input_aks_base_agents_os_disk_size_gb"></a> [aks\_base\_agents\_os\_disk\_size\_gb](#input\_aks\_base\_agents\_os\_disk\_size\_gb) | AKS 'base' node pool disk size of nodes in GBs | `number` | `50` | no |
| <a name="input_aks_base_agents_vm_size"></a> [aks\_base\_agents\_vm\_size](#input\_aks\_base\_agents\_vm\_size) | AKS 'base' node pool - the default virtual machine size for the Kubernetes agents | `string` | `"Standard_F8s_v2"` | no |
| <a name="input_aks_base_enable_auto_scaling"></a> [aks\_base\_enable\_auto\_scaling](#input\_aks\_base\_enable\_auto\_scaling) | AKS 'base' node pool - enable node pool autoscaling | `bool` | `false` | no |
| <a name="input_aks_cache_agents_max_pods"></a> [aks\_cache\_agents\_max\_pods](#input\_aks\_cache\_agents\_max\_pods) | The maximum number of pods that can run on each agent in 'cache' node pool. Changing this forces a new resource to be created | `number` | `100` | no |
| <a name="input_aks_cache_agents_node_count"></a> [aks\_cache\_agents\_node\_count](#input\_aks\_cache\_agents\_node\_count) | The number of Agents that should exist in the 'cache' Agent Pool. Please set `agents_count` `null` while `enable_auto_scaling` is `true` to avoid possible `agents_count` changes | `number` | `1` | no |
| <a name="input_aks_cache_agents_node_min_count"></a> [aks\_cache\_agents\_node\_min\_count](#input\_aks\_cache\_agents\_node\_min\_count) | AKS 'cache' node pool minimum number of nodes in 'default' node pool | `number` | `1` | no |
| <a name="input_aks_cache_agents_os_disk_size_gb"></a> [aks\_cache\_agents\_os\_disk\_size\_gb](#input\_aks\_cache\_agents\_os\_disk\_size\_gb) | AKS 'cache' node pool disk size of nodes in GBs | `number` | `50` | no |
| <a name="input_aks_cache_agents_vm_size"></a> [aks\_cache\_agents\_vm\_size](#input\_aks\_cache\_agents\_vm\_size) | AKS 'cache' node pool - the default virtual machine size for the Kubernetes agents | `string` | `"Standard_E8s_v4"` | no |
| <a name="input_aks_cache_enable_auto_scaling"></a> [aks\_cache\_enable\_auto\_scaling](#input\_aks\_cache\_enable\_auto\_scaling) | AKS 'cache' node pool - enable node pool autoscaling | `bool` | `false` | no |
| <a name="input_aks_cluster_name"></a> [aks\_cluster\_name](#input\_aks\_cluster\_name) | The name for the AKS resources created in the specified Azure Resource Group. This variable overwrites the 'aks\_prefix' var (The 'aks\_prefix' var will still be applied to the dns\_prefix if it is set) | `string` | `"edge"` | no |
| <a name="input_aks_db_agents_max_pods"></a> [aks\_db\_agents\_max\_pods](#input\_aks\_db\_agents\_max\_pods) | The maximum number of pods that can run on each agent in 'db' node pool. Changing this forces a new resource to be created | `number` | `100` | no |
| <a name="input_aks_db_agents_node_count"></a> [aks\_db\_agents\_node\_count](#input\_aks\_db\_agents\_node\_count) | The number of Agents that should exist in the 'db' Agent Pool. Please set `agents_count` `null` while `enable_auto_scaling` is `true` to avoid possible `agents_count` changes | `number` | `1` | no |
| <a name="input_aks_db_agents_node_min_count"></a> [aks\_db\_agents\_node\_min\_count](#input\_aks\_db\_agents\_node\_min\_count) | AKS 'db' node pool minimum number of nodes in 'default' node pool | `number` | `1` | no |
| <a name="input_aks_db_agents_os_disk_size_gb"></a> [aks\_db\_agents\_os\_disk\_size\_gb](#input\_aks\_db\_agents\_os\_disk\_size\_gb) | AKS 'db' node pool disk size of nodes in GBs | `number` | `50` | no |
| <a name="input_aks_db_agents_vm_size"></a> [aks\_db\_agents\_vm\_size](#input\_aks\_db\_agents\_vm\_size) | AKS 'db' node pool - the default virtual machine size for the Kubernetes agents | `string` | `"Standard_D4ds_v4"` | no |
| <a name="input_aks_db_enable_auto_scaling"></a> [aks\_db\_enable\_auto\_scaling](#input\_aks\_db\_enable\_auto\_scaling) | AKS 'db' node pool - enable node pool autoscaling | `bool` | `false` | no |
| <a name="input_aks_default_agents_max_pods"></a> [aks\_default\_agents\_max\_pods](#input\_aks\_default\_agents\_max\_pods) | The maximum number of pods that can run on each agent in 'default' node pool. Changing this forces a new resource to be created | `number` | `100` | no |
| <a name="input_aks_default_agents_node_count"></a> [aks\_default\_agents\_node\_count](#input\_aks\_default\_agents\_node\_count) | The number of Agents that should exist in the 'default' Agent Pool. Please set `agents_count` `null` while `enable_auto_scaling` is `true` to avoid possible `agents_count` changes | `number` | `1` | no |
| <a name="input_aks_default_agents_node_min_count"></a> [aks\_default\_agents\_node\_min\_count](#input\_aks\_default\_agents\_node\_min\_count) | AKS 'default' node pool minimum number of nodes in 'default' node pool | `number` | `1` | no |
| <a name="input_aks_default_agents_os_disk_size_gb"></a> [aks\_default\_agents\_os\_disk\_size\_gb](#input\_aks\_default\_agents\_os\_disk\_size\_gb) | AKS 'default' node pool disk size of nodes in GBs | `number` | `50` | no |
| <a name="input_aks_default_agents_vm_size"></a> [aks\_default\_agents\_vm\_size](#input\_aks\_default\_agents\_vm\_size) | AKS 'default' node pool - the default virtual machine size for the Kubernetes agents | `string` | `"Standard_A2_v2"` | no |
| <a name="input_aks_default_enable_auto_scaling"></a> [aks\_default\_enable\_auto\_scaling](#input\_aks\_default\_enable\_auto\_scaling) | AKS 'default' node pool - enable node pool autoscaling | `bool` | `false` | no |
| <a name="input_aks_dynamic_agents_max_pods"></a> [aks\_dynamic\_agents\_max\_pods](#input\_aks\_dynamic\_agents\_max\_pods) | The maximum number of pods that can run on each agent in 'dynamic' node pool. Changing this forces a new resource to be created | `number` | `100` | no |
| <a name="input_aks_dynamic_agents_node_count"></a> [aks\_dynamic\_agents\_node\_count](#input\_aks\_dynamic\_agents\_node\_count) | The number of Agents that should exist in the 'dynamic' Agent Pool. Please set `agents_count` `null` while `enable_auto_scaling` is `true` to avoid possible `agents_count` changes | `number` | `1` | no |
| <a name="input_aks_dynamic_agents_node_min_count"></a> [aks\_dynamic\_agents\_node\_min\_count](#input\_aks\_dynamic\_agents\_node\_min\_count) | AKS 'dynamic' node pool minimum number of nodes in 'default' node pool | `number` | `1` | no |
| <a name="input_aks_dynamic_agents_os_disk_size_gb"></a> [aks\_dynamic\_agents\_os\_disk\_size\_gb](#input\_aks\_dynamic\_agents\_os\_disk\_size\_gb) | AKS 'dynamic' node pool disk size of nodes in GBs | `number` | `50` | no |
| <a name="input_aks_dynamic_agents_vm_size"></a> [aks\_dynamic\_agents\_vm\_size](#input\_aks\_dynamic\_agents\_vm\_size) | AKS 'dynamic' node pool - the default virtual machine size for the Kubernetes agents | `string` | `"Standard_F16s_v2"` | no |
| <a name="input_aks_dynamic_enable_auto_scaling"></a> [aks\_dynamic\_enable\_auto\_scaling](#input\_aks\_dynamic\_enable\_auto\_scaling) | AKS 'dynamic' node pool - enable node pool autoscaling | `bool` | `false` | no |
| <a name="input_aks_enable_log_analytics_workspace"></a> [aks\_enable\_log\_analytics\_workspace](#input\_aks\_enable\_log\_analytics\_workspace) | AKS enable the creation of azurerm\_log\_analytics\_workspace and azurerm\_log\_analytics\_solution or not | `bool` | `false` | no |
| <a name="input_aks_enable_role_based_access_control"></a> [aks\_enable\_role\_based\_access\_control](#input\_aks\_enable\_role\_based\_access\_control) | AKS Enable Role Based Access Control | `bool` | `true` | no |
| <a name="input_aks_kubernetes_version"></a> [aks\_kubernetes\_version](#input\_aks\_kubernetes\_version) | Version of Kubernetes specified when creating the AKS managed cluster. | `string` | `"1.21.9"` | no |
| <a name="input_aks_net_profile_dns_service_ip"></a> [aks\_net\_profile\_dns\_service\_ip](#input\_aks\_net\_profile\_dns\_service\_ip) | IP address within the Kubernetes service address range that will be used by cluster service discovery (kube-dns). Changing this forces a new resource to be created | `string` | `"10.30.0.10"` | no |
| <a name="input_aks_net_profile_docker_bridge_cidr"></a> [aks\_net\_profile\_docker\_bridge\_cidr](#input\_aks\_net\_profile\_docker\_bridge\_cidr) | IP address (in CIDR notation) used as the Docker bridge IP address on nodes. Changing this forces a new resource to be created | `string` | `"170.10.0.1/16"` | no |
| <a name="input_aks_net_profile_service_cidr"></a> [aks\_net\_profile\_service\_cidr](#input\_aks\_net\_profile\_service\_cidr) | The Network Range used by the Kubernetes service. Changing this forces a new resource to be created | `string` | `"10.30.0.0/24"` | no |
| <a name="input_aks_network_plugin"></a> [aks\_network\_plugin](#input\_aks\_network\_plugin) | AKS Network plugin to use for networking | `string` | `"azure"` | no |
| <a name="input_aks_network_policy"></a> [aks\_network\_policy](#input\_aks\_network\_policy) | Sets up network policy to be used with Azure CNI. Network policy allows us to control the traffic flow between pods. Currently supported values are calico and azure. Changing this forces a new resource to be created. | `string` | `"azure"` | no |
| <a name="input_aks_prefix"></a> [aks\_prefix](#input\_aks\_prefix) | The prefix for the resources created in the specified Azure Resource Group | `string` | `"identiq"` | no |
| <a name="input_aks_private_cluster_enabled"></a> [aks\_private\_cluster\_enabled](#input\_aks\_private\_cluster\_enabled) | If true cluster API server will be exposed only on internal IP address and available only in cluster vnet. | `bool` | `false` | no |
| <a name="input_aks_rbac_aad_managed"></a> [aks\_rbac\_aad\_managed](#input\_aks\_rbac\_aad\_managed) | Is the Azure Active Directory integration Managed, meaning that Azure will create/manage the Service Principal used for integration | `bool` | `true` | no |
| <a name="input_aks_sku_tier"></a> [aks\_sku\_tier](#input\_aks\_sku\_tier) | The SKU Tier that should be used for this Kubernetes Cluster. Possible values are Free and Paid | `string` | `"Paid"` | no |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | Default tags applied on all resources. If you wish to add tags DO NOT change this variable, instead change `tags` variable | `map` | <pre>{<br>  "Terraform": "true"<br>}</pre> | no |
| <a name="input_external_db"></a> [external\_db](#input\_external\_db) | Database will be installed outside of AKS cluster | `bool` | `true` | no |
| <a name="input_external_redis"></a> [external\_redis](#input\_external\_redis) | Redis will be installed outside of AKS cluster | `bool` | `false` | no |
| <a name="input_nat_gateway_idle_timeout_in_minutes"></a> [nat\_gateway\_idle\_timeout\_in\_minutes](#input\_nat\_gateway\_idle\_timeout\_in\_minutes) | The idle timeout which should be used in minutes | `number` | `10` | no |
| <a name="input_nat_gateway_sku_name"></a> [nat\_gateway\_sku\_name](#input\_nat\_gateway\_sku\_name) | The SKU which should be used. At this time the only supported value is `Standard` | `string` | `"Standard"` | no |
| <a name="input_postgresql_administrator_login"></a> [postgresql\_administrator\_login](#input\_postgresql\_administrator\_login) | PostgreSQL administrator login | `string` | `"edge"` | no |
| <a name="input_postgresql_allowed_cidrs"></a> [postgresql\_allowed\_cidrs](#input\_postgresql\_allowed\_cidrs) | Postgresql map of authorized cidrs, must be provided using remote states cloudpublic/cloudpublic/global/vars/terraform.state | `map(string)` | <pre>{<br>  "1": "10.0.0.0/24"<br>}</pre> | no |
| <a name="input_postgresql_auto_grow_enabled"></a> [postgresql\_auto\_grow\_enabled](#input\_postgresql\_auto\_grow\_enabled) | Enable/Disable auto-growing of the Postgresql storage. | `bool` | `false` | no |
| <a name="input_postgresql_backup_retention_days"></a> [postgresql\_backup\_retention\_days](#input\_postgresql\_backup\_retention\_days) | Bbackup retention days for the Postgresql server, supported values are between 7 and 35 days. | `number` | `10` | no |
| <a name="input_postgresql_capacity"></a> [postgresql\_capacity](#input\_postgresql\_capacity) | Capacity for PostgreSQL server sku - number of vCores : https://docs.microsoft.com/en-us/azure/postgresql/concepts-pricing-tiers | `number` | `2` | no |
| <a name="input_postgresql_client_name"></a> [postgresql\_client\_name](#input\_postgresql\_client\_name) | Name for the postgresql client | `string` | `"edge"` | no |
| <a name="input_postgresql_configurations"></a> [postgresql\_configurations](#input\_postgresql\_configurations) | PostgreSQL configurations to enable | `map(string)` | <pre>{<br>  "enable_hashagg": "on",<br>  "maintenance_work_mem": "2097151",<br>  "max_wal_size": "4096",<br>  "synchronous_commit": "off",<br>  "wal_buffers": "8192"<br>}</pre> | no |
| <a name="input_postgresql_databases_charset"></a> [postgresql\_databases\_charset](#input\_postgresql\_databases\_charset) | Valid PostgreSQL charset : https://www.postgresql.org/docs/current/multibyte.html#CHARSET-TABLE | `map(string)` | <pre>{<br>  "edge": "UTF8"<br>}</pre> | no |
| <a name="input_postgresql_databases_collation"></a> [postgresql\_databases\_collation](#input\_postgresql\_databases\_collation) | Valid PostgreSQL collation : http://www.postgresql.cn/docs/9.4/collation.html - be careful about https://docs.microsoft.com/en-us/windows/win32/intl/locale-names?redirectedfrom=MSDN | `map(string)` | <pre>{<br>  "edge": "en-US"<br>}</pre> | no |
| <a name="input_postgresql_databases_names"></a> [postgresql\_databases\_names](#input\_postgresql\_databases\_names) | The list of names of the PostgreSQL Database, which needs to be a valid PostgreSQL identifier. | `list(string)` | <pre>[<br>  "edge"<br>]</pre> | no |
| <a name="input_postgresql_enable_logs_to_log_analytics"></a> [postgresql\_enable\_logs\_to\_log\_analytics](#input\_postgresql\_enable\_logs\_to\_log\_analytics) | Boolean flag to specify whether the Postgresql logs should be sent to Log Analytics | `bool` | `false` | no |
| <a name="input_postgresql_enable_logs_to_storage"></a> [postgresql\_enable\_logs\_to\_storage](#input\_postgresql\_enable\_logs\_to\_storage) | Boolean flag to specify whether the Postgresql logs should be sent to the Storage Account | `bool` | `false` | no |
| <a name="input_postgresql_environment"></a> [postgresql\_environment](#input\_postgresql\_environment) | Postgresql name of application's environnement | `string` | `"production"` | no |
| <a name="input_postgresql_force_ssl"></a> [postgresql\_force\_ssl](#input\_postgresql\_force\_ssl) | Postgresql force usage of SSL | `bool` | `true` | no |
| <a name="input_postgresql_geo_redundant_backup_enabled"></a> [postgresql\_geo\_redundant\_backup\_enabled](#input\_postgresql\_geo\_redundant\_backup\_enabled) | Turn Geo-redundant Postgresql server backups on/off. Not available for the Basic tier. | `bool` | `true` | no |
| <a name="input_postgresql_logs_log_analytics_workspace_id"></a> [postgresql\_logs\_log\_analytics\_workspace\_id](#input\_postgresql\_logs\_log\_analytics\_workspace\_id) | Log Analytics Workspace id for logs | `string` | `""` | no |
| <a name="input_postgresql_logs_storage_account_id"></a> [postgresql\_logs\_storage\_account\_id](#input\_postgresql\_logs\_storage\_account\_id) | Storage Account id for logs | `string` | `""` | no |
| <a name="input_postgresql_logs_storage_retention"></a> [postgresql\_logs\_storage\_retention](#input\_postgresql\_logs\_storage\_retention) | Retention in days for Postgresql logs on Storage Account | `number` | `30` | no |
| <a name="input_postgresql_storage_mb"></a> [postgresql\_storage\_mb](#input\_postgresql\_storage\_mb) | Max storage allowed for a Postgresql server. Possible values are between 5120 MB(5GB) and 1048576 MB(1TB) for the Basic SKU and between 5120 MB(5GB) and 4194304 MB(4TB) for General Purpose/Memory Optimized SKUs. | `number` | `1048576` | no |
| <a name="input_postgresql_tier"></a> [postgresql\_tier](#input\_postgresql\_tier) | Tier for PostgreSQL server sku : https://docs.microsoft.com/en-us/azure/postgresql/concepts-pricing-tiers Possible values are: GeneralPurpose, Basic, MemoryOptimized | `string` | `"GeneralPurpose"` | no |
| <a name="input_postgresql_version"></a> [postgresql\_version](#input\_postgresql\_version) | Postgresql version. Valid values are 9.5, 9.6, 10, 10.0, and 11 | `string` | `"11"` | no |
| <a name="input_public_ip_prefix_prefix_length"></a> [public\_ip\_prefix\_prefix\_length](#input\_public\_ip\_prefix\_prefix\_length) | Specifies the number of bits of the prefix. The value can be set between 0 (4,294,967,296 addresses) and 31 (2 addresses). Changing this forces a new resource to be created | `number` | `31` | no |
| <a name="input_redis_allow_non_ssl_connections"></a> [redis\_allow\_non\_ssl\_connections](#input\_redis\_allow\_non\_ssl\_connections) | Activate non SSL port (6779) for Redis connection | `bool` | `true` | no |
| <a name="input_redis_authorized_cidrs"></a> [redis\_authorized\_cidrs](#input\_redis\_authorized\_cidrs) | Redis map of authorized cidrs | `map(string)` | <pre>{<br>  "ip1": "10.0.0.0/16"<br>}</pre> | no |
| <a name="input_redis_capacity"></a> [redis\_capacity](#input\_redis\_capacity) | Redis size: (Basic/Standard: 1,2,3,4,5,6) (Premium: 1,2,3,4)  https://docs.microsoft.com/fr-fr/azure/redis-cache/cache-how-to-premium-clustering | `number` | `2` | no |
| <a name="input_redis_environment"></a> [redis\_environment](#input\_redis\_environment) | Name of the Redis environnement | `string` | `"production"` | no |
| <a name="input_redis_logs_destinations_ids"></a> [redis\_logs\_destinations\_ids](#input\_redis\_logs\_destinations\_ids) | List of logs destinations IDs | `list(string)` | `[]` | no |
| <a name="input_redis_sku_name"></a> [redis\_sku\_name](#input\_redis\_sku\_name) | Redis Cache Sku name. Can be Basic, Standard or Premium | `string` | `"Premium"` | no |
| <a name="input_region"></a> [region](#input\_region) | The Azure Region where the Resource Group (and the edge) should exist. Changing this forces a new Resource Group to be created | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The Name which should be used for this Resource Group. Changing this forces a new Resource Group to be created | `string` | `"identiq-edge"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Any tags the user wishes to add to all resources of the edge | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_connect"></a> [connect](#output\_connect) | n/a |
| <a name="output_nat_ip"></a> [nat\_ip](#output\_nat\_ip) | n/a |
<!-- END_TF_DOCS -->