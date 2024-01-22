package realtime

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
    val flattenedDf = DataframeFlattener.flattenDataframe(enrichedTimeDataframe)

    // Archival Step
    DataframeWriter.storeDataframe(flattenedDf)

    // Filter Step
    val filteredDf = DataframeFilterer.filterDataframe(flattenedDf)

    // Enrichment step
    val completeDf = DataframeEnricher.weatherConditionTranslate(filteredDf, "hour")

    // Serve step
    completeDf.write.option("mergeSchema", "true").mode("append").saveAsTable("realtime")

  }
}
