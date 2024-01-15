package forecast
import ingestion.ApiRequest
import ingestion.errorHandler


object Main {
  def main(args: Array[String]): Unit = {
    // val apiKey: String = dbutils.secrets.get(scope="scope-weather", key="api") -> Databricks
    // Temporary dev config
    val apiData: Map[String, Any] = ApiRequest.ApiConnectionForecast("amsterdam", devConfig.apiKey)
    val nextStep: String = errorHandler.statusCheck(apiData("statusCode").asInstanceOf[Int])
    print(nextStep)
  }
}
