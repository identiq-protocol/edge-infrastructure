locals {
  cluster_autoscaler_values = var.cluster_autoscaler_enabled ? templatefile("${path.module}/templates/cluster-autoscaler.yaml", {
    cluster_name = module.eks.cluster_name
    region       = var.region
    irsa_arn     = module.cluster_autoscaler_irsa_role[0].iam_role_arn
    node_selector = var.eks_master_create ? jsonencode({
      "node.kubernetes.io/role" = "master"
      }) : jsonencode({
      "edge.identiq.com/role" = "base"
    })
    tolerations = jsonencode([{
      key : "CriticalAddonsOnly",
      operator : "Exists"
      effect : "NoSchedule"
      }
    ])
    verbosity_level = var.cluster_autoscaler_verbosity_level
    image_tag       = var.cluster_autoscaler_image_tag
  }) : ""
}

provider "aws" {
  region = "us-east-1"
  alias  = "virginia"
}

data "aws_ecrpublic_authorization_token" "token" {
  provider = aws.virginia
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
    }
  }
  registry {
    url      = "oci://public.ecr.aws/karpenter"
    username = data.aws_ecrpublic_authorization_token.token.user_name
    password = data.aws_ecrpublic_authorization_token.token.password
  }
}

module "cluster_autoscaler_irsa_role" {
  count                            = var.cluster_autoscaler_enabled ? 1 : 0
  source                           = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version                          = "5.30.0"
  role_name                        = "${module.eks.cluster_name}-cluster-autoscaler"
  attach_cluster_autoscaler_policy = true
  cluster_autoscaler_cluster_names = [module.eks.cluster_name]

  oidc_providers = {
    eks = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["${var.cluster_autoscaler_namespace}:cluster-autoscaler"]
    }
  }
}

resource "helm_release" "cluster-autoscaler" {
  count      = var.cluster_autoscaler_enabled ? 1 : 0
  name       = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  version    = var.cluster_autoscaler_helm_chart_version
  namespace  = var.cluster_autoscaler_namespace
  values = [
    local.cluster_autoscaler_values,
  ]
}
