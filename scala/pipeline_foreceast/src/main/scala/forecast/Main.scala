package forecast
import ingestion.ApiRequest


object Main {
  def main(args: Array[String]): Unit = {
    // val apiKey: String = dbutils.secrets.get(scope="scope-weather", key="api") -> Databricks
    // Temporary dev config
    val apiData: Map[String, Any] = ApiRequest.ApiConnectionForecast("amsterdam", devConfig.apiKey)
    println(apiData)
  }
}
