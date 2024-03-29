package realtime

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
    val unpackedDataFrame = DataFrameUnpacker.unpackDataFrame(timestampDataFrame)

    // Cache
    val cachedDataFrame = DataFrameCacher.cacheDataFrame(unpackedDataFrame)

    // Archival
    DataFrameArchiver.storeDataFrame(cachedDataFrame)

    // Filter
    val filteredDataFrame = DataFrameFilterer.filterDataFrame(unpackedDataFrame)

    // Enrichment - Weather Conditions
    val completeDataFrame = DataFrameEnricher.addWeatherConditions(filteredDataFrame)

    // Serve
    completeDataFrame.write.option("mergeSchema", "true").mode("append").saveAsTable("realtime")

  }
}
