package realtime.ingestion

import realtime.sparkConfig
import org.apache.spark.sql.DataFrame
import org.apache.spark.sql.types._
object DataframeLoader extends sparkConfig.sparkProvider {

  import spark.implicits._

  def loadDataFrame(jsonString: String): DataFrame = {
    val realtimeSchema = StructType(Seq(
      StructField("data", StructType(Seq(
        StructField("time", StringType),
        StructField("values", StructType(Seq(
          StructField("cloudBase", DoubleType),
          StructField("cloudCeiling", DoubleType),
          StructField("cloudCover", IntegerType),
          StructField("dewPoint", DoubleType),
          StructField("freezingRainIntensity", DoubleType),
          StructField("humidity", IntegerType),
          StructField("precipitationProbability", IntegerType),
          StructField("pressureSurfaceLevel", DoubleType),
          StructField("rainIntensity", DoubleType),
          StructField("sleetIntensity", DoubleType),
          StructField("snowIntensity", DoubleType),
          StructField("temperature", DoubleType),
          StructField("temperatureApparent", DoubleType),
          StructField("uvHealthConcern", IntegerType),
          StructField("uvIndex", IntegerType),
          StructField("visibility", DoubleType),
          StructField("weatherCode", IntegerType),
          StructField("windDirection", DoubleType),
          StructField("windGust", DoubleType),
          StructField("windSpeed", DoubleType)
        )))
      ))),
      StructField("location", StructType(Seq(
        StructField("lat", DoubleType),
        StructField("lon", DoubleType),
        StructField("name", StringType),
        StructField("type", StringType)
      )))
    ))

    val testDF: DataFrame = spark.read.schema(realtimeSchema).json(Seq(jsonString).toDS)
    testDF
  }
}