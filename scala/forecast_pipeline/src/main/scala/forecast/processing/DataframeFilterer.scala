package forecast.processing

import org.apache.spark.sql.DataFrame
import org.apache.spark.sql.functions._

object DataframeFilterer {

  def filterHourlyDataframe(df: DataFrame): DataFrame = {
    val filteredDF = df.select("timestamp", "date", "hour", "name", "temperature", "temperatureApparent", "humidity", "cloudCover",
      "precipitationProbability", "rainAccumulation", "rainIntensity", "snowAccumulation", "snowIntensity","visibility",
      "windSpeed", "windGust", "uvIndex", "uvHealthConcern", "weatherCode").na.fill(0)
    filteredDF}

  def filterDailyDataframe(df: DataFrame): DataFrame = {
    val filteredDF = df.select("timestamp", "date", "name", "temperatureMin", "temperatureMax", "temperatureApparentMin",
      "temperatureApparentMax", "humidityMin", "humidityMax", "cloudCoverMin", "cloudCoverMax", "precipitationProbabilityMin",
      "precipitationProbabilityMax", "rainAccumulationMin","rainAccumulationMax", "rainIntensityMin", "rainIntensityMax",
      "snowAccumulationMin", "snowAccumulationMax", "snowIntensityMin", "snowIntensityMax", "visibilityMin", "visibilityMax",
      "windSpeedMin", "windSpeedMax", "windGustMin", "windGustMax","uvIndexMin", "uvIndexMax", "uvHealthConcernMin",
      "uvHealthConcernMax", "weatherCodeMin", "weatherCodeMax", "moonriseTime", "moonsetTime", "sunriseTime", "sunsetTime").na.fill(0)
    filteredDF}

  def timeSplitDaily(df: DataFrame): DataFrame = {
    val timeDF = df.withColumn("date", date_format(col("time"), "yyyy-MM-dd"))
    timeDF}

  def timeSplitHourly(df: DataFrame): DataFrame = {
    val timeDF = df.withColumn("date", date_format(col("time"), "yyyy-MM-dd"))
                  .withColumn("hour", hour(to_timestamp(col("time"))))
    timeDF
  }
}


