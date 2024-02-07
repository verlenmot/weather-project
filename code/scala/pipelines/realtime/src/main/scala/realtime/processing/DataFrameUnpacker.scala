package realtime.processing

import org.apache.spark.sql.DataFrame

object DataFrameUnpacker {

  def unpackDataFrame(dataFrame: DataFrame): DataFrame = {
    val expandedDataFrame = dataFrame.selectExpr("timestamp","location.*", "data.*")
    val unpackedDataFrame = expandedDataFrame.selectExpr("*", "values.*").drop("values")
    unpackedDataFrame
  }
}