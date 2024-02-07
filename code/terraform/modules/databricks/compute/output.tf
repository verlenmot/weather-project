output "warehouse" {
  value = databricks_sql_endpoint.dbwarehouse
}

output "pool_id" {
  value = databricks_instance_pool.dbpool.instance_pool_id
}