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
  subnet_ids = [azurerm_subnet.public.id, azurerm_subnet.private.id]
}

module "keyvault" {
  source           = "./modules/azure/keyvault"
  rg_name          = azurerm_resource_group.rg.name
  project_name     = var.project_name
  project_instance = random_id.instance.hex
  ip_exceptions    = var.ip_exceptions
  subnet_ids = [azurerm_subnet.public.id, azurerm_subnet.private.id]
  
  secrets = {
    sas = module.storage.sas_storage
    api      = var.api_key
  }
}

# # Databricks 

# Virtual Network

# resource "azurerm_subnet" "snet" {
#   name                 = "snet-weather-project-main"
#   resource_group_name  = azurerm_resource_group.rg.name
#   virtual_network_name = azurerm_virtual_network.vnet.name
#   address_prefixes     = ["10.0.0.0/24"]
#   service_endpoints    = ["Microsoft.KeyVault", "Microsoft.Storage"]
# }

resource "azurerm_network_security_group" "this" {
  name                = "nsg-weather-project"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "westeurope"
}

#####
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-weather-project"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}


resource "azurerm_subnet" "public" {
  name                 = "snet-public"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]
  service_endpoints    = ["Microsoft.KeyVault", "Microsoft.Storage"]

  delegation {
    name = "databricks"
    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
      "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"]
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "public" {
  subnet_id                 = azurerm_subnet.public.id
  network_security_group_id = azurerm_network_security_group.this.id
}

resource "azurerm_subnet" "private" {
  name                 = "snet-private"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
  service_endpoints    = ["Microsoft.KeyVault", "Microsoft.Storage"]


  delegation {
    name = "databricks"
    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
      "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"]
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "private" {
  subnet_id                 = azurerm_subnet.private.id
  network_security_group_id = azurerm_network_security_group.this.id
}

###

resource "azurerm_databricks_workspace" "dbw" {
  name                = "dbw-${var.project_name}-${random_id.instance.hex}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "westeurope"
  sku                 = "premium"
  managed_resource_group_name = "rg-managed-${var.project_name}-${random_id.instance.hex}"

  custom_parameters {
    no_public_ip                                         = true
    virtual_network_id                                   = azurerm_virtual_network.vnet.id
    private_subnet_name                                  = azurerm_subnet.private.name
    public_subnet_name                                   = azurerm_subnet.public.name
    public_subnet_network_security_group_association_id  = azurerm_subnet_network_security_group_association.public.id
    private_subnet_network_security_group_association_id = azurerm_subnet_network_security_group_association.private.id
  }

  depends_on = [
    azurerm_subnet_network_security_group_association.public,
    azurerm_subnet_network_security_group_association.private
  ]
}


# module "budget_db" {
#   source       = "./modules/azure/budget"
#   rg_id        = azurerm_databricks_workspace.dbw.managed_resource_group_id
#   alert_email  = var.alert_email
#   amount_array = [10, 30]
# }

module "setup" {
  source       = "./modules/databricks/setup"
  project_name = var.project_name
  secret_kv    = module.keyvault.kv
  # notebooks = {
  #   development         = """
  # }
}

module "compute" {
  source       = "./modules/databricks/compute"
  project_name = var.project_name
}

# module "visualisation" {
#   source       = "./modules/databricks/visualisation"
#   project_name = var.project_name
#   directory    = module.setup.directory
# }