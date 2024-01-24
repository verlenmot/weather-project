# Processing package

Purpose: process the Spark Dataframe.

## DataframeEnricher

### requestTimeAdd

Objective: enrich the Dataframe with the timestamp (converted) of when the API was requested for archival and audit purposes.  

Inputs:  

Dataframe  
Request time from API Response Header

Output:  

Dataframe

### weatherFullDayTranslate | weatherDayTranslate | weatherNightTranslate

Objective: translate the weather code into a string containing descriptive information.  

Inputs:  

Weather Code

Output:  

String with weather conditions

### weatherConditionTranslate  

Objective: add the weather condition string to the Dataframe (depending on type of Dataframe).

Input:  

Dataframe  

Output:  

Dataframe

## DataframeFilterer

### filterDataframe

Objective: select the desired columns from the Dataframe.

Input:  

Dataframe  

Output:  

Dataframe

### timeSplit

Objective: split the forecast timestamp into date and hour segments.

Input:  

Dataframe  

Output:  

Dataframe

## DataframeFlattener

Objective: unpack the loaded Dataframe into rows and columns.  

Input:  

Dataframe  

Output:  

Dataframe  
