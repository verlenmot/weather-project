val apiKey: String = dbutils.secrets.get(scope="scope-weather", key="api")
val location: String = "amsterdam"
val units: String = "metric"
val timesteps: String = "1d"

val r: requests.Response = requests.get(s"https://api.tomorrow.io/v4/weather/forecast?location=$location&apikey=$apiKey&units=$units&timesteps=$timesteps")

println(r.text)