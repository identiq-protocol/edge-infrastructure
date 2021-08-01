# AWS Edge infrastructure

This Terraform module creates Identiq's edge infrastructure on which the edge application will deployed on.
The infstructarue consists of the following components:
 * [EKS](https://aws.amazon.com/eks) cluster
 * MySQL (Containerized or RDS)
 * Redis (Containerized or Elasticache)

## Requirements

* [AWS Terraform provider](https://www.terraform.io/docs/providers/aws/)
* [kubernetes terraform provider](https://www.terraform.io/docs/providers/kubernetes)

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_http"></a> [http](#provider\_http) | n/a |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_my-cluster"></a> [my-cluster](#module\_my-cluster) | terraform-aws-modules/eks/aws | 17.1.0 |
| <a name="module_rds"></a> [rds](#module\_rds) | terraform-aws-modules/rds/aws | 2.35.0 |
| <a name="module_redis"></a> [redis](#module\_redis) | git::https://github.com/cloudposse/terraform-aws-elasticache-redis.git | 0.40.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 3.2.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.lb_controller_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [kubernetes_secret.edge_db_secret](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.edge_redis_secret](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_service.edge_db_service](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [kubernetes_service.edge_redis_service](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [random_password.rds_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [http_http.iam_policy](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ec_apply_immediately"></a> [ec\_apply\_immediately](#input\_ec\_apply\_immediately) | Elastic cache apply changes immediately | `bool` | `true` | no |
| <a name="input_ec_at_rest_encryption_enabled"></a> [ec\_at\_rest\_encryption\_enabled](#input\_ec\_at\_rest\_encryption\_enabled) | Elastic cache enable encryption at rest | `bool` | `true` | no |
| <a name="input_ec_automatic_failover_enabled"></a> [ec\_automatic\_failover\_enabled](#input\_ec\_automatic\_failover\_enabled) | Elastic cache automatic failover (Not available for T1/T2 instances) | `bool` | `false` | no |
| <a name="input_ec_cluster_mode_enabled"></a> [ec\_cluster\_mode\_enabled](#input\_ec\_cluster\_mode\_enabled) | Elastic cache flag to enable/disable creation of a native redis cluster. `automatic_failover_enabled` must be set to `true`. Only 1 `cluster_mode` block is allowed | `bool` | `false` | no |
| <a name="input_ec_cluster_mode_replicas_per_node_group"></a> [ec\_cluster\_mode\_replicas\_per\_node\_group](#input\_ec\_cluster\_mode\_replicas\_per\_node\_group) | Elastic cache number of replica nodes in each node group. Valid values are 0 to 5. Changing this number will force a new resource | `number` | `0` | no |
| <a name="input_ec_cluster_size"></a> [ec\_cluster\_size](#input\_ec\_cluster\_size) | Elastic cache number of nodes in cluster. *Ignored when `cluster_mode_enabled` == `true`* | `number` | `1` | no |
| <a name="input_ec_engine_version"></a> [ec\_engine\_version](#input\_ec\_engine\_version) | Elastic cache Redis engine version | `string` | `"6.x"` | no |
| <a name="input_ec_family"></a> [ec\_family](#input\_ec\_family) | Elastic cache Redis family | `string` | `"redis6.x"` | no |
| <a name="input_ec_instance_type"></a> [ec\_instance\_type](#input\_ec\_instance\_type) | Elastic cache instance type | `string` | `"cache.r5.2xlarge"` | no |
| <a name="input_ec_parameter"></a> [ec\_parameter](#input\_ec\_parameter) | A list of Redis parameters to apply. Note that parameters may differ from one Redis family to another | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | <pre>[<br>  {<br>    "name": "reserved-memory-percent",<br>    "value": "10"<br>  }<br>]</pre> | no |
| <a name="input_ec_transit_encryption_enabled"></a> [ec\_transit\_encryption\_enabled](#input\_ec\_transit\_encryption\_enabled) | Whether to enable Elastic cache encryption in transit. If this is enabled, use the [following guide](https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/in-transit-encryption.html#connect-tls) to access redis | `bool` | `false` | no |
| <a name="input_eks_additional_policies"></a> [eks\_additional\_policies](#input\_eks\_additional\_policies) | EKS additional policies to be added to workers | `list` | `[]` | no |
| <a name="input_eks_base_asg_min_size"></a> [eks\_base\_asg\_min\_size](#input\_eks\_base\_asg\_min\_size) | EKS base worker group minimimum number of instances (asg\_min\_size) | `number` | `0` | no |
| <a name="input_eks_base_instance_count"></a> [eks\_base\_instance\_count](#input\_eks\_base\_instance\_count) | EKS base worker group instance count which sets on\_demand\_base\_capacity, asg\_min\_size, asg\_desired\_capacity | `number` | `1` | no |
| <a name="input_eks_base_instance_type"></a> [eks\_base\_instance\_type](#input\_eks\_base\_instance\_type) | EKS base worker group instance type | `string` | `"c5.2xlarge"` | no |
| <a name="input_eks_cache_asg_min_size"></a> [eks\_cache\_asg\_min\_size](#input\_eks\_cache\_asg\_min\_size) | EKS cache worker group minimimum number of instances (asg\_min\_size) | `number` | `0` | no |
| <a name="input_eks_cache_instance_count"></a> [eks\_cache\_instance\_count](#input\_eks\_cache\_instance\_count) | EKS cache worker group instance count which sets on\_demand\_base\_capacity, asg\_min\_size, asg\_desired\_capacity | `number` | `1` | no |
| <a name="input_eks_cache_instance_type"></a> [eks\_cache\_instance\_type](#input\_eks\_cache\_instance\_type) | EKS cache worker group instance type | `string` | `"r5.2xlarge"` | no |
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | Name of EKS cluster | `any` | n/a | yes |
| <a name="input_eks_cluster_version"></a> [eks\_cluster\_version](#input\_eks\_cluster\_version) | Kubernetes version to use for the EKS cluster | `string` | `"1.19"` | no |
| <a name="input_eks_db_asg_min_size"></a> [eks\_db\_asg\_min\_size](#input\_eks\_db\_asg\_min\_size) | EKS database worker group minimimum number of instances (asg\_min\_size) | `number` | `0` | no |
| <a name="input_eks_db_instance_count"></a> [eks\_db\_instance\_count](#input\_eks\_db\_instance\_count) | EKS database worker group instance count which sets on\_demand\_base\_capacity, asg\_min\_size, asg\_desired\_capacity | `number` | `1` | no |
| <a name="input_eks_db_instance_type"></a> [eks\_db\_instance\_type](#input\_eks\_db\_instance\_type) | EKS database worker group instance type | `string` | `"m5.large"` | no |
| <a name="input_eks_dynamic_asg_min_size"></a> [eks\_dynamic\_asg\_min\_size](#input\_eks\_dynamic\_asg\_min\_size) | EKS dynamic worker group minimimum number of instances (asg\_min\_size) | `number` | `0` | no |
| <a name="input_eks_dynamic_instance_count"></a> [eks\_dynamic\_instance\_count](#input\_eks\_dynamic\_instance\_count) | EKS dynamic worker group instance count which sets on\_demand\_base\_capacity, asg\_min\_size, asg\_desired\_capacity | `number` | `4` | no |
| <a name="input_eks_dynamic_instance_type"></a> [eks\_dynamic\_instance\_type](#input\_eks\_dynamic\_instance\_type) | EKS dynamic worker group instance type | `string` | `"c5.4xlarge"` | no |
| <a name="input_eks_map_roles"></a> [eks\_map\_roles](#input\_eks\_map\_roles) | EKS additional IAM roles to add to the aws-auth configmap | `list` | `[]` | no |
| <a name="input_eks_map_users"></a> [eks\_map\_users](#input\_eks\_map\_users) | EKS additional IAM users to add to the aws-auth configmap | `list` | `[]` | no |
| <a name="input_eks_wait_for_cluster_timeout"></a> [eks\_wait\_for\_cluster\_timeout](#input\_eks\_wait\_for\_cluster\_timeout) | A timeout (in seconds) to wait for EKS cluster to be available | `number` | `300` | no |
| <a name="input_external_db"></a> [external\_db](#input\_external\_db) | Database will be installed outside of EKS cluster (RDS) | `bool` | `false` | no |
| <a name="input_external_db_name"></a> [external\_db\_name](#input\_external\_db\_name) | External db name (if enabled) | `string` | `"edge"` | no |
| <a name="input_external_redis"></a> [external\_redis](#input\_external\_redis) | Redis will be installed outside of EKS cluster (Elasticache) | `bool` | `false` | no |
| <a name="input_external_redis_name"></a> [external\_redis\_name](#input\_external\_redis\_name) | External redis name (if enabled) | `string` | `"edge"` | no |
| <a name="input_rds_allocated_storage"></a> [rds\_allocated\_storage](#input\_rds\_allocated\_storage) | n/a | `number` | `1000` | no |
| <a name="input_rds_allow_major_version_upgrade"></a> [rds\_allow\_major\_version\_upgrade](#input\_rds\_allow\_major\_version\_upgrade) | n/a | `bool` | `false` | no |
| <a name="input_rds_apply_immediately"></a> [rds\_apply\_immediately](#input\_rds\_apply\_immediately) | n/a | `string` | `"true"` | no |
| <a name="input_rds_backup_retention_period"></a> [rds\_backup\_retention\_period](#input\_rds\_backup\_retention\_period) | n/a | `number` | `14` | no |
| <a name="input_rds_backup_window"></a> [rds\_backup\_window](#input\_rds\_backup\_window) | n/a | `string` | `"03:00-06:00"` | no |
| <a name="input_rds_create_monitoring_role"></a> [rds\_create\_monitoring\_role](#input\_rds\_create\_monitoring\_role) | n/a | `string` | `"true"` | no |
| <a name="input_rds_db_name"></a> [rds\_db\_name](#input\_rds\_db\_name) | n/a | `string` | `"edge"` | no |
| <a name="input_rds_deletion_protection"></a> [rds\_deletion\_protection](#input\_rds\_deletion\_protection) | n/a | `bool` | `false` | no |
| <a name="input_rds_engine"></a> [rds\_engine](#input\_rds\_engine) | n/a | `string` | `"postgres"` | no |
| <a name="input_rds_engine_version"></a> [rds\_engine\_version](#input\_rds\_engine\_version) | n/a | `string` | `"13.3"` | no |
| <a name="input_rds_instance_class"></a> [rds\_instance\_class](#input\_rds\_instance\_class) | n/a | `string` | `"db.m5.large"` | no |
| <a name="input_rds_iops"></a> [rds\_iops](#input\_rds\_iops) | n/a | `number` | `3000` | no |
| <a name="input_rds_maintenance_window"></a> [rds\_maintenance\_window](#input\_rds\_maintenance\_window) | n/a | `string` | `"Sun:00:00-Sun:03:00"` | no |
| <a name="input_rds_monitoring_interval"></a> [rds\_monitoring\_interval](#input\_rds\_monitoring\_interval) | n/a | `number` | `60` | no |
| <a name="input_rds_multi_az"></a> [rds\_multi\_az](#input\_rds\_multi\_az) | n/a | `bool` | `true` | no |
| <a name="input_rds_parameter_group_family"></a> [rds\_parameter\_group\_family](#input\_rds\_parameter\_group\_family) | n/a | `string` | `"postgres13"` | no |
| <a name="input_rds_parameters"></a> [rds\_parameters](#input\_rds\_parameters) | A list of DB parameters (map) to apply | `list(map(string))` | <pre>[<br>  {<br>    "apply_method": "pending-reboot",<br>    "name": "maintenance_work_mem",<br>    "value": "4194304"<br>  },<br>  {<br>    "apply_method": "pending-reboot",<br>    "name": "checkpoint_timeout",<br>    "value": "1800"<br>  },<br>  {<br>    "apply_method": "pending-reboot",<br>    "name": "max_wal_size",<br>    "value": "4096"<br>  },<br>  {<br>    "apply_method": "pending-reboot",<br>    "name": "synchronous_commit",<br>    "value": "off"<br>  },<br>  {<br>    "apply_method": "pending-reboot",<br>    "name": "wal_buffers",<br>    "value": "8192"<br>  },<br>  {<br>    "apply_method": "pending-reboot",<br>    "name": "enable_hashagg",<br>    "value": "1"<br>  },<br>  {<br>    "apply_method": "pending-reboot",<br>    "name": "hash_mem_multiplier",<br>    "value": "2.0"<br>  }<br>]</pre> | no |
| <a name="input_rds_performance_insights_enabled"></a> [rds\_performance\_insights\_enabled](#input\_rds\_performance\_insights\_enabled) | n/a | `bool` | `true` | no |
| <a name="input_rds_performance_insights_retention_period"></a> [rds\_performance\_insights\_retention\_period](#input\_rds\_performance\_insights\_retention\_period) | n/a | `number` | `7` | no |
| <a name="input_rds_skip_final_snapshot"></a> [rds\_skip\_final\_snapshot](#input\_rds\_skip\_final\_snapshot) | n/a | `bool` | `true` | no |
| <a name="input_rds_storage_encrypted"></a> [rds\_storage\_encrypted](#input\_rds\_storage\_encrypted) | n/a | `bool` | `true` | no |
| <a name="input_rds_username"></a> [rds\_username](#input\_rds\_username) | n/a | `string` | `"edge"` | no |
| <a name="input_region"></a> [region](#input\_region) | region | `any` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map` | <pre>{<br>  "Application": "IdentiqEdge",<br>  "Owner": "Identiq"<br>}</pre> | no |
| <a name="input_vpc_cidrsubnet"></a> [vpc\_cidrsubnet](#input\_vpc\_cidrsubnet) | The CIDR block for the VPC | `string` | `"10.0.0.0/16"` | no |
| <a name="input_vpc_enable_dns_hostnames"></a> [vpc\_enable\_dns\_hostnames](#input\_vpc\_enable\_dns\_hostnames) | Should be true to enable DNS hostnames in the Default VPC | `bool` | `true` | no |
| <a name="input_vpc_enable_dns_support"></a> [vpc\_enable\_dns\_support](#input\_vpc\_enable\_dns\_support) | Should be true to enable DNS support in the Default VPC | `bool` | `true` | no |
| <a name="input_vpc_enable_nat_gateway"></a> [vpc\_enable\_nat\_gateway](#input\_vpc\_enable\_nat\_gateway) | Should be true if you want to provision NAT Gateways for each of your private networks | `bool` | `true` | no |
| <a name="input_vpc_enable_vpn_gateway"></a> [vpc\_enable\_vpn\_gateway](#input\_vpc\_enable\_vpn\_gateway) | Should be true if you want to create a new VPN Gateway resource and attach it to the VPC | `bool` | `false` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Name to be used on all the resources as identifier | `string` | `"identiq-vpc"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_connect"></a> [connect](#output\_connect) | n/a |
| <a name="output_nat_ips"></a> [nat\_ips](#output\_nat\_ips) | n/a |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | n/a |