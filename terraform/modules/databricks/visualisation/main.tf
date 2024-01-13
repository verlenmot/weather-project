terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "=1.33.0"
    }
  }
}

resource "databricks_sql_dashboard" "dbdashboard" {
  name   = "dashboard-${var.project_name}"
  parent = "folders/${var.directory.object_id}"
}
