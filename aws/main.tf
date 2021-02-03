variable "region" {
  default = "us-east-1"
}
provider "aws" {
  region = var.region
}
provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "~> 1.9"
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
  worker_groups = [
    {
      subnets              = [module.vpc.private_subnets[0]]
      instance_type        = var.instance_type
      asg_min_size         = 0
      asg_max_size         = var.instance_count
      asg_desired_capacity = var.instance_count
    }
  ]
  workers_additional_policies = concat([aws_iam_policy.lb_controller_policy.arn],var.additional_policies)
  depends_on = [aws_iam_policy.lb_controller_policy]
}
