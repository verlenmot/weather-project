package forecast.processing

import org.apache.spark.sql.DataFrame
import org.apache.spark.sql.functions._

object DataframeFlattener {

  def flattenDataframe(nestedDf: DataFrame, timestep: String): DataFrame = {
    val unpackedDf = nestedDf.selectExpr("timestamp","location.*", "timelines.*")

    val explodeDf = unpackedDf.select(
      col("timestamp"),
      col("lat"),
      col("lon"),
      col("name"),
      col("type"),
      lit(timestep).alias("timestep"),
      explode(col(timestep)).alias(s"${timestep}Forecast"))

    val reducedDf = explodeDf.selectExpr("*", s"${timestep}Forecast.*").drop(s"${timestep}Forecast")

    val completeDf = reducedDf.selectExpr("*", "values.*").drop("values")

    completeDf
  }
}