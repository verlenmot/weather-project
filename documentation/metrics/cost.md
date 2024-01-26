# Cost

## Terraform

The Azure backend costs less than €0.01 per day.

## Azure

The storage account and key vault cost less than €0.01 per hour.  

The Azure infrastructure for Databricks costs ~€0.60 per hour.

## Databricks  

The premium Spark jobs compute costs ~€0.15 per hour.  
This is for 5 forecast and 10 realtime tasks.

The premium serverless SQL costs ~€1.30 per hour.  
This is for 15 dashboard refreshes, each with 14 SQL queries.  
As this is the cost driver, optimization should take place here.  