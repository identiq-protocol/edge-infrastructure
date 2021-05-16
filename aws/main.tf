variable "region" {
  default = "us-east-1"
}
provider "aws" {
  region = var.region
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
  version = "13.2.1"
  cluster_version      = "1.18"
  subnets              = concat(module.vpc.private_subnets, module.vpc.public_subnets)
  vpc_id               = module.vpc.vpc_id
  map_roles            = var.map_roles
  map_users            = var.map_users
  wait_for_cluster_cmd = "sleep 300"
  worker_groups_launch_template = [
    {
      name                    = "db"
      override_instance_types = [var.db_instance_type]
      spot_instance_pools     = var.db_instance_count
      on_demand_base_capacity = var.db_instance_count
      asg_min_size            = 0
      asg_max_size            = var.db_instance_count
      asg_desired_capacity    = var.external_store ? 0 : var.db_instance_count
      subnets                 = [module.vpc.private_subnets[0]]
      kubelet_extra_args      = "--node-labels=edge.identiq.com/role=db"
      public_ip               = false
    },
    {
      name                    = "cache"
      override_instance_types = [var.cache_instance_type]
      spot_instance_pools     = var.cache_instance_count
      on_demand_base_capacity = var.cache_instance_count
      asg_min_size            = 0
      asg_max_size            = var.cache_instance_count
      asg_desired_capacity    = var.external_store ? 0 : var.cache_instance_count
      subnets                 = [module.vpc.private_subnets[0]]
      kubelet_extra_args      = "--node-labels=edge.identiq.com/role=cache"
      public_ip               = false
    },
    {
      name                    = "components"
      override_instance_types = [var.components_instance_type]
      spot_instance_pools     = var.components_instance_count
      on_demand_base_capacity = var.components_instance_count
      asg_min_size            = 0
      asg_max_size            = var.components_instance_count
      asg_desired_capacity    = var.components_instance_count
      subnets                 = [module.vpc.private_subnets[0]]
      kubelet_extra_args      = "--node-labels=edge.identiq.com/role=components"
      public_ip               = false
    }
  ]
  workers_additional_policies = concat([aws_iam_policy.lb_controller_policy.arn],var.additional_policies)
  depends_on = [aws_iam_policy.lb_controller_policy]
}
