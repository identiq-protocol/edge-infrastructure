module "redis" {
  count              = var.external_redis ? 1 : 0
  source             = "git::https://github.com/cloudposse/terraform-aws-elasticache-redis.git?ref=0.40.0"
  availability_zones = data.aws_availability_zones.available.names
  name               = var.external_redis_name
  zone_id            = ""
  vpc_id             = local.ec_vpc_id
  security_group_rules = [
    {
      type                     = "egress"
      from_port                = 0
      to_port                  = 65535
      protocol                 = "-1"
      cidr_blocks              = ["0.0.0.0/0"]
      source_security_group_id = null
      description              = "Allow all outbound traffic"
    },
    {
      type                     = "ingress"
      from_port                = 0
      to_port                  = 65535
      protocol                 = "-1"
      cidr_blocks              = []
      source_security_group_id = module.eks.worker_security_group_id
      description              = "Allow all inbound traffic from trusted Security Groups"
    },
  ]
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
}

resource "kubernetes_secret" "edge_redis_secret" {
  count = var.external_redis ? 1 : 0
  metadata {
    name = "edge-identities-redis"
    annotations = {
      "ad.datadoghq.com/service.check_names"  = "[\"redisdb\"]"
      "ad.datadoghq.com/service.init_configs" = "[{}]"
      "ad.datadoghq.com/service.instances"    = "[{\"host\":\"%%host%%\",\"port\":\"6379\",\"password\":\"%%env_REDIS_PASSWORD%%\"}]"
    }
  }
  data = {
    redis-password = ""
  }
  depends_on = [
    module.eks,
    module.redis[0]
  ]
}
resource "kubernetes_service" "edge_redis_service" {
  count = var.external_redis ? 1 : 0
  metadata {
    name = "edge-identities-redis-master"
    annotations = {
      "ad.datadoghq.com/service.check_names"  = "[\"redisdb\"]"
      "ad.datadoghq.com/service.init_configs" = "[{}]"
      "ad.datadoghq.com/service.instances"    = "[{\"host\":\"%%host%%\",\"port\":\"6379\",\"password\":\"%%env_REDIS_PASSWORD%%\"}]"
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
  ec_private_subnets = var.external_vpc ? var.ec_private_subnets : module.vpc.private_subnets
  ec_vpc_id          = var.external_vpc ? var.ec_vpc_id : module.vpc.vpc_id
}
