terraform {
  required_version = "=1.6.5"
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
      version = "=3.6.0"
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

# Unique instance generator
resource "random_id" "instance" {
  byte_length = 4
}

# Azure
resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.project_name}-${random_id.instance.hex}"
  location = "westeurope"
  tags = {
    project = "weather"
  }
}

module "budget_az" {
  source       = "./modules/azure/budget"
  rg_id        = azurerm_resource_group.rg.id
  alert_email  = var.alert_email
  amount_array = [10, 30]
}

module "storage" {
  source           = "./modules/azure/storage"
  rg_name          = azurerm_resource_group.rg.name
  project_name     = var.project_name
  project_instance = random_id.instance.hex
  ip_exceptions    = var.ip_exceptions
  subnet_ids       = [module.vnet.private_subnet_id, module.vnet.public_subnet_id]
}

module "keyvault" {
  source           = "./modules/azure/keyvault"
  rg_name          = azurerm_resource_group.rg.name
  project_name     = var.project_name
  project_instance = random_id.instance.hex
  ip_exceptions    = var.ip_exceptions
  subnet_ids       = [module.vnet.private_subnet_id, module.vnet.public_subnet_id]

  secrets = {
    sas     = module.storage.sas_storage
    api     = var.api_key
    storage = module.storage.storage_name
  }
}

module "vnet" {
  source           = "./modules/azure/vnet"
  rg_name          = azurerm_resource_group.rg.name
  project_name     = var.project_name
  project_instance = random_id.instance.hex
  subnets          = var.subnets
}

# Databricks 
resource "azurerm_databricks_workspace" "dbw" {
  name                        = "dbw-${var.project_name}-${random_id.instance.hex}"
  resource_group_name         = azurerm_resource_group.rg.name
  location                    = "westeurope"
  sku                         = "premium"
  managed_resource_group_name = "rg-managed-${var.project_name}-${random_id.instance.hex}"

  custom_parameters {
    no_public_ip                                         = true
    virtual_network_id                                   = module.vnet.virtual_network_id
    private_subnet_name                                  = module.vnet.private_subnet_name
    public_subnet_name                                   = module.vnet.public_subnet_name
    public_subnet_network_security_group_association_id  = module.vnet.public_association
    private_subnet_network_security_group_association_id = module.vnet.private_association
  }

  depends_on = [module.vnet]
}

module "budget_db" {
  source       = "./modules/azure/budget"
  rg_id        = azurerm_databricks_workspace.dbw.managed_resource_group_id
  alert_email  = var.alert_email
  amount_array = [10, 30]
}

module "setup" {
  source          = "./modules/databricks/setup"
  project_name    = var.project_name
  secret_kv       = module.keyvault.kv
  forecast_source = var.forecast_source
  realtime_source = var.realtime_source
}

module "compute" {
  source       = "./modules/databricks/compute"
  project_name = var.project_name
}

module "job" {
  source           = "./modules/databricks/job"
  project_name     = var.project_name
  project_instance = random_id.instance.hex
  dev_email        = var.alert_email
  warehouse_id     = module.compute.warehouse.id
  query_map        = module.query.query_map
  pool_id          = module.compute.pool_id
  dashboard_id     = module.visualisation.dashboard_id
  city             = var.city
  depends_on       = [module.setup, module.compute, module.query]
}

module "query" {
  source           = "./modules/databricks/query"
  warehouse_id     = module.compute.warehouse.data_source_id
  workspace_folder = module.setup.directory.object_id

}

module "visualisation" {
  source       = "./modules/databricks/visualisation"
  project_name = var.project_name
  directory    = module.setup.directory
  query_map    = module.query.query_map
  depends_on   = [module.query]
}