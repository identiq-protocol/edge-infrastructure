module "redis" {
  count                                = var.external_redis ? 1 : 0
  source                               = "cloudposse/elasticache-redis/aws"
  version                              = "0.52.0"
  availability_zones                   = var.ec_cluster_mode_enabled && var.ec_cluster_mode_creation_fix_enabled ? [] : data.aws_availability_zones.available.names
  name                                 = var.external_redis_name
  zone_id                              = ""
  vpc_id                               = local.ec_vpc_id
  allow_all_egress                     = var.ec_allow_all_egress
  allowed_security_group_ids           = [module.eks.cluster_primary_security_group_id]
  data_tiering_enabled                 = var.ec_data_tiering_enabled
  subnets                              = local.ec_private_subnets
  cluster_mode_enabled                 = var.ec_cluster_mode_enabled
  cluster_mode_num_node_groups         = var.ec_cluster_mode_num_node_groups
  cluster_mode_replicas_per_node_group = var.ec_cluster_mode_replicas_per_node_group
  cluster_size                         = var.ec_cluster_size
  security_group_description           = "Managed by Terraform"
  instance_type                        = var.ec_instance_type
  apply_immediately                    = var.ec_apply_immediately
  automatic_failover_enabled           = var.ec_automatic_failover_enabled
  engine_version                       = var.ec_engine_version
  family                               = var.ec_family
  at_rest_encryption_enabled           = var.ec_at_rest_encryption_enabled
  transit_encryption_enabled           = var.ec_transit_encryption_enabled
  parameter                            = var.ec_parameter
  tags                                 = merge(var.tags, var.default_tags)
  snapshot_name                        = var.ec_snapshot_name
  snapshot_window                      = var.ec_snapshot_window
  snapshot_retention_limit             = var.ec_snapshot_retention_limit
  log_delivery_configuration = var.ec_log_delivery_configuration
}

resource "kubernetes_secret" "edge_redis_secret" {
  count = var.external_redis ? 1 : 0
  metadata {
    name = "edge-identities-redis"
  }
  data = {
    redis-password = ""
  }
  depends_on = [
    module.eks,
    module.redis[0]
  ]
}

resource "aws_appautoscaling_target" "autoscaling_target" {
  count              = var.ec_cluster_mode_enabled && var.external_redis && var.ec_enable_app_autoscaling ? 1 : 0
  max_capacity       = var.ec_appautoscaling_target_max_capacity
  min_capacity       = var.ec_appautoscaling_target_min_capacity
  resource_id        = "replication-group/${var.external_redis_name}"
  scalable_dimension = var.ec_appautoscaling_scalable_dimension
  service_namespace  = var.ec_appautoscaling_service_namespace
}

resource "aws_appautoscaling_policy" "autoscaling_policy" {
  count              = var.ec_cluster_mode_enabled && var.external_redis && var.ec_enable_app_autoscaling ? 1 : 0
  policy_type        = var.ec_appautoscaling_policy_type
  name               = var.external_redis_name
  resource_id        = aws_appautoscaling_target.autoscaling_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.autoscaling_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.autoscaling_target[0].service_namespace
  target_tracking_scaling_policy_configuration {
    target_value       = var.ec_appautoscaling_target_value
    scale_in_cooldown  = var.ec_appautoscaling_scale_in_cooldown
    scale_out_cooldown = var.ec_appautoscaling_scale_out_cooldown
    predefined_metric_specification {
      predefined_metric_type = var.ec_appautoscaling_predefined_metric_type
    }
  }
}

resource "kubernetes_service" "edge_redis_service" {
  count = var.external_redis ? 1 : 0
  metadata {
    name = "edge-identities-redis-master"
    annotations = {
      "ad.datadoghq.com/service.check_names"  = "[\"redisdb\"]"
      "ad.datadoghq.com/service.init_configs" = "[{}]"
      "ad.datadoghq.com/service.instances"    = "[{\"host\":\"edge-identities-redis-master\",\"port\":\"6379\"}]"
    }
  }
  spec {
    type          = "ExternalName"
    external_name = module.redis[0].endpoint
  }
  depends_on = [
    module.eks,
    module.redis[0]
  ]
}

locals {
  ec_private_subnets = var.external_vpc ? var.ec_private_subnets : (var.ec_subnet_single_az ? [module.vpc[0].private_subnets[0]] : module.vpc[0].private_subnets)
  ec_vpc_id          = var.external_vpc ? var.ec_vpc_id : module.vpc[0].vpc_id
}
