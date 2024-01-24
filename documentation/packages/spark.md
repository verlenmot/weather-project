# spark package

Purpose: set up the Spark configuration for the application.  

## sparkProvider

### Description

This trait contains the configuration, SparkSession and SparkContext.  
Access to the storage location is done through a SAS token, which is retrieved from Databricks dbutils.  
