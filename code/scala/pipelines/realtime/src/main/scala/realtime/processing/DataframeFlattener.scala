package realtime.processing

import org.apache.spark.sql.DataFrame

object DataframeFlattener {

  def flattenDataframe(nestedDf: DataFrame): DataFrame = {
    val unpackedDf = nestedDf.selectExpr("timestamp","location.*", "data.*")
    val completeDf = unpackedDf.selectExpr("*", "values.*").drop("values")
    completeDf
  }
}