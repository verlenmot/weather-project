package realtime.processing

import org.apache.spark.sql.DataFrame

object DataframeFilterer {
  def filterDataframe(df: DataFrame): DataFrame = {
    val filteredDF = df.select("timestamp", "name", "temperature", "temperatureApparent", "humidity", "cloudCover",
      "precipitationProbability", "rainIntensity", "snowIntensity","visibility",
      "windSpeed", "windGust", "uvIndex", "uvHealthConcern", "weatherCode").na.fill(0)
    filteredDF}
}


