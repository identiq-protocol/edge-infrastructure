# AWS Edge infrastructure

This Terraform module creates Identiq's edge infrastructure on which the edge application will deployed on.
The infstructarue consists of the following components:
 * [EKS](https://aws.amazon.com/eks) cluster
 * PostgreSQL (Containerized or RDS)
 * Redis (Containerized or Elasticache)
