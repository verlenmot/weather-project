output "warehouse" {
  description = "Warehouse to be used for job SQL and dashboard tasks"
  value       = databricks_sql_endpoint.dbwarehouse
}

output "pool_id" {
  description = "Instance pool ID to be used for job Spark tasks"
  value       = databricks_instance_pool.dbpool.instance_pool_id
}