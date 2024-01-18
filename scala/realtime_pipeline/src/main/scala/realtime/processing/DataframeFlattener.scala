package realtime.processing

object DataframeFlattener {

  import org.apache.spark.sql.DataFrame
  import org.apache.spark.sql.functions._


  def flattenForecastDataframe(nestedDf: DataFrame): DataFrame = {
    val unpackedDf = nestedDf.selectExpr("request_timestamp","location.*", "data.*")

    val completeDf = unpackedDf.selectExpr("*", "values.*").drop("values")

    return completeDf
  }
}