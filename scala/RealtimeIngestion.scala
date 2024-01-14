val apiKey: String = dbutils.secrets.get(scope="scope-weather", key="api")
val location: String = "amsterdam"
val units: String = "metric"

val r: requests.Response = requests.get(s"https://api.tomorrow.io/v4/weather/realtime?location=$location&apikey=$apiKey&units=$units")

println(Response.text)