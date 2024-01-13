output "sas_forecast" {
  value = data.azurerm_storage_account_blob_container_sas.sas-raw-forecast.sas
  sensitive = true
}

output "sas_realtime" {
  value = data.azurerm_storage_account_blob_container_sas.sas-raw-realtime.sas
  sensitive = true
}
