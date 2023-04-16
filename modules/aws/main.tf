module "eks" {
  source                   = "terraform-aws-modules/eks/aws"
  version                  = "17.24.0"
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
      kubelet_extra_args      = "--node-labels=edge.identiq.com/role=db --register-with-taints=db:NoSchedule"
      public_ip               = false
      root_encrypted          = var.eks_db_root_encrypted
      root_volume_size        = var.eks_db_root_volume_size
      root_volume_type        = var.eks_db_root_volume_type
      enable_monitoring       = var.eks_db_enable_monitoring
    },
    {
      name                    = "cache"
      override_instance_types = [var.eks_cache_instance_type]
      spot_instance_pools     = var.eks_cache_instance_count
      on_demand_base_capacity = var.external_redis ? 0 : var.eks_cache_instance_count
      asg_min_size            = var.external_redis ? 0 : var.eks_cache_asg_min_size
      asg_max_size            = var.external_redis ? 0 : var.eks_cache_instance_count
      asg_desired_capacity    = var.external_redis ? 0 : var.eks_cache_instance_count
      subnets                 = [local.eks_private_subnets[0]]
      kubelet_extra_args      = "--node-labels=edge.identiq.com/role=cache --register-with-taints=cache:NoSchedule"
      public_ip               = false
      root_encrypted          = var.eks_cache_root_encrypted
      root_volume_size        = var.eks_cache_root_volume_size
      root_volume_type        = var.eks_cache_root_volume_type
      enable_monitoring       = var.eks_cache_enable_monitoring
    },
    {
      name = "dynamic"
      tags = [
        {
          key                 = "k8s.io/cluster-autoscaler/enabled"
          propagate_at_launch = "true"
          value               = var.eks_dynamic_asg_autoscaling
        },
        {
          key                 = "k8s.io/cluster-autoscaler/${var.eks_cluster_name}"
          propagate_at_launch = "true"
          value               = "owned"
        },
        {
          key                 = "k8s.io/cluster-autoscaler/node-template/label/edge.identiq.com/role"
          propagate_at_launch = "true"
          value               = "dynamic"
        },
        {
          key                 = "k8s.io/cluster-autoscaler/node-template/taint/dynamic"
          propagate_at_launch = "true"
          value               = "true:NoSchedule"
        },
      ]
      override_instance_types = [var.eks_dynamic_instance_type]
      spot_instance_pools     = var.eks_dynamic_instance_count
      on_demand_base_capacity = var.eks_dynamic_max_instance_count
      asg_min_size            = var.eks_dynamic_asg_min_size
      asg_max_size            = var.eks_dynamic_max_instance_count
      asg_desired_capacity    = var.eks_dynamic_instance_count
      subnets                 = [local.eks_private_subnets[0]]
      kubelet_extra_args      = "--node-labels=edge.identiq.com/role=dynamic --register-with-taints=dynamic:NoSchedule"
      public_ip               = false
      root_encrypted          = var.eks_dynamic_root_encrypted
      root_volume_size        = var.eks_dynamic_root_volume_size
      root_volume_type        = var.eks_dynamic_root_volume_type
      enable_monitoring       = var.eks_dynamic_enable_monitoring
    },
    {
      name                    = "base"
      override_instance_types = [var.eks_base_instance_type]
      on_demand_base_capacity = var.eks_base_instance_count
      asg_min_size            = var.eks_base_asg_min_size
      asg_max_size            = var.eks_base_instance_count
      asg_desired_capacity    = var.eks_base_instance_count
      subnets                 = [local.eks_private_subnets[0]]
      kubelet_extra_args      = "--node-labels=edge.identiq.com/role=base"
      public_ip               = false
      root_encrypted          = var.eks_base_root_encrypted
      root_volume_size        = var.eks_base_root_volume_size
      root_volume_type        = var.eks_base_root_volume_type
      enable_monitoring       = var.eks_base_enable_monitoring
    }
  ]
  worker_ami_name_filter                         = var.eks_worker_ami_name_filter
  worker_ami_owner_id                            = var.eks_worker_ami_owner_id
  cluster_enabled_log_types                      = var.eks_cluster_enabled_log_types
  workers_additional_policies                    = concat([aws_iam_policy.lb_controller_policy.arn], [aws_iam_policy.worker_autoscaling.arn], ["arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"], var.eks_additional_policies)
  depends_on                                     = [aws_iam_policy.lb_controller_policy, aws_iam_policy.worker_autoscaling]
  tags                                           = merge(var.tags, var.default_tags)
  cluster_endpoint_private_access                = var.eks_cluster_endpoint_private_access
  cluster_endpoint_public_access                 = var.eks_cluster_endpoint_public_access
  cluster_endpoint_public_access_cidrs           = var.eks_cluster_endpoint_public_access_cidrs
  cluster_create_endpoint_private_access_sg_rule = var.eks_cluster_create_endpoint_private_access_sg_rule
  cluster_endpoint_private_access_cidrs          = var.eks_cluster_endpoint_private_access_cidrs
  cluster_endpoint_private_access_sg             = var.eks_cluster_endpoint_private_access_sg

}

data "aws_eks_cluster" "cluster" {
  name = split("/", module.eks.cluster_arn)[1]
}

data "aws_eks_cluster_auth" "cluster" {
  name = split("/", module.eks.cluster_arn)[1]
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws"
    args        = ["--region", var.region, "eks", "get-token", "--cluster-name", var.eks_cluster_name]
  }
}

resource "kubernetes_annotations" "gp2" {
  api_version = "storage.k8s.io/v1"
  kind        = "StorageClass"
  force       = true
  metadata {
    name = "gp2"
  }
  annotations = {
    "storageclass.kubernetes.io/is-default-class" = "false"
  }
  depends_on = [
    module.eks
  ]
}
resource "kubernetes_storage_class" "ssd" {
  metadata {
    name = "ssd"
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "true"
    }
  }
  storage_provisioner    = "kubernetes.io/aws-ebs"
  allow_volume_expansion = "true"
  volume_binding_mode    = "WaitForFirstConsumer"
  parameters = {
    fsType      = "ext4"
    "type"      = "gp2"
    "encrypted" = "true"
  }
  depends_on = [
    module.eks,
  ]
}
locals {
  eks_subnets         = var.external_vpc ? concat(var.eks_private_subnets, var.eks_public_subnets) : concat(module.vpc[0].private_subnets, module.vpc[0].public_subnets)
  eks_private_subnets = var.external_vpc ? var.eks_private_subnets : module.vpc[0].private_subnets
  eks_public_subnets  = var.external_vpc ? var.eks_public_subnets : module.vpc[0].public_subnets
  eks_vpc_id          = var.external_vpc ? var.eks_vpc_id : module.vpc[0].vpc_id
}
