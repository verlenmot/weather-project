package forecast.processing

import org.apache.spark.sql.DataFrame

object DataFrameCacher {

  def cacheDataFrame(dataFrame: DataFrame): DataFrame = {
    val cachedDataFrame: DataFrame = dataFrame.cache
    cachedDataFrame
  }
}
