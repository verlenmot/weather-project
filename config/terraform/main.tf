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

  subscription_id = var.subscription_id
}

provider "databricks" {
  host = azurerm_databricks_workspace.dbw.workspace_url
}

# Client config to retrieve sensitive values
data "azurerm_client_config" "current" {
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-weather-project"
  location = "westeurope"
  tags = {
    project = "weather"
  }
}

## Budgets
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

resource "azurerm_consumption_budget_resource_group" "bdg-managed" {
  name              = "bdg-managed-weather-project"
  resource_group_id = azurerm_databricks_workspace.dbw.managed_resource_group_id

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

# Storage Accounts & Containers
resource "azurerm_storage_account" "storage-raw" {
  name                      = "stweatherprojectraw"
  location                  = "westeurope"
  resource_group_name       = azurerm_resource_group.rg.name
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "GRS"
  is_hns_enabled            = true
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
  name                      = "stweatherprojectserve"
  location                  = "westeurope"
  resource_group_name       = azurerm_resource_group.rg.name
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "GRS"
  is_hns_enabled            = true
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
## Storage Container Keys

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

data "azurerm_storage_account_blob_container_sas" "sas-serve-forecast" {
  connection_string = azurerm_storage_account.storage-serve.primary_connection_string
  container_name    = azurerm_storage_container.forecast-serve.name

  start  = "2024-01-01T00:00:00+0000"
  expiry = "2024-12-20T00:00:00+0000"


  permissions {
    read   = false
    write  = true  # Overwrite content of an existing blob
    delete = false # Delete blobs
    create = true  # Add new blobs
    list   = true  # List blobs
    add    = true  # Append data to blob
  }
}

data "azurerm_storage_account_blob_container_sas" "sas-serve-realtime" {
  connection_string = azurerm_storage_account.storage-serve.primary_connection_string
  container_name    = azurerm_storage_container.realtime-serve.name

  start  = "2024-01-01T00:00:00+0000"
  expiry = "2024-12-20T00:00:00+0000"


  permissions {
    read   = false
    write  = true  # Overwrite content of an existing blob
    delete = false # Delete blobs
    create = true  # Add new blobs
    list   = true  # List blobs
    add    = true  # Append data to blob
  }
}

# Key vault
resource "azurerm_key_vault" "kv" {
  name                = "kv-weather-project"
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "standard"
  tenant_id           = data.azurerm_client_config.current.tenant_id

  network_acls {
    default_action = "Deny"
    ip_rules       = [var.ip, var.ip2]
    bypass         = "AzureServices"

  }
}
resource "azurerm_key_vault_access_policy" "kv-access-storage" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = ["Get", "Set", "List", "Delete", "Purge"]
}

#$ Secrets
resource "azurerm_key_vault_secret" "secret-sas-raw-forecast" {
  name         = "sas-raw-forecast"
  value        = data.azurerm_storage_account_blob_container_sas.sas-raw-forecast.sas
  key_vault_id = azurerm_key_vault.kv.id
  depends_on   = [azurerm_key_vault_access_policy.kv-access-storage]
}

resource "azurerm_key_vault_secret" "secret-sas-raw-realtime" {
  name         = "sas-raw-realtime"
  value        = data.azurerm_storage_account_blob_container_sas.sas-raw-realtime.sas
  key_vault_id = azurerm_key_vault.kv.id
  depends_on   = [azurerm_key_vault_access_policy.kv-access-storage]
}

resource "azurerm_key_vault_secret" "secret-sas-serve-forecast" {
  name         = "sas-serve-forecast"
  value        = data.azurerm_storage_account_blob_container_sas.sas-serve-forecast.sas
  key_vault_id = azurerm_key_vault.kv.id
  depends_on   = [azurerm_key_vault_access_policy.kv-access-storage]
}

resource "azurerm_key_vault_secret" "secret-sas-serve-realtime" {
  name         = "sas-serve-realtime"
  value        = data.azurerm_storage_account_blob_container_sas.sas-serve-realtime.sas
  key_vault_id = azurerm_key_vault.kv.id
  depends_on   = [azurerm_key_vault_access_policy.kv-access-storage]
}

# Databricks

resource "azurerm_databricks_workspace" "dbw" {
  name                        = "dbw-weather-project"
  location                    = "westeurope"
  resource_group_name         = azurerm_resource_group.rg.name
  sku                         = "premium"
  managed_resource_group_name = "rg-managed-weather-project"
}

## Secret Scope
resource "databricks_secret_scope" "db-secret-scope" {
  name = "secret-scope-weather-project"

  keyvault_metadata {
    resource_id = azurerm_key_vault.kv.id
    dns_name    = azurerm_key_vault.kv.vault_uri
  }

  depends_on = [azurerm_key_vault_access_policy.kv-access-storage]
}

## Development Cluster - Single Node
resource "databricks_cluster" "dbcluster" {
  cluster_name            = "cluster-weather-project"
  spark_version           = "13.3.x-scala2.12"
  node_type_id            = "Standard_D3_v2"
  runtime_engine          = "STANDARD"
  num_workers             = 0
  autotermination_minutes = 10

  spark_conf = {
    "spark.databricks.cluster.profile" : "singleNode"
    "spark.master" : "local[*]"
  }

  custom_tags = {
    "ResourceClass" = "SingleNode"
  }
}

## Development Notebook
resource "databricks_notebook" "dbnotebook" {
  language = "SCALA"
  content_base64 = base64encode(<<-EOT

  EOT
  )
  path = "/Shared/notebook-weather-project.sc"
}


# Power BI - Add later