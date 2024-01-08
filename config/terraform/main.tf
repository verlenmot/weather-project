terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.86.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-weather-project"
  location = "West Europe"
  tags = {
    project = "weather"
  }
}


# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-weather-project"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.55.0.0/16"]
}

# Storage Account & Data Lakes

resource "azurerm_storage_account" "storage-raw" {
  name                     = "stweatherprojectraw"
  location                 = "West Europe"
  resource_group_name      = azurerm_resource_group.rg.name
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "GRS"
}
resource "azurerm_storage_account" "storage-serve" {
  name                     = "stweatherprojectserve"
  location                 = "West Europe"
  resource_group_name      = azurerm_resource_group.rg.name
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

