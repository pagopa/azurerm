terraform {
  required_version = ">= 1.1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.80.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.2.2"
    }
  }
}
