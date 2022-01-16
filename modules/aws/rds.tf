resource "random_password" "rds_password" {
  count   = var.external_db ? 1 : 0
  length  = 16
  special = false
}

locals {
  rds_sg_ingress_with_source_security_group_id_default = [
    {
      from_port                = 5432
      to_port                  = 5432
      protocol                 = "tcp"
      description              = "PostgreSQL access from within edge EKS cluster"
      source_security_group_id = module.eks.worker_security_group_id
    }
  ]
}

module "rds_sg" {
  create      = var.external_db ? true : false
  source      = "terraform-aws-modules/security-group/aws"
  version     = "4.8.0"
  name        = "${var.external_db_name}-db-sg"
  description = "Security group for edge rds"
  vpc_id      = local.rds_vpc_id

  ingress_cidr_blocks                   = var.rds_sg_ingress_cidr_blocks
  ingress_ipv6_cidr_blocks              = var.rds_sg_ingress_ipv6_cidr_blocks
  ingress_prefix_list_ids               = var.rds_sg_ingress_prefix_list_ids
  ingress_rules                         = var.rds_sg_ingress_rules
  ingress_with_cidr_blocks              = var.rds_sg_ingress_with_cidr_blocks
  ingress_with_ipv6_cidr_blocks         = var.rds_sg_ingress_with_ipv6_cidr_blocks
  ingress_with_self                     = var.rds_sg_ingress_with_self
  ingress_with_source_security_group_id = concat(var.rds_sg_ingress_with_source_security_group_id, local.rds_sg_ingress_with_source_security_group_id_default)
  tags                                  = merge(var.tags, var.default_tags)
}

module "rds" {
  count                                 = var.external_db ? 1 : 0
  source                                = "terraform-aws-modules/rds/aws"
  version                               = "3.50.0"
  identifier                            = var.external_db_name
  name                                  = var.rds_db_name
  monitoring_role_name                  = "${var.eks_cluster_name}-monitoring"
  create_monitoring_role                = var.rds_create_monitoring_role
  engine                                = var.rds_engine
  engine_version                        = var.rds_engine_version
  family                                = var.rds_parameter_group_family
  instance_class                        = var.rds_instance_class
  allocated_storage                     = var.rds_allocated_storage
  storage_encrypted                     = var.rds_storage_encrypted
  username                              = var.rds_username
  password                              = random_password.rds_password[0].result
  port                                  = var.rds_engine == "mariadb" ? 3306 : 5432
  multi_az                              = var.rds_multi_az
  subnet_ids                            = local.rds_private_subnets
  vpc_security_group_ids                = [module.rds_sg.security_group_id]
  maintenance_window                    = var.rds_maintenance_window
  backup_window                         = var.rds_backup_window
  enabled_cloudwatch_logs_exports       = [var.rds_engine == "mariadb" ? "general" : "postgresql"]
  backup_retention_period               = var.rds_backup_retention_period
  skip_final_snapshot                   = var.rds_skip_final_snapshot
  deletion_protection                   = var.rds_deletion_protection
  performance_insights_enabled          = var.rds_performance_insights_enabled
  performance_insights_retention_period = var.rds_performance_insights_retention_period
  monitoring_interval                   = var.rds_monitoring_interval
  storage_type                          = var.rds_storage_type
  iops                                  = var.rds_iops
  apply_immediately                     = var.rds_apply_immediately
  parameters                            = var.rds_parameters
  allow_major_version_upgrade           = var.rds_allow_major_version_upgrade
  tags                                  = merge(var.tags, var.default_tags)
}

resource "kubernetes_secret" "edge_db_secret" {
  count = var.external_db ? 1 : 0
  metadata {
    name = "edge-${var.rds_engine == "mariadb" ? "mariadb" : "postgresql"}"
  }
  data = {
    "${var.rds_engine == "mariadb" ? "mariadb" : "postgresql"}-password"      = module.rds[0].this_db_instance_password
    "${var.rds_engine == "mariadb" ? "mariadb" : "postgresql"}-root-password" = module.rds[0].this_db_instance_password
  }

  depends_on = [
    module.eks,
    module.rds[0]
  ]
}

resource "kubernetes_service" "edge_db_service" {
  count = var.external_db ? 1 : 0
  metadata {
    name = "edge-${var.rds_engine == "mariadb" ? "mariadb" : "postgresql"}"
    annotations = {
      "ad.datadoghq.com/service.check_names"  = "[\"postgres\"]"
      "ad.datadoghq.com/service.init_configs" = "[{}]"
      "ad.datadoghq.com/service.instances"    = "[{\"host\":\"edge-postgresql\",\"username\":\"edge\",\"password\":\"%%env_PGSQL_PASS%%\",\"ignore_databases\":[],\"collect_activity_metrics\":\"true\",\"collect_default_database\":\"true\",\"dbm\":\"true\",\"query_metrics\":{\"enabled\":\"true\"}}]"
    }
  }

  spec {
    type          = "ExternalName"
    external_name = module.rds[0].this_db_instance_address
  }

  depends_on = [
    module.eks,
    module.rds[0]
  ]
}

locals {
  rds_private_subnets = var.external_vpc ? var.rds_private_subnets : module.vpc[0].private_subnets
  rds_vpc_id          = var.external_vpc ? var.rds_vpc_id : module.vpc[0].vpc_id
}
