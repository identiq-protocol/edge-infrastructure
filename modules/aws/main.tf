### compatibility with v0 of the module
moved {
  from = module.eks.aws_iam_role.cluster[0]
  to   = module.eks.aws_iam_role.this[0]
}

locals {
  eks_subnets                            = var.external_vpc ? concat(var.eks_private_subnets, var.eks_public_subnets) : concat(module.vpc[0].private_subnets, module.vpc[0].public_subnets)
  eks_private_subnets                    = var.external_vpc ? var.eks_private_subnets : module.vpc[0].private_subnets
  eks_public_subnets                     = var.external_vpc ? var.eks_public_subnets : module.vpc[0].public_subnets
  eks_vpc_id                             = var.external_vpc ? var.eks_vpc_id : module.vpc[0].vpc_id
  aws_load_balancer_controller_manifests = [for manifest in split("---", file("${path.module}/crds/aws-load-balancer-controller.yaml")) : yamldecode(manifest)]
  addons_node_selector = var.eks_master_create ? {
    "node.kubernetes.io/role" = "master"
    } : {
    "edge.identiq.com/role" = "base"
  }
  master_node_group = {
    master = {
      # By default, the module creates a launch template to ensure tags are propagated to instances, etc.,
      # so we need to disable it to use the default template provided by the AWS EKS managed node group service
      use_custom_launch_template = false
      # We are using the IRSA created below for permissions
      # However, we have to deploy with the policy attached FIRST (when creating a fresh cluster)
      # and then turn this off after the cluster/node group is created. Without this initial policy,
      # the VPC CNI fails to assign IPs and nodes cannot join the cluster
      # See https://github.com/aws/containers-roadmap/issues/1666 for more context
      iam_role_attach_cni_policy = true
      ami_type             = var.eks_master_ami_type
      platform             = var.eks_master_platform
      capacity_type        = var.eks_master_capacity_type
      force_update_version = true
      instance_types       = var.eks_master_instance_types
      labels = {
        "node.kubernetes.io/role" = "master"
      }
      taints = [
        {
          key    = "CriticalAddonsOnly"
          effect = "NO_SCHEDULE"
        }
      ]
      min_size     = var.eks_master_min_size
      max_size     = var.eks_master_max_size
      desired_size = var.eks_master_desired_count
    }
  }
  base_node_group = {
    # Base node-group
    base = {
      use_custom_launch_template = false
      iam_role_attach_cni_policy = true
      ami_type             = var.eks_base_ami_type
      platform             = var.eks_base_platform
      capacity_type        = var.eks_base_capacity_type
      force_update_version = true
      instance_types       = var.eks_base_instance_types
      labels = {
        "edge.identiq.com/role" = "base"
      }
      min_size     = var.eks_base_min_size
      max_size     = var.eks_base_max_size
      desired_size = var.eks_base_desired_count
    }
  }
  db_node_group = {
    db = {
      use_custom_launch_template = false
      iam_role_attach_cni_policy = true
      ami_type             = var.eks_db_ami_type
      platform             = var.eks_db_platform
      capacity_type        = var.eks_db_capacity_type
      force_update_version = true
      instance_types       = var.eks_db_instance_types
      labels = {
        "edge.identiq.com/role" = "db"
      }
      taints = [
        {
          key    = "db"
          effect = "NO_SCHEDULE"
        }
      ]
      min_size     = var.eks_db_min_size
      max_size     = var.eks_db_max_size
      desired_size = var.eks_db_desired_count
    }

  }
  cache_node_group = {
    cache = {
      use_custom_launch_template = false
      iam_role_attach_cni_policy = true
      ami_type             = var.eks_cache_ami_type
      platform             = var.eks_cache_platform
      capacity_type        = var.eks_cache_capacity_type
      force_update_version = true
      instance_types       = var.eks_cache_instance_types
      labels = {
        "edge.identiq.com/role" = "cache"
      }
      taints = [
        {
          key    = "cache"
          effect = "NO_SCHEDULE"
        }
      ]
      min_size     = var.eks_cache_min_size
      max_size     = var.eks_cache_max_size
      desired_size = var.eks_cache_desired_count
    }

  }
  dynamic_node_group = {
    dynamic = {
      use_custom_launch_template = false
      iam_role_attach_cni_policy = true
      ami_type             = var.eks_dynamic_ami_type
      platform             = var.eks_dynamic_platform
      capacity_type        = var.eks_dynamic_capacity_type
      force_update_version = true
      instance_types       = var.eks_dynamic_instance_types
      labels = {
        "edge.identiq.com/role" = "dynamic"
      }
      taints = [
        {
          key    = "dynamic"
          effect = "NO_SCHEDULE"
        }
      ]
      min_size     = var.eks_dynamic_min_size
      max_size     = var.eks_dynamic_max_size
      desired_size = var.eks_dynamic_desired_count
    }
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.16.0"

  # compatibility with 17.24.0 eks module
  prefix_separator                   = ""
  iam_role_name                      = var.eks_cluster_name
  cluster_security_group_name        = var.eks_cluster_name
  cluster_security_group_description = "EKS cluster security group."


  cluster_name                         = var.eks_cluster_name
  cluster_version                      = var.eks_cluster_version
  cluster_endpoint_public_access       = var.eks_cluster_endpoint_public_access
  cluster_endpoint_public_access_cidrs = var.eks_cluster_endpoint_public_access_cidrs
  cluster_encryption_config            = var.eks_cluster_encryption_config
  cluster_addons = {
    coredns = {
      most_recent = true
      configuration_values = jsonencode({
        nodeSelector = local.addons_node_selector
      })
    }
    kube-proxy = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent = true
      configuration_values = jsonencode({
        controller = {
          nodeSelector = local.addons_node_selector
        }
      })
    }
    vpc-cni = {
      most_recent    = true
      before_compute = true
      configuration_values = jsonencode({
        env = {
          # Reference docs https://docs.aws.amazon.com/eks/latest/userguide/cni-increase-ip-addresses.html
          ENABLE_PREFIX_DELEGATION = "true"
          WARM_PREFIX_TARGET       = "1"
        }
      })
    }
  }

  vpc_id                   = local.eks_vpc_id
  subnet_ids               = [local.eks_private_subnets[0]]
  control_plane_subnet_ids = local.eks_subnets

  manage_aws_auth_configmap = true
  aws_auth_roles            = var.eks_map_roles
  aws_auth_users            = var.eks_map_users
  eks_managed_node_group_defaults = {
    tags = {
      "k8s.io/cluster-autoscaler/enabled"                                   = "true",
      "k8s.io/cluster-autoscaler/${var.eks_cluster_name}"                   = "owned",
    }
    iam_role_additional_policies = {
      AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
      ClusterAutoscalerPolicy  = aws_iam_policy.worker_autoscaling.arn

    }
  }
  eks_managed_node_groups = merge(
    local.base_node_group,
    local.dynamic_node_group,
    var.eks_master_create ? local.master_node_group : {},
    var.external_db ? {} : local.db_node_group,
    var.external_redis ? {} : local.cache_node_group
  )
}

