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


# Client config to retrieve sensitive values
data "azurerm_client_config" "current" {
}

# Random

resource "random_id" "instance" {
  byte_length = 4
}

# # Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.project-name}-${random_id.instance.hex}"
  location = "westeurope"
  tags = {
    project = "weather"
  }
}

# ## Budgets
# resource "azurerm_consumption_budget_resource_group" "bdg-managed" {
#   name              = "bdg-managed-${var.project-name}-${random_id.instance.hex}"
#   resource_group_id = azurerm_databricks_workspace.dbw.managed_resource_group_id

#   amount     = 5
#   time_grain = "Monthly"

#   time_period {
#     start_date = "2024-01-01T00:00:00Z"
#   }

#   notification {
#     enabled        = false
#     operator       = "EqualTo"
#     threshold      = 50.0
#     contact_emails = [var.alert-email]
#   }
# }

module "budget" {
  count = 2
  source      = "./modules/azure/budget"
  rg_id          = azurerm_resource_group.rg.id
  alert_email = var.alert-email
  amount = [10, 30][count.index]
}

# module "budget" {
#   count = 2
#   source      = "./modules/azure/budget"
#   rg_id          = azurerm_databricks_workspace.dbw.managed_resource_group_name.id
#   alert_email = var.alert-email
#   amount = [10, 30][count.index]
# }

# module "storage" {
#   source           = "./modules/azure/storage"
#   rg_name          = azurerm_resource_group.rg.name
#   project_name     = var.project-name
#   project_instance = random_id.instance.hex
#   ip_exceptions    = var.ip_exceptions
# }

# module "keyvault" {
#   source           = "./modules/azure/keyvault"
#   rg_name          = azurerm_resource_group.rg.name
#   project_name     = var.project-name
#   project_instance = random_id.instance.hex
#   ip_exceptions    = var.ip_exceptions
#   sas_keys = {
#     forecast = module.storage.sas_forecast
#     realtime = module.storage.sas_realtime
#   }
# }

# #  Databricks
# resource "azurerm_databricks_workspace" "dbw" {
#   name                        = "dbw-${var.project-name}-${random_id.instance.hex}"
#   location                    = "westeurope"
#   resource_group_name         = azurerm_resource_group.rg.name
#   sku                         = "premium"
#   managed_resource_group_name = "rg-managed-${random_id.instance.hex}"
# }

# resource "databricks_directory" "dbdirectory" {
#   path = "/${var.project-name}-${random_id.instance.hex}"
# }

# ## Secret Scope
# resource "databricks_secret_scope" "db-secret-scope" {
#   name = "scope-${var.project-name}-${random_id.instance.hex}"

#   keyvault_metadata {
#     resource_id = azurerm_key_vault.kv.id
#     dns_name    = azurerm_key_vault.kv.vault_uri
#     #   }
#   }
#   depends_on = [azurerm_key_vault_access_policy.kv-access-storage]
# }

# # Development Cluster - Single Node
# resource "databricks_cluster" "dbcluster" {
#   cluster_name            = "cluster-${var.project-name}-${random_id.instance.hex}"
#   spark_version           = "13.3.x-scala2.12"
#   node_type_id            = "Standard_D3_v2"
#   runtime_engine          = "STANDARD"
#   num_workers             = 0
#   autotermination_minutes = 10

#   spark_conf = {
#     "spark.databricks.cluster.profile" : "singleNode"
#     "spark.master" : "local[*]"
#   }

#   custom_tags = {
#     "ResourceClass" = "SingleNode"
#   }
# }

# # # ## Development Notebook
# resource "databricks_notebook" "dbnotebook" {
#   language = "SCALA"
#   content_base64 = base64encode(<<-EOT

#   EOT
#   )
#   path = "${databricks_directory.dbdirectory.path}/notebook-${var.project-name}-${random_id.instance.hex}.sc"

#   depends_on = [databricks_directory.dbdirectory]
# }

# # Warehouse

# resource "databricks_sql_endpoint" "dbwarehouse" {
#   name                      = "warehouse-${var.project-name}-${random_id.instance.hex}"
#   cluster_size              = "2X-Small"
#   min_num_clusters          = 1
#   max_num_clusters          = 1
#   auto_stop_mins            = 1 # Warehouse stops as fast as possible - Option only through API
#   enable_photon             = false
#   enable_serverless_compute = true # Enabling this involves complex firewall configuration
#   warehouse_type            = "PRO"
# }

# resource "databricks_sql_dashboard" "dbdashboard" {
#   name   = "dashboard-${var.project-name}-${random_id.instance.hex}"
#   parent = "folders/${databricks_directory.dbdirectory.object_id}"
# }
