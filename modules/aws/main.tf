module "eks" {
  source                   = "terraform-aws-modules/eks/aws"
  version                  = "17.1.0"
  cluster_name             = var.eks_cluster_name
  cluster_version          = var.eks_cluster_version
  subnets                  = local.eks_subnets
  vpc_id                   = local.eks_vpc_id
  map_roles                = var.eks_map_roles
  map_users                = var.eks_map_users
  wait_for_cluster_timeout = var.eks_wait_for_cluster_timeout
  worker_groups_launch_template = [
    {
      name                    = "db"
      override_instance_types = [var.eks_db_instance_type]
      spot_instance_pools     = var.eks_db_instance_count
      on_demand_base_capacity = var.external_db ? 0 : var.eks_db_instance_count
      asg_min_size            = var.external_db ? 0 : var.eks_db_asg_min_size
      asg_max_size            = var.external_db ? 0 : var.eks_db_instance_count
      asg_desired_capacity    = var.external_db ? 0 : var.eks_db_instance_count
      subnets                 = [local.eks_private_subnets[0]]
      kubelet_extra_args      = "--node-labels=edge.identiq.com/role=db"
      public_ip               = false
      root_encrypted          = var.eks_db_root_encrypted
    },
    {
      name                    = "cache"
      override_instance_types = [var.eks_cache_instance_type]
      spot_instance_pools     = var.eks_cache_instance_count
      on_demand_base_capacity = var.external_redis ? 0 : var.eks_cache_instance_count
      on_demand_base_capacity = var.external_redis ? 0 : var.eks_cache_instance_count
      asg_min_size            = var.external_redis ? 0 : var.eks_cache_asg_min_size
      asg_max_size            = var.external_redis ? 0 : var.eks_cache_instance_count
      asg_desired_capacity    = var.external_redis ? 0 : var.eks_cache_instance_count
      subnets                 = [local.eks_private_subnets[0]]
      kubelet_extra_args      = "--node-labels=edge.identiq.com/role=cache"
      public_ip               = false
      root_encrypted          = var.eks_cache_root_encrypted
    },
    {
      name = "dynamic"
      tags = [
        {
          key                 = "k8s.io/cluster-autoscaler/enabled"
          propagate_at_launch = "false"
          value               = var.eks_dynamic_asg_autoscaling
        },
        {
          key                 = "k8s.io/cluster-autoscaler/${var.eks_cluster_name}"
          propagate_at_launch = "false"
          value               = "owned"
        },
        {
          key                 = "k8s.io/cluster-autoscaler/node-template/label/edge.identiq.com/role"
          propagate_at_launch = "false"
          value               = "dynamic"
        },
      ]
      override_instance_types = [var.eks_dynamic_instance_type]
      spot_instance_pools     = var.eks_dynamic_instance_count
      on_demand_base_capacity = var.eks_dynamic_instance_count
      asg_min_size            = var.eks_dynamic_asg_min_size
      asg_max_size            = var.eks_dynamic_instance_count
      asg_desired_capacity    = var.eks_dynamic_instance_count
      subnets                 = [local.eks_private_subnets[0]]
      kubelet_extra_args      = "--node-labels=edge.identiq.com/role=dynamic"
      public_ip               = false
      root_encrypted          = var.eks_dynamic_root_encrypted
    },
    {
      name                    = "base"
      override_instance_types = [var.eks_base_instance_type]
      spot_instance_pools     = var.eks_base_instance_count
      on_demand_base_capacity = var.eks_base_instance_count
      asg_min_size            = var.eks_base_asg_min_size
      asg_max_size            = var.eks_base_instance_count
      asg_desired_capacity    = var.eks_base_instance_count
      subnets                 = [local.eks_private_subnets[0]]
      kubelet_extra_args      = "--node-labels=edge.identiq.com/role=base"
      public_ip               = false
      root_encrypted          = var.eks_base_root_encrypted
    }
  ]
  worker_ami_name_filter      = var.eks_worker_ami_name_filter
  worker_ami_owner_id         = var.eks_worker_ami_owner_id
  cluster_enabled_log_types   = var.eks_cluster_enabled_log_types
  workers_additional_policies = concat([aws_iam_policy.lb_controller_policy.arn], [aws_iam_policy.worker_autoscaling.arn], var.eks_additional_policies)
  depends_on                  = [aws_iam_policy.lb_controller_policy, aws_iam_policy.worker_autoscaling]
  tags                        = merge(var.tags, var.default_tags)
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  #  token                  = data.aws_eks_cluster_auth.cluster.token
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws"
    args        = ["--region", var.region, "eks", "get-token", "--cluster-name", var.eks_cluster_name]
  }
}

#resource "null_resource" "storge_patch" {
#  provisioner "local-exec" {
#    command = "kubectl patch storageclass gp2 -p '{\"metadata\": {\"annotations\":{\"storageclass.kubernetes.io/is-default-class\":\"false\"}}}'"
#  }
#  depends_on = [
#    module.eks,
#  ]
#}
#
#resource "kubernetes_storage_class" "ssd" {
#  metadata {
#    name = "ssd"
#    annotations = {
#      "storageclass.kubernetes.io/is-default-class" = "true"
#    }
#  }
#  storage_provisioner    = "kubernetes.io/aws-ebs"
#  allow_volume_expansion = "true"
#  volume_binding_mode    = "WaitForFirstConsumer"
#  parameters = {
#    fsType      = "ext4"
#    "type"      = "gp2"
#    "encrypted" = "true"
#  }
#  depends_on = [
#    module.eks,
#  ]
#}

locals {
  eks_subnets         = var.external_vpc ? concat(var.eks_private_subnets, var.eks_public_subnets) : concat(module.vpc[0].private_subnets, module.vpc[0].public_subnets)
  eks_private_subnets = var.external_vpc ? var.eks_private_subnets : module.vpc[0].private_subnets
  eks_public_subnets  = var.external_vpc ? var.eks_public_subnets : module.vpc[0].public_subnets
  eks_vpc_id          = var.external_vpc ? var.eks_vpc_id : module.vpc[0].vpc_id
}
