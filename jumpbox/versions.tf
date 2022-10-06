terraform {
  required_version = ">= 1.1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.80.0, <= 2.99.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "<= 3.4.0"
    }
  }
}
