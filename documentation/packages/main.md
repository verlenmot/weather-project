# Main

Purpose: main application which integrates the other packages in a logical order.

[Realtime Main](/code/scala/pipelines/realtime/src/main/scala/realtime/Main.scala)  
[Forecast Main](/code/scala/pipelines/forecast/src/main/scala/forecast/Main.scala)

[Archival Package](/documentation/packages/archival.md)  
[Ingestion Package](/documentation/packages/ingestion.md)  
[Processing Package](/documentation/packages/processing.md)  
[Spark Package](/documentation/packages/spark.md)  

## Steps

1) Retrieve data through an API request.
2) Check the request for errors.
3) Load the data into a DataFrame.
4) Enrich the DataFrame with the API request timestamp.
5) Unpack the DataFrame.
6) Cache the DataFrame.
7) Write the DataFrame to an external storage location.
8) Filter the DataFrame for desired columns.
9) Enrich the forecast DataFrames with the forecast date and hour.
10) Enrich the DataFrame with the weather conditions.
11) Write the DataFrame to the Hive Metastore on Databricks.
