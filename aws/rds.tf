resource "random_password" "rds_password" {
  count = var.external_store ?  1 : 0
  length           = 16
  special          = true
}

module "rds" {
  count = var.external_store ?  1 : 0
  source  = "terraform-aws-modules/rds/aws"
  version = "2.35.0"
  identifier = var.store_name
  name    = "edge"

  engine               = "mariadb"
  engine_version       = "10.3"
  family               = "mariadb10.3" # DB parameter group
  major_engine_version = "10.3"      # DB option group
  instance_class       = "db.m5.large"

  allocated_storage     = 1000
  storage_encrypted     = false

  username = "edge"
  password = random_password.rds_password[0].result
  port     = 3306

  multi_az               = true
  subnet_ids             = module.vpc.private_subnets
  vpc_security_group_ids = [module.my-cluster.worker_security_group_id]

  maintenance_window              = "Sun:00:00-Sun:03:00"
  backup_window                   = "03:00-06:00"
  enabled_cloudwatch_logs_exports = ["general"]

  backup_retention_period = 0
  skip_final_snapshot     = true
  deletion_protection     = false

  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  create_monitoring_role                = true
  monitoring_interval                   = 60

  tags = {
    Terraform                                   = "true"
  }
}

resource "kubernetes_secret" "edge_mariadb_secret" {
  count = var.external_store ?  1 : 0
  metadata {
    name = "edge-mariadb"
    annotations = {
      "ad.datadoghq.com/service.check_names" = "[\"mysql\"]"
      "ad.datadoghq.com/service.init_configs" = "[{}]"
      "ad.datadoghq.com/service.instances" = "[{\"server\": \"%%host%%\", \"user\": \"edge\", \"pass\": \"%%env_MYSQL_PASS%%\", \"options\": {\"schema_size_metrics\": \"true\"}}]"
    }
  }
  data = {
    mariadb-password = module.rds[0].this_db_instance_password
    mariadb-root-password = module.rds[0].this_db_instance_password
  }
  
  depends_on = [
    module.my-cluster,
    module.rds[0]
  ]
}

resource "kubernetes_service" "edge_mariadb_service" {
  count = var.external_store ?  1 : 0
  metadata {
    name = "edge-mariadb"
    annotations = {
      "ad.datadoghq.com/service.check_names" = "[\"mysql\"]"
      "ad.datadoghq.com/service.init_configs" = "[{}]"
      "ad.datadoghq.com/service.instances" = "[{\"server\": \"%%host%%\", \"user\": \"edge\", \"pass\": \"%%env_MYSQL_PASS%%\", \"options\": {\"schema_size_metrics\": \"true\"}}]"
    }
  }

  spec {
    type = "ExternalName"
    external_name = module.rds[0].this_db_instance_address
  }

  depends_on = [
    module.my-cluster,
    module.rds[0]
  ]
}
