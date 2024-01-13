output "sas_forecast" {
  value     = data.azurerm_storage_account_blob_container_sas.sas_raw_forecast.sas
  sensitive = true
}

output "sas_realtime" {
  value     = data.azurerm_storage_account_blob_container_sas.sas_raw_realtime.sas
  sensitive = true
}
