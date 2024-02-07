output "sas_storage" {
  value     = data.azurerm_storage_account_sas.sas_storage.sas
  sensitive = true
}

output "storage_name" {
  value     = azurerm_storage_account.storage_raw.name
  sensitive = true
}