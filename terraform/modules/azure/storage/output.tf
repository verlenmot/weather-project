output "sas_storage" {
  value     = data.azurerm_storage_account_sas.sas_storage.sas
  sensitive = true
}
