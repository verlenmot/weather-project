package forecast

import ingestion._
import processing._
import archival._

object Main {

  def main(args: Array[String]): Unit = {

    // Ingestion
    val apiData: Map[String, Any] = ApiRequest.apiConnection(args(0))

    // Error Handling
    ExceptionHandler.handleExceptions(apiData("statusCode").asInstanceOf[Int])

    // Load
    val loadedDataFrame = DataFrameLoader.loadDataFrame(apiData("data").toString)

    // Enrichment - Timestamp
    val timestampDataFrame = DataFrameEnricher.addRequestTimestamp(loadedDataFrame, apiData("requestDatetime").asInstanceOf[Seq[String]].head)

    // Unpack
    val unpackedHourlyDataFrame = DataFrameUnpacker.unpackDataFrame(timestampDataFrame, "hourly")
    val unpackedDailyDataFrame = DataFrameUnpacker.unpackDataFrame(timestampDataFrame, "daily")

    // Cache
    val cachedHourlyDataFrame = DataFrameCacher.cacheDataFrame(unpackedHourlyDataFrame)
    val cachedDailyDataFrame = DataFrameCacher.cacheDataFrame(unpackedDailyDataFrame)

    // Archival
    DataFrameArchiver.storeDataFrame(cachedHourlyDataFrame)
    DataFrameArchiver.storeDataFrame(cachedDailyDataFrame)

    // Filter
    val filteredHourlyDataFrame = DataFrameFilterer.filterHourlyDataFrame(unpackedHourlyDataFrame)
    val filteredDailyDataFrame = DataFrameFilterer.filterDailyDataFrame(unpackedDailyDataFrame)

    // Enrichment - Forecast Day & Hour
    val enrichedHourlyDataFrame = DataFrameEnricher.addForecastDayAndHour(filteredHourlyDataFrame)
    val enrichedDailyDataFrame = DataFrameEnricher.addForecastDay(filteredDailyDataFrame)

    // Enrichment - Weather Conditions
    val completeHourlyDataFrame = DataFrameEnricher.addWeatherConditions(enrichedHourlyDataFrame, "hour")
    val completeDailyDataFrame = DataFrameEnricher.addWeatherConditions(enrichedDailyDataFrame, "day")

    // Serve
    completeHourlyDataFrame.write.option("mergeSchema", "true").mode("append").saveAsTable("hourly_forecast")
    completeDailyDataFrame.write.option("mergeSchema", "true").mode("append").saveAsTable("daily_forecast")

  }
}
