terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.86.0"
    }
    databricks = {
      source = "databricks/databricks"
      version = "=1.33.0"
    }
  }
}

provider "azurerm" {
  features {

  }
  subscription_id = var.subscription_id
}

provider "databricks" {
  host = azurerm_databricks_workspace.dbw.workspace_url
}

# Resource Group & Budgets to prevent costs
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
    threshold      = 50.0
    contact_emails = [var.alert-email]
  }
}

# resource "azurerm_consumption_budget_resource_group" "bdg-managed" {
#   name              = "bdg-managed-weather-project"
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

# Storage Accounts & Containers
resource "azurerm_storage_account" "storage-raw" {
  name                     = "stweatherprojectraw"
  location                 = "westeurope"
  resource_group_name      = azurerm_resource_group.rg.name
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "GRS"
  is_hns_enabled           = true
  enable_https_traffic_only = true

  network_rules {
    default_action = "Deny"
    ip_rules       = [var.ip, var.ip2]
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
  enable_https_traffic_only = true

  network_rules {
    default_action = "Deny"
    ip_rules       = [var.ip, var.ip2]
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

# # # # Key vault
# # resource "azurerm_key_vault" "keyvault" {
# #   name                = "kv-weather-project"
# #   location            = "westeurope"
# #   resource_group_name = azurerm_resource_group.rg.name
# #   sku_name            = "standard"
# #   tenant_id           = var.tenant_id

# Storage Container Keys

data "azurerm_storage_account_blob_container_sas" "sas-raw-forecast" {
  connection_string = azurerm_storage_account.storage-raw.primary_connection_string
  container_name = azurerm_storage_container.forecast-raw.name

  start = "2024-01-01T00:00:00+0000"
  expiry = "2024-12-20T00:00:00+0000"


  permissions {
    read = true
    write = false # Overwrite content of an existing blob
    delete = false # Delete blobs
    create = true # Add new blobs
    list = true # List blobs
    add = false # Append data to blob
  }
}

data "azurerm_storage_account_blob_container_sas" "sas-raw-realtime" {
  connection_string = azurerm_storage_account.storage-raw.primary_connection_string
  container_name = azurerm_storage_container.realtime-raw.name

  start = "2024-01-01T00:00:00+0000"
  expiry = "2024-12-20T00:00:00+0000"


  permissions {
    read = true
    write = false # Overwrite content of an existing blob
    delete = false # Delete blobs
    create = true # Add new blobs
    list = true # List blobs
    add = false # Append data to blob
  }
}

data "azurerm_storage_account_blob_container_sas" "sas-serve-forecast" {
  connection_string = azurerm_storage_account.storage-serve.primary_connection_string
  container_name = azurerm_storage_container.forecast-serve.name

  start = "2024-01-01T00:00:00+0000"
  expiry = "2024-12-20T00:00:00+0000"


  permissions {
    read = true
    write = false # Overwrite content of an existing blob
    delete = false # Delete blobs
    create = true # Add new blobs
    list = true # List blobs
    add = false # Append data to blob
  }
}

data "azurerm_storage_account_blob_container_sas" "sas-serve-realtime" {
  connection_string = azurerm_storage_account.storage-serve.primary_connection_string
  container_name = azurerm_storage_container.realtime-serve.name

  start = "2024-01-01T00:00:00+0000"
  expiry = "2024-12-20T00:00:00+0000"


  permissions {
    read = true
    write = false # Overwrite content of an existing blob
    delete = false # Delete blobs
    create = true # Add new blobs
    list = true # List blobs
    add = false # Append data to blob
  }
}



# #   network_acls {
# #     default_action = "Deny"
# #     ip_rules = [var.ip, var.ip2]
# #     bypass   = "AzureServices"
    
# #   }
# # }

# # # # # Databricks

# resource "azurerm_databricks_workspace" "dbw" {
#   name                        = "dbw-weather-project"
#   location                    = "westeurope"
#   resource_group_name         = azurerm_resource_group.rg.name
#   sku                         = "standard"
#   managed_resource_group_name = "rg-managed-weather-project"
# }




# ## Development Cluster - Single Node
# resource "databricks_cluster" "dbcluster" {
#   cluster_name = "cluster-weather-project"
#   spark_version = "13.3.x-scala2.12"
#   node_type_id = "Standard_D3_v2"
#   runtime_engine = "STANDARD"
#   num_workers = 0
#   autotermination_minutes = 10
  

#   spark_conf = {
#     "spark.databricks.cluster.profile" : "singleNode"
#     "spark.master" : "local[*]"
#   }

#   custom_tags = {
#     "ResourceClass" = "SingleNode"
#   }
# }

# # ## Development Notebook
# resource "databricks_notebook" "dbnotebook" {
#   language = "SCALA"
#   content_base64 = base64encode(<<-EOT

#   EOT
#   )
#   path = "/Shared/notebook-weather-project.sc"
# }




# # # Power BI
# # Add later