terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.86.0"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "=1.33.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.6.0"
    }
  }

  backend "azurerm" {
  }
}

# Providers
provider "azurerm" {
  features {
    key_vault {
      purge_soft_deleted_secrets_on_destroy = true
      purge_soft_delete_on_destroy          = true
    }
  }

  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id

}

provider "databricks" {
  host = azurerm_databricks_workspace.dbw.workspace_url

  azure_client_id     = var.client_id
  azure_client_secret = var.client_secret
  azure_tenant_id     = var.tenant_id
}

# Unique instance identifier
resource "random_id" "instance" {
  byte_length = 4
}

# Resource group
resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.project-name}-${random_id.instance.hex}"
  location = "westeurope"
  tags = {
    project = "weather"
  }
}

# Databricks workspace
resource "azurerm_databricks_workspace" "dbw" {
  name                        = "dbw-${var.project-name}-${random_id.instance.hex}"
  location                    = "westeurope"
  resource_group_name         = azurerm_resource_group.rg.name
  sku                         = "premium"
  managed_resource_group_name = "rg-managed-${var.project-name}-${random_id.instance.hex}"
}

# module "budget" {
#   count = 2
#   source      = "./modules/azure/budget"
#   rg_id          = azurerm_resource_group.rg.id
#   alert_email = var.alert-email
#   amount = [10, 30][count.index]
# }

# module "budget" {
#   count = 2
#   source      = "./modules/azure/budget"
#   rg_id          = azurerm_databricks_workspace.dbw.managed_resource_group_name.id
#   alert_email = var.alert-email
#   amount = [10, 30][count.index]
# }

module "storage" {
  source           = "./modules/azure/storage"
  rg_name          = azurerm_resource_group.rg.name
  project_name     = var.project-name
  project_instance = random_id.instance.hex
  ip_exceptions    = var.ip_exceptions
}

module "keyvault" {
  source           = "./modules/azure/keyvault"
  rg_name          = azurerm_resource_group.rg.name
  project_name     = var.project-name
  project_instance = random_id.instance.hex
  ip_exceptions    = var.ip_exceptions
  sas_keys = {
    forecast = module.storage.sas_forecast
    realtime = module.storage.sas_realtime
  }
}

module "setup" {
  source       = "./modules/databricks/setup"
  project_name = var.project-name
  secret_kv    = module.keyvault.kv
}

module "compute" {
  source       = "./modules/databricks/compute"
  project_name = var.project-name
}