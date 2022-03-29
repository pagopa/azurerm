terraform {
  required_version = ">= 1.1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.80.0, <= 2.99.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.1.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.3.0"
    }
  }
}
