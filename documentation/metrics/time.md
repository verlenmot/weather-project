# Time

## Terraform

Terraform apply: 7 minutes  
Terraform destroy: 6 minutes

Bottlenecks: Azure Key Vault & Databricks Workspace

## Databricks

First job runs  
Realtime: ~6-7 minutes  
Forecast: ~9-10 minutes

Subsquent job runs  
Realtime: ~3-4 minutes  
Forecast: ~3-4 minutes

Bottlenecks: initialization of clusters during first run
