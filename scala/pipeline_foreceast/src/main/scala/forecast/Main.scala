package forecast

import forecast.processing.DataframeFlattener
import ingestion.ApiRequest
import ingestion.ErrorHandler
import ingestion.DataframeLoader
import processing.DataframeEnricher


object Main {
  def main(args: Array[String]): Unit = {
    // Ingestion

    // val apiKey: String = dbutils.secrets.get(scope="scope-weather", key="api") -> Databricks
    // Temporary dev config
//    val apiData: Map[String, Any] = ApiRequest.ApiConnectionForecast("amsterdam", devConfig.apiKey)
    val apiData: Map[String, Any] = devConfig.mockData
//    ErrorHandler.flow(apiData("statusCode").asInstanceOf[Int])
    val nestedDataframe = DataframeLoader.loadDataFrame(apiData("data").asInstanceOf[String])

    // Process Step - Enrichment
    val enrichedTimeDataframe = DataframeEnricher.requestTimeAdd(nestedDataframe, apiData("requestDateTime").asInstanceOf[Seq[String]](0))

    enrichedTimeDataframe.show()

  }
}
