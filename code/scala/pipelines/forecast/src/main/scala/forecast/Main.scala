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
    val loadedDataframe = DataFrameLoader.loadDataFrame(apiData("data").toString)

    // Enrichment - Timestamp
    val timestampDataframe = DataFrameEnricher.addRequestTimestamp(loadedDataframe, apiData("requestDatetime").asInstanceOf[Seq[String]](0))

    // Unpack
    val unpackedHourlyDataFrame = DataFrameUnpacker.unpackDataFrame(timestampDataframe, "hourly")
    val unpackedDailyDataFrame = DataFrameUnpacker.unpackDataFrame(timestampDataframe, "daily")

    // Archival
    DataFrameArchiver.storeDataFrame(unpackedHourlyDataFrame)
    DataFrameArchiver.storeDataFrame(unpackedDailyDataFrame)

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
