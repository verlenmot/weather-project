package realtime.processing

object DataframeFilterer {

  import org.apache.spark.sql.DataFrame
  import org.apache.spark.sql.functions._

  def filterDataframe(df: DataFrame): DataFrame = {
    val filteredDF = df.select("request_timestamp", "name", "temperature", "temperatureApparent", "humidity", "cloudCover",
      "precipitationProbability", "rainIntensity", "snowIntensity","visibility",
      "windSpeed", "windGust", "uvIndex", "uvHealthConcern", "weatherCode")
    filteredDF}

}


