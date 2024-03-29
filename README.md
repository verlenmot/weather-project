# README

This project aims to integrate the data engineering technologies learned into a deliverable application.
This application is a basic pipeline which retrieves data on weather through an API, processes it, stores it and delivers it to a dashboard.

## Dashboard

[Dashboard](/dashboard.pdf)

## Requirements

- Tomorrow.io REST Weather API key
- Terraform version 1.7.0
- Azure CLI installed
- Azure Cloud Service Principal with Contributor role
- Azure resource group, storage account, storage container with account key for Terraform backend.

## Setup

### Create service principal using terminal (if created skip to create configuration)

`az login`  
`az account set --subscription="${id}`  
`az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/${id}"` 

{  
  "appId": "...",  
  "displayName": "...",  
  "password": "...",  
  "tenant": ".."  
}  

### Create configuration

Fill in the following configuration files (replace ${...} with "value"):  

[Backend configuration](/code/terraform/user-backend.config)  
[Terraform configuration](/code/terraform/user.auto.tfvars)  

client_id = appId  
client_secret = password  
tenant_id = tenant  
subscription_id = id  

### Run application

Run the following commands in terminal:

`cd code/terraform/`  
`terraform init -reconfigure -upgrade -backend-config=user-backend.config`  
`terraform apply`  

Wait 10-15 minutes.  
Login to your Azure portal, open Azure Databricks and view the weather dashboard under all dashboards.  
Job runs can be viewed under workflow.  

**Run `terraform destroy` when you are done viewing the application!**

## Documentation

### Architecture  

The following link contains the architectural documentation.  

[Architecture](/documentation/architecture/architecture.md)

### Time  

Each job takes 3 to 4 minutes to complete.  

A detailed overview of time can be found in the
following documentation.

[Time](/documentation/metrics/time.md)

### Cost  

The total costs of the infrastructure and jobs are
around €2 per hour.

A detailed overview of costs can be found in the
following documentation.

[Cost](/documentation/metrics/cost.md)