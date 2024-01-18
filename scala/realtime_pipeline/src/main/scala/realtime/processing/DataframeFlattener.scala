package realtime.processing

object DataframeFlattener {

  import org.apache.spark.sql.DataFrame

  def flattenForecastDataframe(nestedDf: DataFrame): DataFrame = {
    val unpackedDf = nestedDf.selectExpr("timestamp","location.*", "data.*")
    val completeDf = unpackedDf.selectExpr("*", "values.*").drop("values")
    completeDf
  }
}