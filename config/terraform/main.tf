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
  name = "bdg-weather-project"
  resource_group_id = azurerm_resource_group.rg.id

  amount = 5
  time_grain = "Monthly"

  time_period {
    start_date =  "2024-01-01T00:00:00Z"
  }

  notification {
    enabled = false
    operator = "EqualTo"
    threshold = 90.0
    contact_emails = ["Filler@filler.outlook"]
  }
}


# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-weather-project"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]

}
resource "azurerm_subnet" "snet" {
  name                 = "snet-weather-project"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]
  service_endpoints    = ["Microsoft.KeyVault", "Microsoft.Storage"]
}

resource "azurerm_subnet" "snet-dbw-container" {
  name                 = "snet-weather-project-container"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
  service_endpoints    = ["Microsoft.KeyVault", "Microsoft.Storage"]
}

resource "azurerm_subnet" "snet-dbw-host" {
  name                 = "snet-weather-project-host"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
  service_endpoints    = ["Microsoft.KeyVault", "Microsoft.Storage"]
}




# resource "azurerm_network_security_group" "nsg" {
#   name                = "nsg-weather-project"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = "westeurope"
# }

# # Note - Adjust rules so that container creation is possible.
# resource "azurerm_subnet_network_security_group_association" "nsg-association" {
#   subnet_id                 = azurerm_subnet.snet.id
#   network_security_group_id = azurerm_network_security_group.nsg.id
# }

# # Storage Accounts & Containers
# resource "azurerm_storage_account" "storage-raw" {
#   name                     = "stweatherprojectraw"
#   location                 = "westeurope"
#   resource_group_name      = azurerm_resource_group.rg.name
#   account_kind             = "StorageV2"
#   account_tier             = "Standard"
#   account_replication_type = "GRS"
#   is_hns_enabled           = true

#   network_rules {
#     default_action             = "Deny"
#     virtual_network_subnet_ids = [azurerm_subnet.snet.id]
#     ip_rules                   = [var.ip]
#   }
# }

# resource "azurerm_storage_container" "forecast-raw" {
#   name                 = "forecast"
#   storage_account_name = azurerm_storage_account.storage-raw.name
# }

# resource "azurerm_storage_container" "realtime-raw" {
#   name                 = "realtime"
#   storage_account_name = azurerm_storage_account.storage-raw.name
# }

# resource "azurerm_storage_account" "storage-serve" {
#   name                     = "stweatherprojectserve"
#   location                 = "westeurope"
#   resource_group_name      = azurerm_resource_group.rg.name
#   account_kind             = "StorageV2"
#   account_tier             = "Standard"
#   account_replication_type = "GRS"
#   is_hns_enabled           = true

#   network_rules {
#     default_action             = "Deny"
#     virtual_network_subnet_ids = [azurerm_subnet.snet.id]
#     ip_rules                   = [var.ip]
#   }
# }

# resource "azurerm_storage_container" "forecast-serve" {
#   name                 = "forecast"
#   storage_account_name = azurerm_storage_account.storage-serve.name
# }

# resource "azurerm_storage_container" "realtime-serve" {
#   name                 = "realtime"
#   storage_account_name = azurerm_storage_account.storage-serve.name
# }

# # # Key vault
# resource "azurerm_key_vault" "keyvault" {
#   name                = "kv-weather-project"
#   location            = "westeurope"
#   resource_group_name = azurerm_resource_group.rg.name
#   sku_name            = "standard"
#   tenant_id           = var.tenant_id

#   network_acls {
#     default_action = "Deny"
#     virtual_network_subnet_ids = [ azurerm_subnet.snet.id ]
#     ip_rules = [ var.ip ]
#     bypass = "None"
#   }
# }

# # # Databricks

# resource "azurerm_databricks_workspace" "Databricks" {
#   name                = "dbw-weather-project"
#   location            = "westeurope"
#   resource_group_name = azurerm_resource_group.rg.name
#   sku                 = "standard"
#   managed_resource_group_name = "rg-managed-weather-project"
# }

# # # Power BI
# # Add later