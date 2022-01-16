terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/aws"
      version = "=3.72.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "=2.7.1"
    }
  }
}
