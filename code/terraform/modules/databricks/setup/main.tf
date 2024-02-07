terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "=1.34.0"
    }
  }
}

# Secret Scope
resource "databricks_secret_scope" "db-secret-scope" {
  name = "scope-${var.project_name}"

  keyvault_metadata {
    resource_id = var.secret_kv.id
    dns_name    = var.secret_kv.vault_uri
  }
}

# Directory
resource "databricks_directory" "dbdirectory" {
  path = "/${var.project_name}"
}

# # Jar files
resource "databricks_dbfs_file" "forecast" {
  source = var.forecast_source
  path   = "${databricks_directory.dbdirectory.path}/forecast.jar"
}

resource "databricks_dbfs_file" "realtime" {
  source = var.realtime_source
  path   = "${databricks_directory.dbdirectory.path}/realtime.jar"
}