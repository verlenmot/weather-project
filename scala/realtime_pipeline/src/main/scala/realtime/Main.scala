package realtime

object Main {
  import realtime.processing
  import ingestion.ApiRequest
  import ingestion.ErrorHandler
  import ingestion.DataframeLoader
  import processing.DataframeEnricher
  import processing.DataframeFlattener
  import com.databricks.dbutils_v1.DBUtilsHolder.dbutils
  import sparkConfig.devConfig
  import archival.DataframeWriter
  import processing.DataframeFilterer._

  def main(args: Array[String]): Unit = {

    // Ingestion
//    val apiKey: String = dbutils.secrets.get(scope = "scope-weather", key = "api") // Production
//    val apiData: Map[String, Any] = ApiRequest.ApiConnectionForecast("amsterdam", "A9IWzOhQMfWn9M2iPvnWQCDhs2lwvAuf") // Production
    val apiData: Map[String, Any] = devConfig.mockData

    // Error Handling Step
    ErrorHandler.flow(apiData("statusCode").asInstanceOf[Int])

//    // Load Step
    val loadedDataframe = DataframeLoader.loadDataFrame(apiData("data").asInstanceOf[String])
    loadedDataframe.show()

    // Enrichment Step
    val enrichedTimeDataframe = DataframeEnricher.requestTimeAdd(loadedDataframe, apiData("requestDateTime").asInstanceOf[Seq[String]](0))
    enrichedTimeDataframe.show()

    // Unpack Step
    val flattenedDf = DataframeFlattener.flattenForecastDataframe(enrichedTimeDataframe)

    // Archival Step
    DataframeWriter.storeDataframe(flattenedDf)
//
    // Filter Step
    val filteredDf = filterDataframe(flattenedDf)
//
    // Enrichment step
    val completeDf = DataframeEnricher.weatherConditionTranslate(filteredDf, "hour")
    completeDf.show()
  }
}
