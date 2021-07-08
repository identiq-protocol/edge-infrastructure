terraform {
  required_version = ">= 0.12.26"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.10"
    }
    mysql = {
      source  = "terraform-providers/mysql"
      version = ">= 1.6"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}
