terraform {
  required_version = ">=1.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.17.0"

    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.11.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.23.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.4.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.0"
    }

  }
}

resource "kubernetes_config_map" "version" {
  metadata {
    name = "identiq-version"
  }
  data = {
    "identiqVersion" = jsonencode(local.identiqVersion)
  }
}

locals {
  identiqVersion = {
    terraformModuleVersion = chomp(file("${path.module}/version"))
    terraformLastApplyTime = timestamp()
    cloud                  = "aws"
    region                 = var.region
    eksVersion             = var.eks_cluster_version
    eksClusterName         = var.eks_cluster_name
    vpcId                  = module.vpc[0].vpc_id
    vpcPinkySG             = aws_security_group.pinky_ingress.id
    vpcEndpointAddress     = length(aws_vpc_endpoint.ep) > 0 ? aws_vpc_endpoint.ep[0].dns_entry[0]["dns_name"] : ""
    vpcNatIPs              = var.external_vpc ? [] : module.vpc[0].nat_public_ips
    externalRedis          = var.external_redis
    ecVersion              = var.ec_engine_version
    ecAmountOfInstances    = var.ec_cluster_mode_num_node_groups
    ecInstanceType         = var.ec_instance_type
    externalDB             = var.external_db
    externalDBName         = var.external_db_name
    rdsDBVersion           = var.rds_engine_version
    rdsInstanceType        = var.rds_instance_class
    rdsDiskIOPS            = var.rds_iops
  }
}
