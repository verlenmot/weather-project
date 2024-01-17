# Raw Data
resource "azurerm_storage_account" "storage_raw" {
  name                      = "str${var.project_name}${var.project_instance}"
  location                  = "westeurope"
  resource_group_name       = var.rg_name
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "GRS"
  is_hns_enabled            = true
  enable_https_traffic_only = true

  network_rules {
    default_action             = "Deny"
    ip_rules                   = var.ip_exceptions
    virtual_network_subnet_ids = var.subnet_ids
    bypass                     = ["AzureServices"]
  }
}

resource "azurerm_storage_container" "forecast_raw" {
  name                 = "forecast"
  storage_account_name = azurerm_storage_account.storage_raw.name
}

resource "azurerm_storage_container" "realtime_raw" {
  name                 = "realtime"
  storage_account_name = azurerm_storage_account.storage_raw.name
}

data "azurerm_storage_account_sas" "sas_storage" {
  connection_string = azurerm_storage_account.storage_raw.primary_connection_string

  start          = "2024-01-16T14:00:01Z"
  expiry         = "2024-03-16T22:52:23Z"
  signed_version = "2022-11-02"

  resource_types {
    service   = false
    container = true
    object    = true
  }

  services {
    blob  = true
    queue = false
    table = false
    file  = false
  }

  permissions {
    read    = true
    write   = true  # Overwrite content of an existing blob
    delete  = false # Delete blobs
    list    = true  # List blobs
    add     = false # Append data to blob
    create  = true
    update  = false
    process = false
    tag     = false
    filter  = false
  }
}
