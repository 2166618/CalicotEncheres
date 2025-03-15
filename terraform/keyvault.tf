# keyvault.tf

resource "azurerm_key_vault" "kv" {
  name                        = "kv-dev-calicot-cc-${var.unique_code}"
  location                    = "Canada Central"
  resource_group_name         = "rg-dev-calicot-cc-${var.unique_code}"
  enabled_for_deployment      = true
  enabled_for_disk_encryption = true
  enabled_for_template_deployment = true
}

resource "azurerm_key_vault_secret" "secret" {
  name         = "NomDuSecret"
  value        = "ConnectionStrings"
  key_vault_id = azurerm_key_vault.kv.id
}
