data "azurerm_client_config" "current" {

}

resource "azurerm_key_vault" "kv" {
  name                = "kv-${var.project_name}-${var.project_instance}"
  location            = "westeurope"
  resource_group_name = var.rg_name
  sku_name            = "standard"
  tenant_id           = data.azurerm_client_config.current.tenant_id

  network_acls {
    default_action = "Deny"
    ip_rules       = var.ip_exceptions
    bypass         = "AzureServices"
  }
}

resource "azurerm_key_vault_access_policy" "kv-access-storage" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = ["Get", "Set", "List", "Delete", "Purge"]
}

resource "azurerm_key_vault_secret" "secret" {
  for_each     = var.secrets
  name         = each.key
  value        = each.value
  key_vault_id = azurerm_key_vault.kv.id
  depends_on   = [azurerm_key_vault_access_policy.kv-access-storage]
}
