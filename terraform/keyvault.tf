# Obtenir les informations du client Azure courant
data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                        = "kv-dev-calicot-cc-${var.unique_code}"
  location                    = "Canada Central"
  resource_group_name         = "rg-dev-calicot-cc-${var.unique_code}"
  enabled_for_deployment      = true
  enabled_for_disk_encryption = true
  enabled_for_template_deployment = true
  
  # Éléments manquants ajoutés
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  
  # Politique d'accès pour le service principal qui déploie les ressources
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id
    
    key_permissions = [
      "Get", "List", "Create", "Delete", "Update"
    ]
    
    secret_permissions = [
      "Get", "List", "Set", "Delete"
    ]
    
    certificate_permissions = [
      "Get", "List", "Create", "Delete"
    ]
  }
}

resource "azurerm_key_vault_secret" "secret" {
  name         = "NomDuSecret"
  value        = "ConnectionStrings"
  key_vault_id = azurerm_key_vault.kv.id
}