resource "random_password" "rds_password" {
  count   = var.external_store ? 1 : 0
  length  = 16
  special = true
}

module "rds" {
  count                                 = var.external_store ? 1 : 0
  source                                = "terraform-aws-modules/rds/aws"
  version                               = "2.35.0"
  identifier                            = var.store_name
  name                                  = var.rds_db_name
  monitoring_role_name                  = "${var.eks_cluster_name}-monitoring"
  create_monitoring_role                = var.rds_create_monitoring_role
  engine                                = var.rds_engine
  engine_version                        = var.rds_engine_version
  family                                = var.rds_parameter_group # DB parameter group
  major_engine_version                  = var.rds_parameter_group # DB option group
  instance_class                        = var.rds_instance_class
  allocated_storage                     = var.rds_allocated_storage
  storage_encrypted                     = var.rds_storage_encrypted
  username                              = var.rds_username
  password                              = random_password.rds_password[0].result
  port                                  = var.rds_engine == "mariadb" ? 3306 : 5432
  multi_az                              = var.rds_multi_az
  subnet_ids                            = module.vpc.private_subnets
  vpc_security_group_ids                = [module.my-cluster.worker_security_group_id]
  maintenance_window                    = var.rds_maintenance_window
  backup_window                         = var.rds_backup_window
  enabled_cloudwatch_logs_exports       = [var.rds_engine == "mariadb" ? "general" : "postgresql"]
  backup_retention_period               = var.rds_backup_retention_period
  skip_final_snapshot                   = var.rds_skip_final_snapshot
  deletion_protection                   = var.rds_deletion_protection
  performance_insights_enabled          = var.rds_performance_insights_enabled
  performance_insights_retention_period = var.rds_performance_insights_retention_period
  monitoring_interval                   = var.rds_monitoring_interval

  tags = {
    Terraform = "true"
  }
}

resource "kubernetes_secret" "edge_db_secret" {
  count = var.external_store ? 1 : 0
  metadata {
    name = "edge-${var.rds_engine == "mariadb" ? "mariadb" : "postgresql"}"
  }
  data = {
    "${var.rds_engine == "mariadb" ? "mariadb" : "postgresql"}-password"      = module.rds[0].this_db_instance_password
    "${var.rds_engine == "mariadb" ? "mariadb" : "postgresql"}-root-password" = module.rds[0].this_db_instance_password
  }

  depends_on = [
    module.my-cluster,
    module.rds[0]
  ]
}

resource "kubernetes_service" "edge_db_service" {
  count = var.external_store ? 1 : 0
  metadata {
    name = "edge-${var.rds_engine == "mariadb" ? "mariadb" : "postgresql"}"
    annotations = {
      "ad.datadoghq.com/service.check_names"  = "[\"mysql\"]"
      "ad.datadoghq.com/service.init_configs" = "[{}]"
      "ad.datadoghq.com/service.instances"    = "[{\"server\": \"%%host%%\", \"user\": \"edge\", \"pass\": \"%%env_MYSQL_PASS%%\", \"options\": {\"schema_size_metrics\": \"true\"}}]"
    }
  }

  spec {
    type          = "ExternalName"
    external_name = module.rds[0].this_db_instance_address
  }

  depends_on = [
    module.my-cluster,
    module.rds[0]
  ]
}
