terraform {
  required_version = ">= 1.1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.80.0, <= 3.28.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "<= 2.7.1"
    }
  }
}
