package forecast.processing

import forecast.sparkConfig
object DataframeFlattener {

  import org.apache.spark.sql.DataFrame
  import org.apache.spark.sql.functions._

  def flattenDataframe(nestedDf: DataFrame, timestep: String): DataFrame = {
    print(nestedDf.first())
    val unpackedDf = nestedDf.selectExpr("location.*", "timelines.*")

    val explodeDf = unpackedDf.select(
      col("lat"),
      col("lon"),
      col("name"),
      col("type"),
      explode(col(timestep)).alias(s"${timestep}Forecast"))

    val reducedDf = explodeDf.selectExpr("*", s"${timestep}Forecast.*").drop(s"${timestep}Forecast")

    val completeDf = reducedDf.selectExpr("*", "values.*").drop("values")
    completeDf
  }
}