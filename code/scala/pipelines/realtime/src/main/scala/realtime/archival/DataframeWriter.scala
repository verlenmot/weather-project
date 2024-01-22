package realtime.archival

import com.databricks.dbutils_v1.DBUtilsHolder.dbutils
import org.apache.spark.sql.DataFrame

object DataframeWriter {

  def storeDataframe(dataFrame: DataFrame): Unit = {
    dataFrame.write.mode("overwrite").
      partitionBy("timestamp").
      parquet(s"abfss://realtime@${dbutils.secrets.get(scope = "scope-weather", key = "storage")}.dfs.core.windows.net/")
  }
}
