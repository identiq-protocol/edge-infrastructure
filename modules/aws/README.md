<!-- BEGIN_TF_DOCS -->
# AWS Edge infrastructure

This Terraform module creates Identiq's edge infrastructure on which the edge application will deployed on.
The infstructarue consists of the following components:
 * [EKS](https://aws.amazon.com/eks) cluster
 * PostgreSQL (Containerized or RDS)
 * Redis (Containerized or Elasticache)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.17.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.11.0 |
| <a name="requirement_http"></a> [http](#requirement\_http) | 3.4.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.23.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.17.0 |
| <a name="provider_aws.virginia"></a> [aws.virginia](#provider\_aws.virginia) | 5.17.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.11.0 |
| <a name="provider_http"></a> [http](#provider\_http) | 3.4.1 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.23.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cluster_autoscaler_irsa_role"></a> [cluster\_autoscaler\_irsa\_role](#module\_cluster\_autoscaler\_irsa\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | 5.30.0 |
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | 19.21.0 |
| <a name="module_rds"></a> [rds](#module\_rds) | terraform-aws-modules/rds/aws | 6.1.1 |
| <a name="module_rds_sg"></a> [rds\_sg](#module\_rds\_sg) | terraform-aws-modules/security-group/aws | 5.1.0 |
| <a name="module_redis"></a> [redis](#module\_redis) | cloudposse/elasticache-redis/aws | 0.52.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 5.1.2 |

## Resources

| Name | Type |
|------|------|
| [aws_appautoscaling_policy.autoscaling_policy](https://registry.terraform.io/providers/hashicorp/aws/5.17.0/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_target.autoscaling_target](https://registry.terraform.io/providers/hashicorp/aws/5.17.0/docs/resources/appautoscaling_target) | resource |
| [aws_autoscaling_group_tag.asg_tags](https://registry.terraform.io/providers/hashicorp/aws/5.17.0/docs/resources/autoscaling_group_tag) | resource |
| [aws_autoscaling_group_tag.cluster_autoscaler_label_tags](https://registry.terraform.io/providers/hashicorp/aws/5.17.0/docs/resources/autoscaling_group_tag) | resource |
| [aws_iam_policy.lb_controller_policy](https://registry.terraform.io/providers/hashicorp/aws/5.17.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.worker_autoscaling](https://registry.terraform.io/providers/hashicorp/aws/5.17.0/docs/resources/iam_policy) | resource |
| [aws_security_group.pinky_ingress](https://registry.terraform.io/providers/hashicorp/aws/5.17.0/docs/resources/security_group) | resource |
| [aws_security_group_rule.pink_ingress](https://registry.terraform.io/providers/hashicorp/aws/5.17.0/docs/resources/security_group_rule) | resource |
| [aws_vpc_endpoint.ep](https://registry.terraform.io/providers/hashicorp/aws/5.17.0/docs/resources/vpc_endpoint) | resource |
| [helm_release.cluster-autoscaler](https://registry.terraform.io/providers/hashicorp/helm/2.11.0/docs/resources/release) | resource |
| [kubernetes_annotations.gp2](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/annotations) | resource |
| [kubernetes_config_map.version](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/config_map) | resource |
| [kubernetes_secret.edge_db_secret](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/secret) | resource |
| [kubernetes_secret.edge_redis_secret](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/secret) | resource |
| [kubernetes_service.edge_db_service](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/service) | resource |
| [kubernetes_service.edge_redis_service](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/service) | resource |
| [kubernetes_storage_class.ssd](https://registry.terraform.io/providers/hashicorp/kubernetes/2.23.0/docs/resources/storage_class) | resource |
| [random_password.rds_password](https://registry.terraform.io/providers/hashicorp/random/3.6.0/docs/resources/password) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/5.17.0/docs/data-sources/availability_zones) | data source |
| [aws_ecrpublic_authorization_token.token](https://registry.terraform.io/providers/hashicorp/aws/5.17.0/docs/data-sources/ecrpublic_authorization_token) | data source |
| [aws_iam_policy_document.worker_autoscaling](https://registry.terraform.io/providers/hashicorp/aws/5.17.0/docs/data-sources/iam_policy_document) | data source |
| [http_http.iam_policy](https://registry.terraform.io/providers/hashicorp/http/3.4.1/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_autoscaler_enabled"></a> [cluster\_autoscaler\_enabled](#input\_cluster\_autoscaler\_enabled) | Enable cluster autoscaler | `bool` | `false` | no |
| <a name="input_cluster_autoscaler_helm_chart_version"></a> [cluster\_autoscaler\_helm\_chart\_version](#input\_cluster\_autoscaler\_helm\_chart\_version) | Cluster autoscaler helm chart version | `string` | `"9.36.0"` | no |
| <a name="input_cluster_autoscaler_image_tag"></a> [cluster\_autoscaler\_image\_tag](#input\_cluster\_autoscaler\_image\_tag) | Cluster autoscaler image tag | `string` | `"v1.28.2"` | no |
| <a name="input_cluster_autoscaler_namespace"></a> [cluster\_autoscaler\_namespace](#input\_cluster\_autoscaler\_namespace) | Namespace to deploy cluster autoscaler | `string` | `"default"` | no |
| <a name="input_cluster_autoscaler_verbosity_level"></a> [cluster\_autoscaler\_verbosity\_level](#input\_cluster\_autoscaler\_verbosity\_level) | Verbosity level | `string` | `"0"` | no |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | Default tags applied on all resources. If you wish to add tags DO NOT change this variable, instead change `tags` variable | `map(string)` | <pre>{<br>  "Terraform": "true"<br>}</pre> | no |
| <a name="input_ec_allow_all_egress"></a> [ec\_allow\_all\_egress](#input\_ec\_allow\_all\_egress) | If `true`, the created security group for Elasticache will allow egress on all ports and protocols to all IP address.<br>If this is false and no egress rules are otherwise specified, then no egress will be allowed.<br>Defaults to `true` unless the deprecated `egress_cidr_blocks` is provided and is not `["0.0.0.0/0"]`, in which case defaults to `false`. | `bool` | `true` | no |
| <a name="input_ec_appautoscaling_policy_type"></a> [ec\_appautoscaling\_policy\_type](#input\_ec\_appautoscaling\_policy\_type) | The policy type. Valid values are StepScaling and TargetTrackingScaling. Defaults to StepScaling. Certain services only support only one policy type. | `string` | `"TargetTrackingScaling"` | no |
| <a name="input_ec_appautoscaling_predefined_metric_type"></a> [ec\_appautoscaling\_predefined\_metric\_type](#input\_ec\_appautoscaling\_predefined\_metric\_type) | The metric type. | `string` | `"ElastiCacheDatabaseMemoryUsageCountedForEvictPercentage"` | no |
| <a name="input_ec_appautoscaling_scalable_dimension"></a> [ec\_appautoscaling\_scalable\_dimension](#input\_ec\_appautoscaling\_scalable\_dimension) | The scalable dimension of the scalable target. | `string` | `"elasticache:replication-group:NodeGroups"` | no |
| <a name="input_ec_appautoscaling_scale_in_cooldown"></a> [ec\_appautoscaling\_scale\_in\_cooldown](#input\_ec\_appautoscaling\_scale\_in\_cooldown) | The amount of time, in seconds, after a scale in activity completes before another scale in activity can start. | `number` | `300` | no |
| <a name="input_ec_appautoscaling_scale_out_cooldown"></a> [ec\_appautoscaling\_scale\_out\_cooldown](#input\_ec\_appautoscaling\_scale\_out\_cooldown) | The amount of time, in seconds, after a scale out activity completes before another scale out activity can start. | `number` | `300` | no |
| <a name="input_ec_appautoscaling_service_namespace"></a> [ec\_appautoscaling\_service\_namespace](#input\_ec\_appautoscaling\_service\_namespace) | The AWS service namespace of the scalable target. | `string` | `"elasticache"` | no |
| <a name="input_ec_appautoscaling_target_max_capacity"></a> [ec\_appautoscaling\_target\_max\_capacity](#input\_ec\_appautoscaling\_target\_max\_capacity) | The max capacity of the scalable target. | `number` | `100` | no |
| <a name="input_ec_appautoscaling_target_min_capacity"></a> [ec\_appautoscaling\_target\_min\_capacity](#input\_ec\_appautoscaling\_target\_min\_capacity) | The min capacity of the scalable target. | `number` | `3` | no |
| <a name="input_ec_appautoscaling_target_value"></a> [ec\_appautoscaling\_target\_value](#input\_ec\_appautoscaling\_target\_value) | The target value for the metric. | `number` | `80` | no |
| <a name="input_ec_apply_immediately"></a> [ec\_apply\_immediately](#input\_ec\_apply\_immediately) | Elastic cache apply changes immediately | `bool` | `true` | no |
| <a name="input_ec_at_rest_encryption_enabled"></a> [ec\_at\_rest\_encryption\_enabled](#input\_ec\_at\_rest\_encryption\_enabled) | Elastic cache enable encryption at rest | `bool` | `true` | no |
| <a name="input_ec_automatic_failover_enabled"></a> [ec\_automatic\_failover\_enabled](#input\_ec\_automatic\_failover\_enabled) | Elastic cache automatic failover (Not available for T1/T2 instances) | `bool` | `false` | no |
| <a name="input_ec_cluster_mode_creation_fix_enabled"></a> [ec\_cluster\_mode\_creation\_fix\_enabled](#input\_ec\_cluster\_mode\_creation\_fix\_enabled) | Elastic cache flag to enable/disable the fix that pass avilability\_zones [] and allow to create new EC cluster | `bool` | `false` | no |
| <a name="input_ec_cluster_mode_enabled"></a> [ec\_cluster\_mode\_enabled](#input\_ec\_cluster\_mode\_enabled) | Elastic cache flag to enable/disable creation of a native redis cluster. `automatic_failover_enabled` must be set to `true`. Only 1 `cluster_mode` block is allowed | `bool` | `false` | no |
| <a name="input_ec_cluster_mode_num_node_groups"></a> [ec\_cluster\_mode\_num\_node\_groups](#input\_ec\_cluster\_mode\_num\_node\_groups) | Number of node groups (shards) for this Redis replication group. Changing this number will trigger an online resizing operation before other settings modifications | `number` | `0` | no |
| <a name="input_ec_cluster_mode_replicas_per_node_group"></a> [ec\_cluster\_mode\_replicas\_per\_node\_group](#input\_ec\_cluster\_mode\_replicas\_per\_node\_group) | Elastic cache number of replica nodes in each node group. Valid values are 0 to 5. Changing this number will force a new resource | `number` | `0` | no |
| <a name="input_ec_cluster_size"></a> [ec\_cluster\_size](#input\_ec\_cluster\_size) | Elastic cache number of nodes in cluster. *Ignored when `cluster_mode_enabled` == `true`* | `number` | `1` | no |
| <a name="input_ec_data_tiering_enabled"></a> [ec\_data\_tiering\_enabled](#input\_ec\_data\_tiering\_enabled) | Enables Elasticache data tiering. Data tiering is only supported for replication groups using the r6gd node type. | `bool` | `false` | no |
| <a name="input_ec_enable_app_autoscaling"></a> [ec\_enable\_app\_autoscaling](#input\_ec\_enable\_app\_autoscaling) | Enable app autoscaling for elasticache | `bool` | `true` | no |
| <a name="input_ec_engine_version"></a> [ec\_engine\_version](#input\_ec\_engine\_version) | Elastic cache Redis engine version | `string` | `"7.0"` | no |
| <a name="input_ec_family"></a> [ec\_family](#input\_ec\_family) | Elastic cache Redis family | `string` | `"redis7"` | no |
| <a name="input_ec_instance_type"></a> [ec\_instance\_type](#input\_ec\_instance\_type) | Elastic cache instance type | `string` | `"cache.r7g.xlarge"` | no |
| <a name="input_ec_log_delivery_configuration"></a> [ec\_log\_delivery\_configuration](#input\_ec\_log\_delivery\_configuration) | The log\_delivery\_configuration block allows the streaming of Redis SLOWLOG or Redis Engine Log to CloudWatch Logs or Kinesis Data Firehose. Max of 2 blocks. | `list(map(any))` | `[]` | no |
| <a name="input_ec_parameter"></a> [ec\_parameter](#input\_ec\_parameter) | A list of Redis parameters to apply. Note that parameters may differ from one Redis family to another | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | <pre>[<br>  {<br>    "name": "reserved-memory-percent",<br>    "value": "10"<br>  }<br>]</pre> | no |
| <a name="input_ec_private_subnets"></a> [ec\_private\_subnets](#input\_ec\_private\_subnets) | Private subnets for elasticache in case external VPC is provided | `list(string)` | `[]` | no |
| <a name="input_ec_snapshot_name"></a> [ec\_snapshot\_name](#input\_ec\_snapshot\_name) | The name of a snapshot from which to restore data into the new node group. Changing the snapshot\_name forces a new resource. | `string` | `null` | no |
| <a name="input_ec_snapshot_retention_limit"></a> [ec\_snapshot\_retention\_limit](#input\_ec\_snapshot\_retention\_limit) | The number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them. | `number` | `3` | no |
| <a name="input_ec_snapshot_window"></a> [ec\_snapshot\_window](#input\_ec\_snapshot\_window) | The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster. | `string` | `"06:30-07:30"` | no |
| <a name="input_ec_subnet_single_az"></a> [ec\_subnet\_single\_az](#input\_ec\_subnet\_single\_az) | Whether to Elastic cache subnet group with single subnet | `bool` | `true` | no |
| <a name="input_ec_transit_encryption_enabled"></a> [ec\_transit\_encryption\_enabled](#input\_ec\_transit\_encryption\_enabled) | Whether to enable Elastic cache encryption in transit. If this is enabled, use the [following guide](https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/in-transit-encryption.html#connect-tls) to access redis | `bool` | `false` | no |
| <a name="input_ec_vpc_id"></a> [ec\_vpc\_id](#input\_ec\_vpc\_id) | VPC ID in case we external VPC is provided | `string` | `""` | no |
| <a name="input_eks_additional_policies"></a> [eks\_additional\_policies](#input\_eks\_additional\_policies) | EKS additional policies to be added to workers | `list(string)` | `[]` | no |
| <a name="input_eks_base_ami_type"></a> [eks\_base\_ami\_type](#input\_eks\_base\_ami\_type) | Type of Amazon Machine Image (AMI) associated with the EKS Node Group. Valid values are `AL2_x86_64`, `AL2_x86_64_GPU`, `AL2_ARM_64`, `CUSTOM`, `BOTTLEROCKET_ARM_64`, `BOTTLEROCKET_x86_64` | `string` | `"BOTTLEROCKET_x86_64"` | no |
| <a name="input_eks_base_capacity_type"></a> [eks\_base\_capacity\_type](#input\_eks\_base\_capacity\_type) | Type of capacity associated with the EKS Node Group. Valid values: `ON_DEMAND`, `SPOT` | `string` | `"ON_DEMAND"` | no |
| <a name="input_eks_base_desired_count"></a> [eks\_base\_desired\_count](#input\_eks\_base\_desired\_count) | EKS master node group instance desired count | `number` | `1` | no |
| <a name="input_eks_base_disk_size"></a> [eks\_base\_disk\_size](#input\_eks\_base\_disk\_size) | Disk size in GiB for nodes. Defaults to `100`. Only valid when `use_custom_launch_template` = `false` | `number` | `100` | no |
| <a name="input_eks_base_instance_types"></a> [eks\_base\_instance\_types](#input\_eks\_base\_instance\_types) | EKS base worker group instance type | `list(string)` | <pre>[<br>  "c6a.2xlarge",<br>  "c6i.2xlarge"<br>]</pre> | no |
| <a name="input_eks_base_max_size"></a> [eks\_base\_max\_size](#input\_eks\_base\_max\_size) | EKS master node group max number of instances | `number` | `1` | no |
| <a name="input_eks_base_min_size"></a> [eks\_base\_min\_size](#input\_eks\_base\_min\_size) | EKS master worker group minimimum number of instances | `number` | `0` | no |
| <a name="input_eks_base_platform"></a> [eks\_base\_platform](#input\_eks\_base\_platform) | Identifies if the OS platform is `bottlerocket` or `linux` based; `windows` is not supported | `string` | `"bottlerocket"` | no |
| <a name="input_eks_cache_ami_type"></a> [eks\_cache\_ami\_type](#input\_eks\_cache\_ami\_type) | Type of Amazon Machine Image (AMI) associated with the EKS Node Group. Valid values are `AL2_x86_64`, `AL2_x86_64_GPU`, `AL2_ARM_64`, `CUSTOM`, `BOTTLEROCKET_ARM_64`, `BOTTLEROCKET_x86_64` | `string` | `"BOTTLEROCKET_x86_64"` | no |
| <a name="input_eks_cache_capacity_type"></a> [eks\_cache\_capacity\_type](#input\_eks\_cache\_capacity\_type) | Type of capacity associated with the EKS Node Group. Valid values: `ON_DEMAND`, `SPOT` | `string` | `"ON_DEMAND"` | no |
| <a name="input_eks_cache_desired_count"></a> [eks\_cache\_desired\_count](#input\_eks\_cache\_desired\_count) | EKS master node group instance desired count | `number` | `1` | no |
| <a name="input_eks_cache_disk_size"></a> [eks\_cache\_disk\_size](#input\_eks\_cache\_disk\_size) | Disk size in GiB for nodes. Defaults to `100`. Only valid when `use_custom_launch_template` = `false` | `number` | `100` | no |
| <a name="input_eks_cache_instance_types"></a> [eks\_cache\_instance\_types](#input\_eks\_cache\_instance\_types) | EKS cache worker group instance type | `list(string)` | <pre>[<br>  "r6a.2xlarge",<br>  "r6i.2xlarge"<br>]</pre> | no |
| <a name="input_eks_cache_max_size"></a> [eks\_cache\_max\_size](#input\_eks\_cache\_max\_size) | EKS master node group max number of instances | `number` | `1` | no |
| <a name="input_eks_cache_min_size"></a> [eks\_cache\_min\_size](#input\_eks\_cache\_min\_size) | EKS master worker group minimum number of instances | `number` | `0` | no |
| <a name="input_eks_cache_platform"></a> [eks\_cache\_platform](#input\_eks\_cache\_platform) | Identifies if the OS platform is `bottlerocket` or `linux` based; `windows` is not supported | `string` | `"bottlerocket"` | no |
| <a name="input_eks_cloudwatch_log_group_retention_in_days"></a> [eks\_cloudwatch\_log\_group\_retention\_in\_days](#input\_eks\_cloudwatch\_log\_group\_retention\_in\_days) | Number of days to retain log events. Default retention - 7 days | `number` | `7` | no |
| <a name="input_eks_cluster_create_endpoint_private_access_sg_rule"></a> [eks\_cluster\_create\_endpoint\_private\_access\_sg\_rule](#input\_eks\_cluster\_create\_endpoint\_private\_access\_sg\_rule) | Whether to create security group rules for the access to the Amazon EKS private API server endpoint. When is `true`, `cluster_endpoint_private_access_cidrs` must be setted. | `bool` | `false` | no |
| <a name="input_eks_cluster_enabled_log_types"></a> [eks\_cluster\_enabled\_log\_types](#input\_eks\_cluster\_enabled\_log\_types) | A list of the desired control plane logs to enable. For more information, see Amazon EKS Control Plane Logging documentation (https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html) | `list(string)` | `[]` | no |
| <a name="input_eks_cluster_encryption_config"></a> [eks\_cluster\_encryption\_config](#input\_eks\_cluster\_encryption\_config) | Configuration block with encryption configuration for the cluster. To disable secret encryption, set this value to `{}` | `any` | `{}` | no |
| <a name="input_eks_cluster_endpoint_private_access"></a> [eks\_cluster\_endpoint\_private\_access](#input\_eks\_cluster\_endpoint\_private\_access) | Indicates whether or not the Amazon EKS private API server endpoint is enabled | `bool` | `true` | no |
| <a name="input_eks_cluster_endpoint_public_access"></a> [eks\_cluster\_endpoint\_public\_access](#input\_eks\_cluster\_endpoint\_public\_access) | Indicates whether or not the Amazon EKS public API server endpoint is enabled | `bool` | `true` | no |
| <a name="input_eks_cluster_endpoint_public_access_cidrs"></a> [eks\_cluster\_endpoint\_public\_access\_cidrs](#input\_eks\_cluster\_endpoint\_public\_access\_cidrs) | List of CIDR blocks which can access the Amazon EKS public API server endpoint | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | Name of EKS cluster | `string` | `"edge"` | no |
| <a name="input_eks_cluster_version"></a> [eks\_cluster\_version](#input\_eks\_cluster\_version) | Kubernetes version to use for the EKS cluster | `string` | `"1.28"` | no |
| <a name="input_eks_db_ami_type"></a> [eks\_db\_ami\_type](#input\_eks\_db\_ami\_type) | Type of Amazon Machine Image (AMI) associated with the EKS Node Group. Valid values are `AL2_x86_64`, `AL2_x86_64_GPU`, `AL2_ARM_64`, `CUSTOM`, `BOTTLEROCKET_ARM_64`, `BOTTLEROCKET_x86_64` | `string` | `"BOTTLEROCKET_x86_64"` | no |
| <a name="input_eks_db_capacity_type"></a> [eks\_db\_capacity\_type](#input\_eks\_db\_capacity\_type) | Type of capacity associated with the EKS Node Group. Valid values: `ON_DEMAND`, `SPOT` | `string` | `"ON_DEMAND"` | no |
| <a name="input_eks_db_desired_count"></a> [eks\_db\_desired\_count](#input\_eks\_db\_desired\_count) | EKS db node group instance desired count | `number` | `1` | no |
| <a name="input_eks_db_disk_size"></a> [eks\_db\_disk\_size](#input\_eks\_db\_disk\_size) | Disk size in GiB for nodes. Defaults to `100`. Only valid when `use_custom_launch_template` = `false` | `number` | `100` | no |
| <a name="input_eks_db_instance_types"></a> [eks\_db\_instance\_types](#input\_eks\_db\_instance\_types) | EKS db worker group instance type | `list(string)` | <pre>[<br>  "m6a.xlarge",<br>  "m6i.xlarge"<br>]</pre> | no |
| <a name="input_eks_db_max_size"></a> [eks\_db\_max\_size](#input\_eks\_db\_max\_size) | EKS db node group max number of instances | `number` | `1` | no |
| <a name="input_eks_db_min_size"></a> [eks\_db\_min\_size](#input\_eks\_db\_min\_size) | EKS db worker group minimum number of instances | `number` | `0` | no |
| <a name="input_eks_db_platform"></a> [eks\_db\_platform](#input\_eks\_db\_platform) | Identifies if the OS platform is `bottlerocket` or `linux` based; `windows` is not supported | `string` | `"bottlerocket"` | no |
| <a name="input_eks_dynamic_ami_type"></a> [eks\_dynamic\_ami\_type](#input\_eks\_dynamic\_ami\_type) | Type of Amazon Machine Image (AMI) associated with the EKS Node Group. Valid values are `AL2_x86_64`, `AL2_x86_64_GPU`, `AL2_ARM_64`, `CUSTOM`, `BOTTLEROCKET_ARM_64`, `BOTTLEROCKET_x86_64` | `string` | `"AL2_x86_64"` | no |
| <a name="input_eks_dynamic_capacity_type"></a> [eks\_dynamic\_capacity\_type](#input\_eks\_dynamic\_capacity\_type) | Type of capacity associated with the EKS Node Group. Valid values: `ON_DEMAND`, `SPOT` | `string` | `"ON_DEMAND"` | no |
| <a name="input_eks_dynamic_desired_count"></a> [eks\_dynamic\_desired\_count](#input\_eks\_dynamic\_desired\_count) | EKS dynamic node group instance desired count | `number` | `2` | no |
| <a name="input_eks_dynamic_disk_size"></a> [eks\_dynamic\_disk\_size](#input\_eks\_dynamic\_disk\_size) | Disk size in GiB for nodes. Defaults to `100`. Only valid when `use_custom_launch_template` = `false` | `number` | `100` | no |
| <a name="input_eks_dynamic_instance_types"></a> [eks\_dynamic\_instance\_types](#input\_eks\_dynamic\_instance\_types) | EKS dynamic worker group instance type | `list(string)` | <pre>[<br>  "c6a.2xlarge",<br>  "c6i.2xlarge"<br>]</pre> | no |
| <a name="input_eks_dynamic_max_size"></a> [eks\_dynamic\_max\_size](#input\_eks\_dynamic\_max\_size) | EKS dynamic node group max number of instances | `number` | `20` | no |
| <a name="input_eks_dynamic_min_size"></a> [eks\_dynamic\_min\_size](#input\_eks\_dynamic\_min\_size) | EKS dynamic worker group minimum number of instances | `number` | `0` | no |
| <a name="input_eks_dynamic_platform"></a> [eks\_dynamic\_platform](#input\_eks\_dynamic\_platform) | Identifies if the OS platform is `bottlerocket` or `linux` based; `windows` is not supported | `string` | `"linux"` | no |
| <a name="input_eks_map_roles"></a> [eks\_map\_roles](#input\_eks\_map\_roles) | EKS additional IAM roles to add to the aws-auth configmap | <pre>list(object({<br>    rolearn  = string<br>    username = string<br>    groups   = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_eks_map_users"></a> [eks\_map\_users](#input\_eks\_map\_users) | EKS additional IAM users to add to the aws-auth configmap | <pre>list(object({<br>    userarn  = string<br>    username = string<br>    groups   = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_eks_master_ami_type"></a> [eks\_master\_ami\_type](#input\_eks\_master\_ami\_type) | Type of Amazon Machine Image (AMI) associated with the EKS Node Group. Valid values are `AL2_x86_64`, `AL2_x86_64_GPU`, `AL2_ARM_64`, `CUSTOM`, `BOTTLEROCKET_ARM_64`, `BOTTLEROCKET_x86_64` | `string` | `"BOTTLEROCKET_x86_64"` | no |
| <a name="input_eks_master_capacity_type"></a> [eks\_master\_capacity\_type](#input\_eks\_master\_capacity\_type) | Type of capacity associated with the EKS Node Group. Valid values: `ON_DEMAND`, `SPOT` | `string` | `"ON_DEMAND"` | no |
| <a name="input_eks_master_create"></a> [eks\_master\_create](#input\_eks\_master\_create) | Create EKS master node group | `bool` | `false` | no |
| <a name="input_eks_master_desired_count"></a> [eks\_master\_desired\_count](#input\_eks\_master\_desired\_count) | EKS master node group instance desired count | `number` | `2` | no |
| <a name="input_eks_master_disk_size"></a> [eks\_master\_disk\_size](#input\_eks\_master\_disk\_size) | Disk size in GiB for nodes. Defaults to `100`. Only valid when `use_custom_launch_template` = `false` | `number` | `100` | no |
| <a name="input_eks_master_instance_types"></a> [eks\_master\_instance\_types](#input\_eks\_master\_instance\_types) | EKS master worker group instance type | `list(string)` | <pre>[<br>  "t3.small",<br>  "t3a.small"<br>]</pre> | no |
| <a name="input_eks_master_max_size"></a> [eks\_master\_max\_size](#input\_eks\_master\_max\_size) | EKS master node group max number of instances | `number` | `4` | no |
| <a name="input_eks_master_min_size"></a> [eks\_master\_min\_size](#input\_eks\_master\_min\_size) | EKS master worker group minimimum number of instances | `number` | `0` | no |
| <a name="input_eks_master_platform"></a> [eks\_master\_platform](#input\_eks\_master\_platform) | Identifies if the OS platform is `bottlerocket` or `linux` based; `windows` is not supported | `string` | `"bottlerocket"` | no |
| <a name="input_eks_private_subnets"></a> [eks\_private\_subnets](#input\_eks\_private\_subnets) | Specifies private subnet IDs in case of external VPC | `list(string)` | `[]` | no |
| <a name="input_eks_public_subnets"></a> [eks\_public\_subnets](#input\_eks\_public\_subnets) | Specifies public subnet IDs in case of external VPC | `list(string)` | `[]` | no |
| <a name="input_eks_vpc_id"></a> [eks\_vpc\_id](#input\_eks\_vpc\_id) | Specifies VPC ID in case of external VPC | `string` | `""` | no |
| <a name="input_eks_wait_for_cluster_timeout"></a> [eks\_wait\_for\_cluster\_timeout](#input\_eks\_wait\_for\_cluster\_timeout) | A timeout (in seconds) to wait for EKS cluster to be available | `number` | `300` | no |
| <a name="input_eks_worker_ami_name_filter"></a> [eks\_worker\_ami\_name\_filter](#input\_eks\_worker\_ami\_name\_filter) | Name filter for AWS EKS worker AMI. If not provided, the latest official AMI for the specified 'cluster\_version' is used. | `string` | `""` | no |
| <a name="input_eks_worker_ami_owner_id"></a> [eks\_worker\_ami\_owner\_id](#input\_eks\_worker\_ami\_owner\_id) | The ID of the owner for the AMI to use for the AWS EKS workers. Valid values are an AWS account ID, 'self' (the current account), or an AWS owner alias (e.g. 'amazon', 'aws-marketplace', 'microsoft'). | `string` | `"amazon"` | no |
| <a name="input_external_db"></a> [external\_db](#input\_external\_db) | Database will be installed outside of EKS cluster (RDS) | `bool` | `true` | no |
| <a name="input_external_db_name"></a> [external\_db\_name](#input\_external\_db\_name) | External db name (if enabled) | `string` | `"edge"` | no |
| <a name="input_external_redis"></a> [external\_redis](#input\_external\_redis) | Redis will be installed outside of EKS cluster (Elasticache) | `bool` | `false` | no |
| <a name="input_external_redis_name"></a> [external\_redis\_name](#input\_external\_redis\_name) | External redis name (if enabled) | `string` | `"edge"` | no |
| <a name="input_external_vpc"></a> [external\_vpc](#input\_external\_vpc) | Sepcifies whether we want to use an externally created VPC | `bool` | `false` | no |
| <a name="input_pinky_ingress_rules"></a> [pinky\_ingress\_rules](#input\_pinky\_ingress\_rules) | n/a | <pre>list(object({<br>    from_port   = number<br>    to_port     = number<br>    protocol    = string<br>    type        = string<br>    cidr_blocks = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_rds_allocated_storage"></a> [rds\_allocated\_storage](#input\_rds\_allocated\_storage) | The allocated storage in gigabytes | `string` | `1000` | no |
| <a name="input_rds_allow_major_version_upgrade"></a> [rds\_allow\_major\_version\_upgrade](#input\_rds\_allow\_major\_version\_upgrade) | Indicates that major version upgrades are allowed. Changing this parameter does not result in an outage and the change is asynchronously applied as soon as possible | `bool` | `false` | no |
| <a name="input_rds_apply_immediately"></a> [rds\_apply\_immediately](#input\_rds\_apply\_immediately) | Specifies whether any database modifications are applied immediately, or during the next maintenance window | `bool` | `"true"` | no |
| <a name="input_rds_backup_retention_period"></a> [rds\_backup\_retention\_period](#input\_rds\_backup\_retention\_period) | The days to retain backups for | `number` | `14` | no |
| <a name="input_rds_backup_window"></a> [rds\_backup\_window](#input\_rds\_backup\_window) | The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'. Must not overlap with maintenance\_window | `string` | `"03:00-06:00"` | no |
| <a name="input_rds_ca_cert_identifier"></a> [rds\_ca\_cert\_identifier](#input\_rds\_ca\_cert\_identifier) | Specifies the identifier of the CA certificate for the DB instance | `string` | `"rds-ca-rsa2048-g1"` | no |
| <a name="input_rds_create_monitoring_role"></a> [rds\_create\_monitoring\_role](#input\_rds\_create\_monitoring\_role) | Create IAM role with a defined name that permits RDS to send enhanced monitoring metrics to CloudWatch Logs | `bool` | `true` | no |
| <a name="input_rds_db_name"></a> [rds\_db\_name](#input\_rds\_db\_name) | The DB name to create | `string` | `"edge"` | no |
| <a name="input_rds_deletion_protection"></a> [rds\_deletion\_protection](#input\_rds\_deletion\_protection) | The database can't be deleted when this value is set to true | `bool` | `false` | no |
| <a name="input_rds_engine"></a> [rds\_engine](#input\_rds\_engine) | The database engine to use | `string` | `"postgres"` | no |
| <a name="input_rds_engine_version"></a> [rds\_engine\_version](#input\_rds\_engine\_version) | The engine version to use | `string` | `"13.12"` | no |
| <a name="input_rds_instance_class"></a> [rds\_instance\_class](#input\_rds\_instance\_class) | The instance type of the RDS instance | `string` | `"db.r7g.large"` | no |
| <a name="input_rds_iops"></a> [rds\_iops](#input\_rds\_iops) | The amount of provisioned IOPS. Setting this implies a storage\_type of 'io1' | `number` | `null` | no |
| <a name="input_rds_maintenance_window"></a> [rds\_maintenance\_window](#input\_rds\_maintenance\_window) | The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00' | `string` | `"Sun:00:00-Sun:03:00"` | no |
| <a name="input_rds_manage_master_user_password"></a> [rds\_manage\_master\_user\_password](#input\_rds\_manage\_master\_user\_password) | Set to true to allow RDS to manage the master user password in Secrets Manager | `bool` | `false` | no |
| <a name="input_rds_max_allocated_storage"></a> [rds\_max\_allocated\_storage](#input\_rds\_max\_allocated\_storage) | Max allocated storage | `number` | `0` | no |
| <a name="input_rds_monitoring_interval"></a> [rds\_monitoring\_interval](#input\_rds\_monitoring\_interval) | The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance. To disable collecting Enhanced Monitoring metrics, specify 0. The default is 0. Valid Values: 0, 1, 5, 10, 15, 30, 60 | `number` | `60` | no |
| <a name="input_rds_multi_az"></a> [rds\_multi\_az](#input\_rds\_multi\_az) | Specifies if the RDS instance is multi-AZ | `bool` | `false` | no |
| <a name="input_rds_parameter_group_family"></a> [rds\_parameter\_group\_family](#input\_rds\_parameter\_group\_family) | The engine version to use | `string` | `"postgres13"` | no |
| <a name="input_rds_parameters"></a> [rds\_parameters](#input\_rds\_parameters) | A list of DB parameters (map) to apply | `list(map(string))` | <pre>[<br>  {<br>    "apply_method": "pending-reboot",<br>    "name": "maintenance_work_mem",<br>    "value": "4194304"<br>  },<br>  {<br>    "apply_method": "pending-reboot",<br>    "name": "checkpoint_timeout",<br>    "value": "1800"<br>  },<br>  {<br>    "apply_method": "pending-reboot",<br>    "name": "max_wal_size",<br>    "value": "4096"<br>  },<br>  {<br>    "apply_method": "pending-reboot",<br>    "name": "synchronous_commit",<br>    "value": "off"<br>  },<br>  {<br>    "apply_method": "pending-reboot",<br>    "name": "wal_buffers",<br>    "value": "8192"<br>  },<br>  {<br>    "apply_method": "pending-reboot",<br>    "name": "enable_hashagg",<br>    "value": "1"<br>  },<br>  {<br>    "apply_method": "pending-reboot",<br>    "name": "hash_mem_multiplier",<br>    "value": "2.0"<br>  }<br>]</pre> | no |
| <a name="input_rds_performance_insights_enabled"></a> [rds\_performance\_insights\_enabled](#input\_rds\_performance\_insights\_enabled) | Specifies whether Performance Insights are enabled | `bool` | `true` | no |
| <a name="input_rds_performance_insights_retention_period"></a> [rds\_performance\_insights\_retention\_period](#input\_rds\_performance\_insights\_retention\_period) | The amount of time in days to retain Performance Insights data. Either 7 (7 days) or 731 (2 years). | `number` | `7` | no |
| <a name="input_rds_private_subnets"></a> [rds\_private\_subnets](#input\_rds\_private\_subnets) | Private subnets for RDS in case external VPC is provided | `list(string)` | `[]` | no |
| <a name="input_rds_sg_ingress_cidr_blocks"></a> [rds\_sg\_ingress\_cidr\_blocks](#input\_rds\_sg\_ingress\_cidr\_blocks) | List of IPv4 CIDR ranges to use on all ingress rules | `list(string)` | `[]` | no |
| <a name="input_rds_sg_ingress_ipv6_cidr_blocks"></a> [rds\_sg\_ingress\_ipv6\_cidr\_blocks](#input\_rds\_sg\_ingress\_ipv6\_cidr\_blocks) | List of IPv6 CIDR ranges to use on all ingress rules | `list(string)` | `[]` | no |
| <a name="input_rds_sg_ingress_prefix_list_ids"></a> [rds\_sg\_ingress\_prefix\_list\_ids](#input\_rds\_sg\_ingress\_prefix\_list\_ids) | List of prefix list IDs (for allowing access to VPC endpoints) to use on all ingress rules | `list(string)` | `[]` | no |
| <a name="input_rds_sg_ingress_rules"></a> [rds\_sg\_ingress\_rules](#input\_rds\_sg\_ingress\_rules) | List of ingress rules to create by name | `list(string)` | `[]` | no |
| <a name="input_rds_sg_ingress_with_cidr_blocks"></a> [rds\_sg\_ingress\_with\_cidr\_blocks](#input\_rds\_sg\_ingress\_with\_cidr\_blocks) | List of ingress rules to create where 'cidr\_blocks' is used | `list(map(string))` | `[]` | no |
| <a name="input_rds_sg_ingress_with_ipv6_cidr_blocks"></a> [rds\_sg\_ingress\_with\_ipv6\_cidr\_blocks](#input\_rds\_sg\_ingress\_with\_ipv6\_cidr\_blocks) | List of ingress rules to create where 'ipv6\_cidr\_blocks' is used | `list(map(string))` | `[]` | no |
| <a name="input_rds_sg_ingress_with_self"></a> [rds\_sg\_ingress\_with\_self](#input\_rds\_sg\_ingress\_with\_self) | List of ingress rules to create where 'self' is defined | `list(map(string))` | `[]` | no |
| <a name="input_rds_sg_ingress_with_source_security_group_id"></a> [rds\_sg\_ingress\_with\_source\_security\_group\_id](#input\_rds\_sg\_ingress\_with\_source\_security\_group\_id) | List of ingress rules to create where 'source\_security\_group\_id' is used | `list(map(string))` | `[]` | no |
| <a name="input_rds_skip_final_snapshot"></a> [rds\_skip\_final\_snapshot](#input\_rds\_skip\_final\_snapshot) | Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from final\_snapshot\_identifier | `bool` | `true` | no |
| <a name="input_rds_snapshot_identifier"></a> [rds\_snapshot\_identifier](#input\_rds\_snapshot\_identifier) | Specifies whether or not to create this database from a snapshot. This correlates to the snapshot ID you'd find in the RDS console, e.g: rds:production-2015-06-26-06-05 | `string` | `null` | no |
| <a name="input_rds_storage_encrypted"></a> [rds\_storage\_encrypted](#input\_rds\_storage\_encrypted) | Specifies whether the DB instance is encrypted | `bool` | `true` | no |
| <a name="input_rds_storage_type"></a> [rds\_storage\_type](#input\_rds\_storage\_type) | One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD). The default is 'io1' if iops is specified, 'gp2' if not. | `string` | `"gp3"` | no |
| <a name="input_rds_username"></a> [rds\_username](#input\_rds\_username) | Username for the master DB user | `string` | `"edge"` | no |
| <a name="input_rds_vpc_id"></a> [rds\_vpc\_id](#input\_rds\_vpc\_id) | VPC ID in case we external VPC is provided | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | region | `string` | `"us-east-1"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Any tags the user wishes to add to all resources of the edge | `map(string)` | `{}` | no |
| <a name="input_vpc_cidrsubnet"></a> [vpc\_cidrsubnet](#input\_vpc\_cidrsubnet) | The CIDR block for the VPC | `string` | `"10.0.0.0/16"` | no |
| <a name="input_vpc_enable_dns_hostnames"></a> [vpc\_enable\_dns\_hostnames](#input\_vpc\_enable\_dns\_hostnames) | Should be true to enable DNS hostnames in the Default VPC | `bool` | `true` | no |
| <a name="input_vpc_enable_dns_support"></a> [vpc\_enable\_dns\_support](#input\_vpc\_enable\_dns\_support) | Should be true to enable DNS support in the Default VPC | `bool` | `true` | no |
| <a name="input_vpc_enable_nat_gateway"></a> [vpc\_enable\_nat\_gateway](#input\_vpc\_enable\_nat\_gateway) | Should be true if you want to provision NAT Gateways for each of your private networks | `bool` | `true` | no |
| <a name="input_vpc_enable_vpn_gateway"></a> [vpc\_enable\_vpn\_gateway](#input\_vpc\_enable\_vpn\_gateway) | Should be true if you want to create a new VPN Gateway resource and attach it to the VPC | `bool` | `false` | no |
| <a name="input_vpc_endpoint_service_name"></a> [vpc\_endpoint\_service\_name](#input\_vpc\_endpoint\_service\_name) | Endpoint service name to configure with Identiq endpoint service.<br>    Identiq endpoint service by region: <br>    us-east-1 : com.amazonaws.vpce.us-east-1.vpce-svc-0964eccd96e1f130c<br>    eu-central-1 : com.amazonaws.vpce.eu-central-1.vpce-svc-0ead3a40b72d7e586 | `string` | `""` | no |
| <a name="input_vpc_endpoint_type"></a> [vpc\_endpoint\_type](#input\_vpc\_endpoint\_type) | Endpoint service type to create, default unless otherwise is Interface | `string` | `"Interface"` | no |
| <a name="input_vpc_map_public_ip_on_launch"></a> [vpc\_map\_public\_ip\_on\_launch](#input\_vpc\_map\_public\_ip\_on\_launch) | Specify true to indicate that instances launched into the subnet should be assigned a public IP address. Default is `false` | `bool` | `true` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Name to be used on all the resources as identifier | `string` | `"identiq-vpc"` | no |
| <a name="input_vpc_specific_subnet_newbits"></a> [vpc\_specific\_subnet\_newbits](#input\_vpc\_specific\_subnet\_newbits) | Specifies the edge subnet newbits for calculating the CIDR block | `number` | `4` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_connect"></a> [connect](#output\_connect) | n/a |
| <a name="output_endpoint_address"></a> [endpoint\_address](#output\_endpoint\_address) | n/a |
| <a name="output_nat_ips"></a> [nat\_ips](#output\_nat\_ips) | n/a |
| <a name="output_pinky_ingress_id"></a> [pinky\_ingress\_id](#output\_pinky\_ingress\_id) | n/a |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | n/a |
<!-- END_TF_DOCS -->