# Ingestion package

Purpose: retrieve data from the API, perform error handling, and ingest it into a Spark Dataframe.

## ApiRequest

### ApiConnectionForecast

Objective: connect to the forecast API and retrieve necessary data and metadata.

Inputs:  

Location (input as parameter on Databricks Job)

Outputs:  

Map[String, Any] containing  
JSON String containing forecast data  
Status Code  
Status Message  
API Request Timestamp

## ErrorHandler

### flow

Objective: integrate statusCheck and exceptionHandler.

Input:  

Status Code  

### statusCheck

Objective: examine status code and decide whether to continue, exit or retry depending on the code.  

Input:  

Status Code  

Output:  

String containing either continue, stop or retry.

### exceptionHandler

Objective: throw an exception depending on the string (continue, stop, retry) so that the job stops.  

Input:  

String containing either continue, stop or retry.

## DataFrameLoader

### loadDataFrame

Objective: create Dataframe schema and read the JSON string into a Dataframe using this schema.  

Input:  

JSON string  

Output:  

Dataframe
