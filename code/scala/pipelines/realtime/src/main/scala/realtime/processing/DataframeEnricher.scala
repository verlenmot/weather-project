package realtime.processing

import org.apache.spark.sql.DataFrame
import org.apache.spark.sql.functions._

object DataframeEnricher {

  def requestTimeAdd(dataFrame: DataFrame, requestTime: String): DataFrame = {
    val adjustedTime: String = requestTime.drop(5)
    val enrichedDataFrame: DataFrame = dataFrame.withColumn("timestamp", to_timestamp(lit(adjustedTime), "dd MMM yyyy HH:mm:ss z"))
    enrichedDataFrame
  }

  def weatherFullDayTranslate(codeValue: String): String = {
    codeValue match {
      case "0" => "unknown"
      case "1000" => "Clear, Sunny"
      case "1100" => "Mostly Clear"
      case "1101" => "Partly Cloudy"
      case "1102" => "Mostly Cloudy"
      case "1001" => "Cloudy"
      case "1103" => "Partly Cloudy and Mostly Clear"
      case "2100" => "Light Fog"
      case "2101" => "Mostly Clear and Light Fog"
      case "2102" => "Partly Cloudy and Light Fog"
      case "2103" => "Mostly Cloudy and Light Fog"
      case "2106" => "Mostly Clear and Fog"
      case "2107" => "Partly Cloudy and Fog"
      case "2108" => "Mostly Cloudy and Fog"
      case "2000" => "Fog"
      case "4204" => "Partly Cloudy and Drizzle"
      case "4203" => "Mostly Clear and Drizzle"
      case "4205" => "Mostly Cloudy and Drizzle"
      case "4000" => "Drizzle"
      case "4200" => "Light Rain"
      case "4213" => "Mostly Clear and Light Rain"
      case "4214" => "Partly Cloudy and Light Rain"
      case "4215" => "Mostly Cloudy and Light Rain"
      case "4209" => "Mostly Clear and Rain"
      case "4208" => "Partly Cloudy and Rain"
      case "4210" => "Mostly Cloudy and Rain"
      case "4001" => "Rain"
      case "4211" => "Mostly Clear and Heavy Rain"
      case "4202" => "Partly Cloudy and Heavy Rain"
      case "4212" => "Mostly Cloudy and Heavy Rain"
      case "4201" => "Heavy Rain"
      case "5115" => "Mostly Clear and Flurries"
      case "5116" => "Partly Cloudy and Flurries"
      case "5117" => "Mostly Cloudy and Flurries"
      case "5001" => "Flurries"
      case "5100" => "Light Snow"
      case "5102" => "Mostly Clear and Light Snow"
      case "5103" => "Partly Cloudy and Light Snow"
      case "5104" => "Mostly Cloudy and Light Snow"
      case "5122" => "Drizzle and Light Snow"
      case "5105" => "Mostly Clear and Snow"
      case "5106" => "Partly Cloudy and Snow"
      case "5107" => "Mostly Cloudy and Snow"
      case "5000" => "Snow"
      case "5101" => "Heavy Snow"
      case "5119" => "Mostly Clear and Heavy Snow"
      case "5120" => "Partly Cloudy and Heavy Snow"
      case "5121" => "Mostly Cloudy and Heavy Snow"
      case "5110" => "Drizzle and Snow"
      case "5108" => "Rain and Snow"
      case "5114" => "Snow and Freezing Rain"
      case "5112" => "Snow and Ice Pellets"
      case "6000" => "Freezing Drizzle"
      case "6003" => "Mostly Clear and Freezing drizzle"
      case "6002" => "Partly Cloudy and Freezing drizzle"
      case "6004" => "Mostly Cloudy and Freezing drizzle"
      case "6204" => "Drizzle and Freezing Drizzle"
      case "6206" => "Light Rain and Freezing Drizzle"
      case "6205" => "Mostly Clear and Light Freezing Rain"
      case "6203" => "Partly Cloudy and Light Freezing Rain"
      case "6209" => "Mostly Cloudy and Light Freezing Rain"
      case "6200" => "Light Freezing Rain"
      case "6213" => "Mostly Clear and Freezing Rain"
      case "6214" => "Partly Cloudy and Freezing Rain"
      case "6215" => "Mostly Cloudy and Freezing Rain"
      case "6001" => "Freezing Rain"
      case "6212" => "Drizzle and Freezing Rain"
      case "6220" => "Light Rain and Freezing Rain"
      case "6222" => "Rain and Freezing Rain"
      case "6207" => "Mostly Clear and Heavy Freezing Rain"
      case "6202" => "Partly Cloudy and Heavy Freezing Rain"
      case "6208" => "Mostly Cloudy and Heavy Freezing Rain"
      case "6201" => "Heavy Freezing Rain"
      case "7110" => "Mostly Clear and Light Ice Pellets"
      case "7111" => "Partly Cloudy and Light Ice Pellets"
      case "7112" => "Mostly Cloudy and Light Ice Pellets"
      case "7102" => "Light Ice Pellets"
      case "7108" => "Mostly Clear and Ice Pellets"
      case "7107" => "Partly Cloudy and Ice Pellets"
      case "7109" => "Mostly Cloudy and Ice Pellets"
      case "7000" => "Ice Pellets"
      case "7105" => "Drizzle and Ice Pellets"
      case "7106" => "Freezing Rain and Ice Pellets"
      case "7115" => "Light Rain and Ice Pellets"
      case "7117" => "Rain and Ice Pellets"
      case "7103" => "Freezing Rain and Heavy Ice Pellets"
      case "7113" => "Mostly Clear and Heavy Ice Pellets"
      case "7114" => "Partly Cloudy and Heavy Ice Pellets"
      case "7116" => "Mostly Cloudy and Heavy Ice Pellets"
      case "7101" => "Heavy Ice Pellets"
      case "8001" => "Mostly Clear and Thunderstorm"
      case "8003" => "Partly Cloudy and Thunderstorm"
      case "8002" => "Mostly Cloudy and Thunderstorm"
      case "8000" => "Thunderstorm"
    }
  }

  val codeFullDayUDF = udf(weatherFullDayTranslate _)

  def weatherConditionTranslate(df: DataFrame, codeType: String): DataFrame = {
    codeType match {
      case "hour" => df.withColumn("weatherCondition", codeFullDayUDF(col("weatherCode")))
      case "day" => df.withColumn("weatherConditionMin", codeFullDayUDF(col("weatherCodeMin"))).
        withColumn("weatherConditionMax", codeFullDayUDF(col("weatherCodeMax")))
    }
  }
}