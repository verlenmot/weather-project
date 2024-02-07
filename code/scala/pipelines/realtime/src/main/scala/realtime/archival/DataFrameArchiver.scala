package realtime.archival

import com.databricks.dbutils_v1.DBUtilsHolder.dbutils
import org.apache.spark.sql.DataFrame
import org.apache.spark.sql.functions.{col, regexp_replace}

object DataFrameArchiver {

  def storeDataFrame(dataFrame: DataFrame): Unit = {
    dataFrame
      .withColumn("timestamp", regexp_replace(col("timestamp"), ":", "-")) // Symbol change for Azure Storage
      .write.mode("overwrite")
      .partitionBy("timestamp")
      .parquet(s"abfss://realtime@${dbutils.secrets.get(scope = "scope-weather", key = "storage")}.dfs.core.windows.net/")
  }
}
