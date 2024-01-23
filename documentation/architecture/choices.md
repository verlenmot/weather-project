
## Choice  

I opted for the Databricks as it simpler and contains more current technologies.  
The orchestration is limited to Databricks jobs, which also makes it less complex.  
Databricks offer extensibility as it can be easily used for extended analysis.

This architecture is described in detail in [Architectural Description](architecture.md).

## Authentication

For now, authentication to Azure is done through az login.  
This will be changed to service principal in the final application.

## Networking Discussion

I first created a virtual network and subnets which I connected with private endpoints to account storage and key vault.  
As I ran into issues with Terraform, I changed the private endpoints to service endpoints, with network rules on the services allowing the subnet.  
This resulted in different issues, which I solved by adding my client IP to the allowed IP list.  
  
However, this setup became complex when adding a Databricks workspace and trying to connect it to the virtual network.  
Two options I tried were VNET peering and VNET injection, but these were unnecessary.  
  
I decided to remove the virtual network, subnets and service endpoints; I replaced these with adding "AzureServices" to the Bypass in network rules.  
This way, the Storage and Key Vault services are only accessible with my client IP and Azure Databricks, without having to set up a special private network.  
In the final application the IP rule will be removed, so that the application is more secure.  

## Dashboard

I thought about using Power BI, Azure Managed Grafana and Grafana Cloud for dashboards.  
I opted for Azure Databricks Dashboards as it is the least complex option and pairs well with Terraform.  

Although the DBU/hour costs are more expensive than a classic warehouse, the serverless warehouse stops after 1 minute compared to 10 minutes for classic.  
It is also able to spin up within 6 seconds, compared to 5 minutes for the classic warehouse.  
This reduces costs and reduces the latency of the dashboards: processed data can be served in near real-time.