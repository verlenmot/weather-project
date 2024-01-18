# Ingestion package

Purpose: retrieve data from the API, perform error handling, and ingest into a Spark Dataframe.

## ApiRequest

### ApiConnectionForecast

Objective: connect to the forecast API and retrieve necessary data and metadata

Inputs:  

Location: String  
ApiKey: String (from db.utils.get)

Outputs:  

Map[String, Any] containing  
JSON String containing forecast data  
Status Code
Status Message
API Request Timestamp

## ErrorHandler

### statusCheck

Objective: examine status code and decide whether to continue, exit or retry depending on the code.  

Inputs:  

statusCode

Output:  

String containing either continue, stop or retry.

### exceptionHandler

Objective: throw an exception depending on the string (continue, stop, retry), so that the job stops.  

Inputs:  

String containing either continue, stop or retry.  

Output:  

None  