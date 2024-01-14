terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "=1.33.0"
    }
  }
}

# Development Cluster - Single Node
resource "databricks_cluster" "dbcluster" {
  cluster_name            = "cluster-${var.project_name}"
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

resource "databricks_library" "dblibrary" {
  for_each = {
    sparksql = "org.apache.spark:spark-sql_2.12:3.4.1"
  }

  cluster_id = databricks_cluster.dbcluster.cluster_id

  maven {
    coordinates = each.value
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


