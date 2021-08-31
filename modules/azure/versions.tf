terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.74.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "=1.6.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "=2.4.1"
    }
    local = {
      source  = "hashicorp/local"
      version = "=2.1.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "=3.1.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "=2.2.0"
    }
  }
}
