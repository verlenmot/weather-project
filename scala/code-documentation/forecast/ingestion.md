# Ingestion package

Purpose: retrieve data from the API, perform error handling, and ingest into a Spark Dataframe.

## ApiRequest (ApiConnectionForecast)

Objective: connect to the API and retrieve data and metadata

Inputs:  

Location: String  
ApiKey: String (from db.utils.get)

Outputs:  

Map[String, Any] containing  
JSON String containing data  
Status Code
Status Message
Request headers containing metadata

## ErrorHandler (StatusCheck)

Objective: examine status code and decide whether to continue, exit or retry.  

Inputs:  

statusCode

Output:  

String containing either continue, stop or retry.

