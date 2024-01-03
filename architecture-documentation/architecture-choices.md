# Architectural Choices

There were two ways in which I wanted to structure the pipeline.  
The difference resides in the way Spark is used and in the way the pipeline is orchestrated.

![Possible architectures](architecture-ideas.png)

## First Idea

My first idea was to retrieve the data from the API by using Azure Data Factory (using REST connector or Scala code).  
After this, the retrieved data would be processed using a Spark cluster on HDInsight.

## Second Idea

My second idea was to orchestrate everything using Databricks.  
The data processing would take place using a Spark cluster on Databricks.

## Conclusion

I opted for the second architecture, as it simpler and contains more current technologies.  
The orchestration is limited to Databricks jobs, which also makes it less complex.  
Databricks offer extensibility as it can be easily used for extended analysis.

This architecture is described in detail in [Architectural Description](architecture-description.md).
