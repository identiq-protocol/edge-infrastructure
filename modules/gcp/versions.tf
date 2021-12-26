terraform {
  required_providers {
    google     = {
      source  = "hashicorp/google"
      version = "3.90.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    //  required_version = "~> 0.12"
  }
}
