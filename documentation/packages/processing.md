# Processing package

Purpose: process the Spark DataFrame.

## DataFrameCacher

### cacheDataFrame

Objective: cache the DataFrame before a Spark action.  

Inputs:  

DataFrame  

Output:  

DataFrame

## DataFrameEnricher

### addRequestTimestamp

Objective: enrich the Dataframe with the reformatted timestamp of when the API was requested.  

Inputs:  

DataFrame  
Request time from the API Response Header

Output:  

DataFrame

### addForecastDate

Objective: enrich the DataFrame with the forecast date.

Input:  

DataFrame  

Output:  

DataFrame

### addForecastDateAndHour

Objective: enrich the DataFrame with the forecast date and forecast hours.

Input:  

DataFrame  

Output:  

DataFrame

### translateWeatherCode (transformed into UDF)

Objective: translate the weather code into a string containing descriptive information.  

Inputs:  

Weather code

Output:  

String with weather conditions

### addWeatherConditions

Objective: enrich the DataFrame with the weather conditions (depending on pipeline).

Input:  

DataFrame  

Output:  

DataFrame

## DataFrameFilterer

### filterDataFrame

Objective: select the desired columns from the DataFrame.

Input:  

DataFrame  

Output:  

DataFrame

## DataFrameUnpacker

### unpackDataFrame

Objective: unpack the DataFrame into rows and columns.  

Input:  

DataFrame  

Output:  

DataFrame  
