package realtime.processing

import org.apache.spark.sql.DataFrame

object DataFrameFilterer {

  def filterDataFrame(df: DataFrame): DataFrame = {
    val filteredDataFrame = df.select("timestamp", "name", "temperature", "temperatureApparent", "humidity", "cloudCover",
      "precipitationProbability", "rainIntensity", "snowIntensity","visibility",
      "windSpeed", "windGust", "uvIndex", "uvHealthConcern", "weatherCode").na.fill(0)
    filteredDataFrame
  }
}


