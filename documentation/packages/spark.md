# Spark package

Purpose: set up the Spark configuration for the application.  

## SparkProvider

### Description

This trait contains the Spark configuration, SparkSession and SparkContext.  
Access to the storage location is configured with a SAS token, which is retrieved from Databricks dbutils.  
