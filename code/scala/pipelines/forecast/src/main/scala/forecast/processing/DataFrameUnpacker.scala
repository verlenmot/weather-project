package forecast.processing

import org.apache.spark.sql.DataFrame
import org.apache.spark.sql.functions._

object DataFrameUnpacker {

  def unpackDataFrame(dataFrame: DataFrame, timestep: String): DataFrame = {
    val expandedDataFrame = dataFrame.selectExpr("timestamp","location.*", "timelines.*")

    val explodedDataFrame = expandedDataFrame.select(
      col("timestamp"),
      col("lat"),
      col("lon"),
      col("name"),
      col("type"),
      lit(timestep).alias("timestep"),
      explode(col(timestep)).alias(s"${timestep}Forecast"))

    val reducedDataFrame = explodedDataFrame.selectExpr("*", s"${timestep}Forecast.*").drop(s"${timestep}Forecast")

    val unpackedDataFrame = reducedDataFrame.selectExpr("*", "values.*").drop("values")
    unpackedDataFrame
  }
}