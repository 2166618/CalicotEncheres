provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-dev-calicot-cc-${var.unique_code}"
  location = "Canada Central"
}
