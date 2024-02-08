# Ingestion package

Purpose: retrieve data from the API, perform exception handling, and ingest it into a Spark DataFrame.

## ApiRequest

### apiConnection

Objective: connect to the API (realtime or forecast) and retrieve necessary data and metadata.

Inputs:  

Location (input as parameter on Databricks Job)

Outputs:  

Map[String, Any] containing:  
JSON String containing API data  
Status Code  
Status Message  
API Request Timestamp

## ExceptionHandler

### handleExceptions

Objective: integrate statusCheck and flow.

Input:  

Status Code  

### statusCheck

Objective: examine status code and decide whether to continue, exit or retry depending on the code.  

Input:  

Status Code  

Output:  

String containing either continue, stop or retry.

### flow

Objective: throw an exception depending on the string (continue, stop, retry) so that the job stops.  

Input:  

String containing either continue, stop or retry.

## DataFrameLoader

### loadDataFrame

Objective: create DataFrame schema and read the JSON string into a DataFrame using this schema.  

Input:  

JSON string  

Output:  

DataFrame
