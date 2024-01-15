# Processing package

Purpose: process the Spark Dataframe.

## DataframeEnricher

### requestTimeAdd

Objective: enrich the Datafram with the timestamp (converted) when the API was requested for audit and archival purposes.  

Inputs:  

Dataframe  
Request time from API Response Header

Outputs:  

Dataframe
