package forecast

import forecast.processing.DataframeFilterer

import ingestion._
import processing._
import archival._
import com.databricks.dbutils_v1.DBUtilsHolder.dbutils

object Main {

  def main(args: Array[String]): Unit = {

    // Ingestion
    val apiKey: String = dbutils.secrets.get(scope = "scope-weather", key = "api")
    val apiData: Map[String, Any] = ApiRequest.ApiConnectionForecast(args(0), apiKey)

    // Error Handling Step
    ErrorHandler.flow(apiData("statusCode").asInstanceOf[Int])

    // Load Step
    val loadedDataframe = DataframeLoader.loadDataFrame(apiData("data").asInstanceOf[String])

    // Enrichment Step
    val enrichedTimeDataframe = DataframeEnricher.requestTimeAdd(loadedDataframe, apiData("requestDateTime").asInstanceOf[Seq[String]](0))

    // Unpack Step
    val flattenedHourlyDf = DataframeFlattener.flattenForecastDataframe(enrichedTimeDataframe, "hourly")
    val flattenedDailyDf = DataframeFlattener.flattenForecastDataframe(enrichedTimeDataframe, "daily")

    // Archival Step
    DataframeWriter.storeDataframe(flattenedHourlyDf)
    DataframeWriter.storeDataframe(flattenedDailyDf)

    // Enrichment step
    val enrichedHourlyDf = DataframeFilterer.timeSplitHourly(flattenedHourlyDf)
    val enrichedDailyDf = DataframeFilterer.timeSplitDaily(flattenedDailyDf)

    // Filter Step
    val filteredHourlyDf = DataframeFilterer.filterHourlyDataframe(enrichedHourlyDf)
    val filteredDailyDf = DataframeFilterer.filterDailyDataframe(enrichedDailyDf)

    // Enrichment step
    val completeHourlyDf = DataframeEnricher.weatherConditionTranslate(filteredHourlyDf, "hour")
    val completeDailyDf = DataframeEnricher.weatherConditionTranslate(filteredDailyDf, "day")

    // Serve step
    completeHourlyDf.write.option("mergeSchema", "true").mode("append").saveAsTable("hourlyforecast")
    completeDailyDf.write.option("mergeSchema", "true").mode("append").saveAsTable("dailyforecast")

  }
}