################################################################################
# Tags for the ASG to support cluster-autoscaler scale up from 0
################################################################################

locals {

  # We need to lookup K8s taint effect from the AWS API value
  taint_effects = {
    NO_SCHEDULE        = "NoSchedule"
    NO_EXECUTE         = "NoExecute"
    PREFER_NO_SCHEDULE = "PreferNoSchedule"
  }

  cluster_autoscaler_label_tags = merge([
    for name, group in module.eks.eks_managed_node_groups : {
      for label_name, label_value in coalesce(group.node_group_labels, {}) : "${name}|label|${label_name}" => {
        autoscaling_group = group.node_group_autoscaling_group_names[0],
        key               = "k8s.io/cluster-autoscaler/node-template/label/${label_name}",
        value             = label_value,
      }
    }
  ]...)

  cluster_autoscaler_taint_tags = merge([
    for name, group in module.eks.eks_managed_node_groups : {
      for taint in coalesce(group.node_group_taints, []) : "${name}|taint|${taint.key}" => {
        autoscaling_group = group.node_group_autoscaling_group_names[0],
        key               = "k8s.io/cluster-autoscaler/node-template/taint/${taint.key}"
        value             = "${taint.value}:${local.taint_effects[taint.effect]}"
      }
    }
  ]...)

  cluster_autoscaler_asg_tags = merge(local.cluster_autoscaler_label_tags, local.cluster_autoscaler_taint_tags)
}

resource "aws_autoscaling_group_tag" "cluster_autoscaler_label_tags" {
  for_each = local.cluster_autoscaler_asg_tags

  autoscaling_group_name = each.value.autoscaling_group

  tag {
    key   = each.value.key
    value = each.value.value

    propagate_at_launch = false
  }
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
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
