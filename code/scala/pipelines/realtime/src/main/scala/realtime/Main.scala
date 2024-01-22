package realtime

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
    val flattenedDf = DataframeFlattener.flattenForecastDataframe(enrichedTimeDataframe)

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
