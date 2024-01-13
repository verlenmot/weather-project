resource "azurerm_storage_account" "storage-raw" {
  name                      = "st${var.project_name}${var.project_instance}"
  location                  = "westeurope"
  resource_group_name       = var.rg_name
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "GRS"
  is_hns_enabled            = true
  enable_https_traffic_only = true

  network_rules {
    default_action = "Deny"
    ip_rules       = var.ip_exceptions
    bypass         = ["AzureServices"]
  }
}

resource "azurerm_storage_container" "forecast-raw" {
  name                 = "forecast"
  storage_account_name = azurerm_storage_account.storage-raw.name
}

resource "azurerm_storage_container" "realtime-raw" {
  name                 = "realtime"
  storage_account_name = azurerm_storage_account.storage-raw.name
}

data "azurerm_storage_account_blob_container_sas" "sas-raw-forecast" {
  connection_string = azurerm_storage_account.storage-raw.primary_connection_string
  container_name    = azurerm_storage_container.forecast-raw.name

  start  = "2024-01-01T00:00:00+0000"
  expiry = "2024-12-20T00:00:00+0000"


  permissions {
    read   = true
    write  = false # Overwrite content of an existing blob
    delete = false # Delete blobs
    create = true  # Add new blobs
    list   = true  # List blobs
    add    = false # Append data to blob
  }
}

data "azurerm_storage_account_blob_container_sas" "sas-raw-realtime" {
  connection_string = azurerm_storage_account.storage-raw.primary_connection_string
  container_name    = azurerm_storage_container.realtime-raw.name

  start  = "2024-01-01T00:00:00+0000"
  expiry = "2024-12-20T00:00:00+0000"


  permissions {
    read   = true
    write  = false # Overwrite content of an existing blob
    delete = false # Delete blobs
    create = true  # Add new blobs
    list   = true  # List blobs
    add    = false # Append data to blob
  }
}
