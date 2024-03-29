package forecast.ingestion

import forecast.spark
import org.apache.spark.sql.DataFrame
import org.apache.spark.sql.types._

object DataFrameLoader extends spark.SparkProvider {

  import spark.implicits._

  def loadDataFrame(jsonString: String): DataFrame = {
    val forecastSchema = StructType(
      Seq(
        StructField("timelines", StructType(
          Seq(
            StructField("hourly", ArrayType(StructType(
              Seq(
                StructField("time", TimestampType),
                StructField("values", StructType(
                  Seq(
                    StructField("cloudBase", DoubleType),
                    StructField("cloudCeiling", DoubleType),
                    StructField("cloudCover", DoubleType),
                    StructField("dewPoint", DoubleType),
                    StructField("evapotranspiration", DoubleType),
                    StructField("freezingRainIntensity", DoubleType),
                    StructField("humidity", DoubleType),
                    StructField("iceAccumulation", DoubleType),
                    StructField("iceAccumulationLwe", DoubleType),
                    StructField("precipitationProbability", DoubleType),
                    StructField("pressureSurfaceLevel", DoubleType),
                    StructField("rainAccumulation", DoubleType),
                    StructField("rainAccumulationLwe", DoubleType),
                    StructField("rainIntensity", DoubleType),
                    StructField("sleetAccumulation", DoubleType),
                    StructField("sleetAccumulationLwe", DoubleType),
                    StructField("sleetIntensity", DoubleType),
                    StructField("snowAccumulation", DoubleType),
                    StructField("snowAccumulationLwe", DoubleType),
                    StructField("snowIntensity", DoubleType),
                    StructField("temperature", DoubleType),
                    StructField("temperatureApparent", DoubleType),
                    StructField("uvHealthConcern", DoubleType),
                    StructField("uvIndex", DoubleType),
                    StructField("visibility", DoubleType),
                    StructField("weatherCode", IntegerType),
                    StructField("windDirection", DoubleType),
                    StructField("windGust", DoubleType),
                    StructField("windSpeed", DoubleType)
                  )
                ))
              )
            ))),
            StructField("daily", ArrayType(StructType(
              Seq(
                StructField("time", TimestampType),
                StructField("values", StructType(
                  Seq(
                    StructField("cloudBaseAvg", DoubleType),
                    StructField("cloudBaseMax", DoubleType),
                    StructField("cloudBaseMin", DoubleType),
                    StructField("cloudCeilingAvg", DoubleType),
                    StructField("cloudCeilingMax", DoubleType),
                    StructField("cloudCeilingMin", DoubleType),
                    StructField("cloudCoverAvg", DoubleType),
                    StructField("cloudCoverMax", DoubleType),
                    StructField("cloudCoverMin", DoubleType),
                    StructField("dewPointAvg", DoubleType),
                    StructField("dewPointMax", DoubleType),
                    StructField("dewPointMin", DoubleType),
                    StructField("evapotranspirationAvg", DoubleType),
                    StructField("evapotranspirationMax", DoubleType),
                    StructField("evapotranspirationMin", DoubleType),
                    StructField("evapotranspirationSum", DoubleType),
                    StructField("freezingRainIntensityAvg", DoubleType),
                    StructField("freezingRainIntensityMax", DoubleType),
                    StructField("freezingRainIntensityMin", DoubleType),
                    StructField("humidityAvg", DoubleType),
                    StructField("humidityMax", DoubleType),
                    StructField("humidityMin", DoubleType),
                    StructField("iceAccumulationAvg", DoubleType),
                    StructField("iceAccumulationLweAvg", DoubleType),
                    StructField("iceAccumulationLweMax", DoubleType),
                    StructField("iceAccumulationLweMin", DoubleType),
                    StructField("iceAccumulationLweSum", DoubleType),
                    StructField("iceAccumulationMax", DoubleType),
                    StructField("iceAccumulationMin", DoubleType),
                    StructField("iceAccumulationSum", DoubleType),
                    StructField("moonriseTime", TimestampType),
                    StructField("moonsetTime", TimestampType),
                    StructField("precipitationProbabilityAvg", DoubleType),
                    StructField("precipitationProbabilityMax", DoubleType),
                    StructField("precipitationProbabilityMin", DoubleType),
                    StructField("pressureSurfaceLevelAvg", DoubleType),
                    StructField("pressureSurfaceLevelMax", DoubleType),
                    StructField("pressureSurfaceLevelMin", DoubleType),
                    StructField("rainAccumulationAvg", DoubleType),
                    StructField("rainAccumulationLweAvg", DoubleType),
                    StructField("rainAccumulationLweMax", DoubleType),
                    StructField("rainAccumulationLweMin", DoubleType),
                    StructField("rainAccumulationMax", DoubleType),
                    StructField("rainAccumulationMin", DoubleType),
                    StructField("rainAccumulationSum", DoubleType),
                    StructField("rainIntensityAvg", DoubleType),
                    StructField("rainIntensityMax", DoubleType),
                    StructField("rainIntensityMin", DoubleType),
                    StructField("sleetAccumulationAvg", DoubleType),
                    StructField("sleetAccumulationLweAvg", DoubleType),
                    StructField("sleetAccumulationLweMax", DoubleType),
                    StructField("sleetAccumulationLweMin", DoubleType),
                    StructField("sleetAccumulationLweSum", DoubleType),
                    StructField("sleetAccumulationMax", DoubleType),
                    StructField("sleetAccumulationMin", DoubleType),
                    StructField("sleetIntensityAvg", DoubleType),
                    StructField("sleetIntensityMax", DoubleType),
                    StructField("sleetIntensityMin", DoubleType),
                    StructField("snowAccumulationAvg", DoubleType),
                    StructField("snowAccumulationLweAvg", DoubleType),
                    StructField("snowAccumulationLweMax", DoubleType),
                    StructField("snowAccumulationLweMin", DoubleType),
                    StructField("snowAccumulationLweSum", DoubleType),
                    StructField("snowAccumulationMax", DoubleType),
                    StructField("snowAccumulationMin", DoubleType),
                    StructField("snowAccumulationSum", DoubleType),
                    StructField("snowIntensityAvg", DoubleType),
                    StructField("snowIntensityMax", DoubleType),
                    StructField("snowIntensityMin", DoubleType),
                    StructField("sunriseTime", TimestampType),
                    StructField("sunsetTime", TimestampType),
                    StructField("temperatureApparentAvg", DoubleType),
                    StructField("temperatureApparentMax", DoubleType),
                    StructField("temperatureApparentMin", DoubleType),
                    StructField("temperatureAvg", DoubleType),
                    StructField("temperatureMax", DoubleType),
                    StructField("temperatureMin", DoubleType),
                    StructField("uvHealthConcernAvg", DoubleType),
                    StructField("uvHealthConcernMax", DoubleType),
                    StructField("uvHealthConcernMin", DoubleType),
                    StructField("uvIndexAvg", DoubleType),
                    StructField("uvIndexMax", DoubleType),
                    StructField("uvIndexMin", DoubleType),
                    StructField("visibilityAvg", DoubleType),
                    StructField("visibilityMax", DoubleType),
                    StructField("visibilityMin", DoubleType),
                    StructField("weatherCodeMax", IntegerType),
                    StructField("weatherCodeMin", IntegerType),
                    StructField("windDirectionAvg", DoubleType),
                    StructField("windGustAvg", DoubleType),
                    StructField("windGustMax", DoubleType),
                    StructField("windGustMin", DoubleType),
                    StructField("windSpeedAvg", DoubleType),
                    StructField("windSpeedMax", DoubleType),
                    StructField("windSpeedMin", DoubleType)
                  )
                ))
              )
            ))) ),
        )),
        StructField("location", StructType(
          Seq(
            StructField("lat", DoubleType),
            StructField("lon", DoubleType),
            StructField("name", StringType),
            StructField("type", StringType)
          )
        ))
      )
    )

    val loadedDataFrame: DataFrame = spark.read.schema(forecastSchema).json(Seq(jsonString).toDS)
    loadedDataFrame
  }
}