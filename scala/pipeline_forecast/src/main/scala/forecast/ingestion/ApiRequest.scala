package forecast.ingestion

object ApiRequest {
  def ApiConnectionForecast(location: String, apiKey: String): Map[String, Any] = {
    val paramMap: Map[String, String] = Map(
      "location" -> location,
      "apikey" -> apiKey,
      "units" -> "metric",
      "timesteps" -> "1d"
    )

    val r: requests.Response = requests.get("https://api.tomorrow.io/v4/weather/forecast", params = paramMap)
    val text: String = r.text()
    val statusCode: Int = r.statusCode
    val statusMessage: String = r.statusMessage
    val headers: Map[String, Seq[String]] = r.headers

    val ApiOutput: Map[String, Any] = Map(
      "statusCode" -> statusCode,
      "statusMessage" -> statusMessage,
      "data" -> text,
      "requestDateTime" -> headers("date")
    )
    
    ApiOutput
  }

}
