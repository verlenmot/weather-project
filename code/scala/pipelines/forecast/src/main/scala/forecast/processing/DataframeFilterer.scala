package forecast.processing

import org.apache.spark.sql.DataFrame

object DataFrameFilterer {

  def filterHourlyDataFrame(dataFrame: DataFrame): DataFrame = {
    val filteredDataFrame = dataFrame.select("timestamp", "name", "time", "temperature", "temperatureApparent", "humidity", "cloudCover",
      "precipitationProbability", "rainAccumulation", "rainIntensity", "snowAccumulation", "snowIntensity","visibility",
      "windSpeed", "windGust", "uvIndex", "uvHealthConcern", "weatherCode").na.fill(0)
    filteredDataFrame
  }

  def filterDailyDataFrame(dataFrame: DataFrame): DataFrame = {
    val filteredDataFrame = dataFrame.select("timestamp", "name", "time", "temperatureMin", "temperatureMax", "temperatureApparentMin",
      "temperatureApparentMax", "humidityMin", "humidityMax", "cloudCoverMin", "cloudCoverMax", "precipitationProbabilityMin",
      "precipitationProbabilityMax", "rainAccumulationMin","rainAccumulationMax", "rainIntensityMin", "rainIntensityMax",
      "snowAccumulationMin", "snowAccumulationMax", "snowIntensityMin", "snowIntensityMax", "visibilityMin", "visibilityMax",
      "windSpeedMin", "windSpeedMax", "windGustMin", "windGustMax","uvIndexMin", "uvIndexMax", "uvHealthConcernMin",
      "uvHealthConcernMax", "weatherCodeMin", "weatherCodeMax", "moonriseTime", "moonsetTime", "sunriseTime", "sunsetTime").na.fill(0)
    filteredDataFrame
  }
}


