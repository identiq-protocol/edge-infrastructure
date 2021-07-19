# AWS Edge infrastructure

This Terraform module creates Identiq's edge infrastructure on which the edge application will deployed on.
The infstructarue consists of the following components:
 * [EKS](https://aws.amazon.com/eks) cluster
 * MySQL (Containerized or RDS)
 * Redis (Containerized or Elasticache)

## Requirements

* [AWS Terraform provider](https://www.terraform.io/docs/providers/aws/)
* [kubernetes terraform provider](https://www.terraform.io/docs/providers/kubernetes)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster_name | EKS cluster name | `string` |  | no |
| cluster_version | Kubernetes version to use for the EKS cluster | `string` | false | no |
| external\_store | MySQL and Redis data stores will installed outside of EKS cluster | `string` | false | no |
| map\_users | Additional IAM (user) roles to administer the cluster | `list(object({ userarn = string username = string groups = list(string) }))` | false | no |
| additional_policies | Additional IAM policies (ex. cloudwatch logs) | `list(string)` | false | no | 
