terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "=1.34.0"
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


# Cluster pool 
resource "databricks_instance_pool" "dbpool" {
  instance_pool_name                    = "Weather pool"
  min_idle_instances                    = 0
  max_capacity                          = 3
  node_type_id                          = "Standard_D3_v2"
  idle_instance_autotermination_minutes = 15
  preloaded_spark_versions              = ["13.3.x-scala2.12"]
  azure_attributes {
    spot_bid_max_price = -1
  }
}