# Main

Purpose: main application which integrates the other packages in a logical order.  

## Steps

1) Retrieve data through an API request.
2) Check the request for errors.
3) Load the data into a Dataframe.
4) Enrich the Dataframe with the API request timestamp.
5) Unpack the Dataframe.
6) Write the Dataframe to an external storage location.
7) Add forecast date and hour columns for the forecast Dataframes.
8) Filter the Dataframe for desired columns.
9) Add the description of weather conditions to the Dataframe.
10) Write the Dataframe to the Hive metastore on Databricks.
