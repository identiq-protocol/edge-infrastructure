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
  source               = "terraform-aws-modules/eks/aws"
  version              = "11.0.0"
  cluster_name         = var.cluster_name
  cluster_version      = "1.15"
  subnets              = concat(module.vpc.private_subnets, module.vpc.public_subnets)
  vpc_id               = module.vpc.vpc_id
  map_roles            = var.map_roles
  wait_for_cluster_cmd = "sleep 300"
  worker_groups = [
    {
      subnets              = [module.vpc.private_subnets[0]]
      instance_type        = var.instance_type
      asg_max_size         = var.instance_count
      asg_desired_capacity = var.instance_count
    }
  ]
  workers_additional_policies = var.additional_policies
}

output connect {
  value = "aws eks --region ${var.region} update-kubeconfig --name ${var.cluster_name}"
}