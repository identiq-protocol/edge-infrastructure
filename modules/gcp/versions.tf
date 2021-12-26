terraform {
  required_providers {
    google     = {
      source  = "hashicorp/google"
      version = "~> 4.5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    //  required_version = "~> 0.12"
  }
}
