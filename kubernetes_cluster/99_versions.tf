terraform {
  required_version = ">= 1.1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.99.0, <= 2.99.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "<= 3.2.0"
    }
  }
}
