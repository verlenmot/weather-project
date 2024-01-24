package forecast

import ingestion._
import processing._
import archival._

object Main {

  def main(args: Array[String]): Unit = {

    // Ingestion
    val apiData: Map[String, Any] = ApiRequest.ApiConnectionForecast(args(0))

    // Error Handling Step
    ErrorHandler.flow(apiData("statusCode").asInstanceOf[Int])

    // Load Step
    val loadedDataframe = DataframeLoader.loadDataFrame(apiData("data").asInstanceOf[String])

    // Enrichment Step
    val enrichedTimeDataframe = DataframeEnricher.requestTimeAdd(loadedDataframe, apiData("requestDateTime").asInstanceOf[Seq[String]](0))

    // Unpack Step
    val flattenedHourlyDf = DataframeFlattener.flattenDataframe(enrichedTimeDataframe, "hourly")
    val flattenedDailyDf = DataframeFlattener.flattenDataframe(enrichedTimeDataframe, "daily")

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
    completeHourlyDf.write.option("mergeSchema", "true").mode("append").saveAsTable("hourly_forecast")
    completeDailyDf.write.option("mergeSchema", "true").mode("append").saveAsTable("daily_forecast")

  }
}
