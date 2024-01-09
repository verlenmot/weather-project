terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.86.0"
    }
  }
}

provider "azurerm" {
  features {

  }
  subscription_id = var.subscription_id
}

# Resource Group & Budget to prevent costs
resource "azurerm_resource_group" "rg" {
  name     = "rg-weather-project"
  location = "westeurope"
  tags = {
    project = "weather"
  }
}

resource "azurerm_consumption_budget_resource_group" "bdg" {
  name              = "bdg-weather-project"
  resource_group_id = azurerm_resource_group.rg.id

  amount     = 5
  time_grain = "Monthly"

  time_period {
    start_date = "2024-01-01T00:00:00Z"
  }

  notification {
    enabled        = false
    operator       = "EqualTo"
    threshold      = 90.0
    contact_emails = ["Filler@filler.outlook"]
  }
}

# Storage Accounts & Containers
resource "azurerm_storage_account" "storage-raw" {
  name                     = "stweatherprojectraw"
  location                 = "westeurope"
  resource_group_name      = azurerm_resource_group.rg.name
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "GRS"
  is_hns_enabled           = true

  network_rules {
    default_action = "Deny"
    ip_rules       = [var.ip]
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

resource "azurerm_storage_account" "storage-serve" {
  name                     = "stweatherprojectserve"
  location                 = "westeurope"
  resource_group_name      = azurerm_resource_group.rg.name
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "GRS"
  is_hns_enabled           = true

  network_rules {
    default_action = "Deny"
    ip_rules       = [var.ip]
    bypass         = ["AzureServices"]
  }
}

resource "azurerm_storage_container" "forecast-serve" {
  name                 = "forecast"
  storage_account_name = azurerm_storage_account.storage-serve.name
}

resource "azurerm_storage_container" "realtime-serve" {
  name                 = "realtime"
  storage_account_name = azurerm_storage_account.storage-serve.name
}

# # Key vault
resource "azurerm_key_vault" "keyvault" {
  name                = "kv-weather-project"
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "standard"
  tenant_id           = var.tenant_id

  network_acls {
    default_action = "Deny"
    ip_rules = [var.ip]
    bypass   = "AzureServices"
  }
}

# # # Databricks

resource "azurerm_databricks_workspace" "Databricks" {
  name                        = "dbw-weather-project"
  location                    = "westeurope"
  resource_group_name         = azurerm_resource_group.rg.name
  sku                         = "standard"
  managed_resource_group_name = "rg-managed-weather-project"
}

# # # Power BI
# # Add later