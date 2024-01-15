package forecast.processing

object DataframeEnricher {

  import org.apache.spark.sql.DataFrame
  import org.apache.spark.sql.functions._

  def requestTimeAdd(dataFrame: DataFrame, requestTime: String): DataFrame = {

    val adjustedTime: String = requestTime.drop(5)

    val enrichedDataFrame: DataFrame = dataFrame.withColumn("request_timestamp", to_timestamp(lit(adjustedTime), "dd MMM yyyy HH:mm:ss z"))

    enrichedDataFrame
  }
}
