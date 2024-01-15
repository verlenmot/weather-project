# Ingestion package

Purpose: retrieve data from the API, perform validation, and ingest into a Spark Dataframe

## ApiConnectionForecast

Objective: connect to the API and retrieve data and metadata

Inputs:  

Location: String  
ApiKey: String (from db.utils.get)
Mode: String (forecast or realtime)

Outputs:  

Map[String, Any] containing  
JSON String containing data  
Status Code
Status Message
Request headers containing metadata

## Validation  

Objective: examine status code and decide whether to continue, exit or retry.  
