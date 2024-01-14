
terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "=1.33.0"
    }
  }
}


## Secret Scope
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

# # Development Notebook
# resource "databricks_notebook" "dbnotebook" {
#   for_each = var.notebooks
#   language = "SQL"
#   source   = each.value
#   path     = "${databricks_directory.dbdirectory.path}/notebook-${var.project_name}-${each.key}.sql"

#   depends_on = [databricks_directory.dbdirectory]
# }