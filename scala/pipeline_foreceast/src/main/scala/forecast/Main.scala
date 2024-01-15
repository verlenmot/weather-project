package forecast
import ingestion.ApiRequest
import ingestion.ErrorHandler
import ingestion.DataFrameCreator


object Main {
  def main(args: Array[String]): Unit = {
    // val apiKey: String = dbutils.secrets.get(scope="scope-weather", key="api") -> Databricks
    // Temporary dev config
    val apiData: Map[String, Any] = ApiRequest.ApiConnectionForecast("amsterdam", devConfig.apiKey)
//    val apiData: Map[String, Any] = devConfig.testData
//    ErrorHandler.flow(apiData("statusCode").asInstanceOf[Int])

    println(apiData)
//    DataFrameCreator.df.show()
  }
}
