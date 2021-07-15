variable "region" {
  default = "us-east-1"
}
provider "aws" {
  region = var.region
}
terraform {
  backend "s3" {
    region  = "us-east-1"
    role_arn = "arn:aws:iam::189347618452:role/allow-rw-s3"
    bucket  = "identiq-production-terraform"
    key     = "dev/aws/edges/test-pg"
    encrypt = "true"
  }
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws"
    args        = ["--region", var.region, "eks", "get-token", "--cluster-name", var.cluster_name]
  }
}

module "my-cluster" {
  source       = "terraform-aws-modules/eks/aws"
  cluster_name = var.cluster_name
  version = "17.1.0"
  cluster_version      = "1.18"
  subnets              = concat(module.vpc.private_subnets, module.vpc.public_subnets)
  vpc_id               = module.vpc.vpc_id
  map_roles            = var.map_roles
  map_users            = var.map_users

  # wait_for_cluster_cmd = "sleep 300"
  worker_groups_launch_template = [
    {
      name                    = "db"
      override_instance_types = [var.db_instance_type]
      spot_instance_pools     = var.external_store ? 0 : var.db_instance_count
      on_demand_base_capacity = var.external_store ? 0 : var.db_instance_count
      asg_min_size            = 0
      asg_max_size            = var.external_store ? 0 : var.db_instance_count
      asg_desired_capacity    = var.external_store ? 0 : var.db_instance_count
      subnets                 = [module.vpc.private_subnets[0]]
      kubelet_extra_args      = "--node-labels=edge.identiq.com/role=db"
      public_ip               = false
    },
    {
      name                    = "cache"
      override_instance_types = [var.cache_instance_type]
      spot_instance_pools     = var.external_store ? 0 : var.cache_instance_count
      on_demand_base_capacity = var.external_store ? 0 : var.cache_instance_count
      asg_min_size            = 0
      asg_max_size            = var.external_store ? 0 : var.cache_instance_count
      asg_desired_capacity    = var.external_store ? 0 : var.cache_instance_count
      subnets                 = [module.vpc.private_subnets[0]]
      kubelet_extra_args      = "--node-labels=edge.identiq.com/role=cache"
      public_ip               = false
    },
    {
      name                    = "dynamic"
      override_instance_types = [var.dynamic_instance_type]
      spot_instance_pools     = var.dynamic_instance_count
      on_demand_base_capacity = var.dynamic_instance_count
      asg_min_size            = 0
      asg_max_size            = var.dynamic_instance_count
      asg_desired_capacity    = var.dynamic_instance_count
      subnets                 = [module.vpc.private_subnets[0]]
      kubelet_extra_args      = "--node-labels=edge.identiq.com/role=dynamic"
      public_ip               = false
    },
    {
      name                    = "base"
      override_instance_types = [var.base_instance_type]
      spot_instance_pools     = var.base_instance_count
      on_demand_base_capacity = var.base_instance_count
      asg_min_size            = 0
      asg_max_size            = var.base_instance_count
      asg_desired_capacity    = var.base_instance_count
      subnets                 = [module.vpc.private_subnets[0]]
      kubelet_extra_args      = "--node-labels=edge.identiq.com/role=base"
      public_ip               = false
    }
  ]
  workers_additional_policies = concat([aws_iam_policy.lb_controller_policy.arn],var.additional_policies)
  depends_on = [aws_iam_policy.lb_controller_policy]
}
