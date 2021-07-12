plugin "azurerm" {
  enabled = true
  version = "0.11.0"
  source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}
config {
  module = true
}
