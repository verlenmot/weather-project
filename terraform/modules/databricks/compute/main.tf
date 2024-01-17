terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "=1.33.0"
    }
  }
}

# Warehouse
resource "databricks_sql_endpoint" "dbwarehouse" {
  name                      = "warehouse-${var.project_name}"
  cluster_size              = "2X-Small"
  min_num_clusters          = 1
  max_num_clusters          = 1
  auto_stop_mins            = 1 # Warehouse stops as fast as possible - Option only through API
  enable_photon             = false
  enable_serverless_compute = true # Enabling this involves complex firewall configuration
  warehouse_type            = "PRO"
}


