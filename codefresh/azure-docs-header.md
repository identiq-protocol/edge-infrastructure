# Azure Edge infrastructure

This Terraform module creates Identiq's edge infrastructure on which the edge application will deployed on.
The infstructarue consists of the following components:
 * [AKS](https://docs.microsoft.com/en-us/azure/aks/intro-kubernetes) cluster
 * PostgreSQL (Containerized or Azure PostgreSQL)
 * Redis (Containerized or Azure Cache for Redis)
