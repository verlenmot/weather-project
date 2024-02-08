# Architectural Choices

The architecture is described in detail in [Architecture Description](architecture.md).

## Databricks

I opted for the Databricks as it simpler and contains more current technologies.  
The orchestration is limited to Databricks jobs, which also makes it less complex.  
Databricks offer extensibility as it can be easily used for additional analysis.

## VNET Injection

In order for Databricks to work with private storage accounts, I had to inject it into a virtual network.  
I could set my storage account to public access as alternative, but this would reduce security.  

## Cluster pool

I set up a cluster pool so that the jobs run faster each time (as Spark is pre-installed and nodes do not need to start up).  
The first run takes 6 to 9 minutes, while subsequent runs take 3 to 5 minutes.  

## JAR

JAR files are used instead of notebooks as they allow for better data engineering practices.  
In addition, all dependencies are additionally installed so the code runs faster.  

## Dbutils

In order to enhance security, the JAR file retrieves the storage account SAS token, storage account name and the API key from dbutils.secrets.  
By doing this, the secrets do not need to be hardcoded in the JAR or passed as plaintext parameters.  

## Dashboard

I thought about using Power BI, Azure Managed Grafana and Grafana Cloud for dashboards.  
I opted for Azure Databricks Dashboard instead as it is the most simple option and forms a logical next step after processing on Databricks.  
It also pairs well with Terraform.  

## SQL Serverless Warehouse

Although the DBU/hour costs for a serverless warehouse are more expensive than for a classic warehouse,  
the serverless warehouse stops after 1 minute compared to 10 minutes for classic.  
It is also able to spin up within 6 seconds, compared to 5 minutes for the classic warehouse.  
The choice for serverless reduces costs and reduces the latency of the dashboards: processed data can be displayed in near real-time.

## Terraform

The backend configuration is on Azure.  
The data transit goes over the Azure Network instead of the local network, which improves security.  

Authentication to Azure is done through a service principal with variables in auto.tfvars.  
Backend configuration is done with a service principal and a configuration file, so that nothing is hard coded.  

The Terraform resources are grouped into different logical modules in order to enhance adaptability and security.  
