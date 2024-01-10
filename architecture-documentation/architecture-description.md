# Architecture Description

![Architecture Diagram](architecture-diagram.png)

## API

The API, Tomorrow.io responds with JSON format using REST API format.  
For forecast data, the API is called every hour.  
For real-time data, the API is called every 10 minutes.

[API documentation](API-documentation.md)

## Azure Data Lake Storage Gen 2  

The raw data will be ingested into an Azure Data Lake, both for processing and for archival.  
The files will be stored as Parquet format.  
The forecast data and real-time data will be kept in separate directories.  
The processed data is stored in a separate Azure Data Lake.  

## Spark on Databricks

Spark clusters on Databricks are used to process the data.
Although the API data is low volume, this application has scalability in mind.  
The processing part should be able to handle a lot of different API calls.

Databricks runtime 13.3 LTS, standard
Spark Version 3.4.1
Development cluster: Single node Standard_DS3_v2

## Scala code

Scala code is written for API data retrieval and for Spark processing.  
Scala version 2.12

## Orchestration

To retrieve data from the API and to process data, jobs are used.  

## Power BI

The dashboard will be delivered through Power BI.  

## Azure Key Vault

Azure Key Vault is used to contain the secret scope for Databricks.

## Azure Network Rules

The Azure Storage Accounts and Azure Key Vault have network rules that deny all access unless it comes from trusted Microsoft Services.

## Terraform

The infrastructure for the application is automatically created with Terraform.  
While developing, the backend is local.
The final backend configuration will be azurerm, this ensures security of infrastructure.

## Docker

The application is delivered as a Dockerfile.  
In this way, complexity of trying out the application is kept to a minimum.
