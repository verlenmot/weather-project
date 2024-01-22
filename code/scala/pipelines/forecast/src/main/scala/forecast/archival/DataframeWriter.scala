package forecast.archival

import com.databricks.dbutils_v1.DBUtilsHolder.dbutils
import org.apache.spark.sql.DataFrame

object DataframeWriter  {
  def storeDataframe(dataFrame: DataFrame): Unit = {
    dataFrame.write.mode("overwrite").
      partitionBy("timestamp", "timestep").
      parquet(s"abfss://forecast@${dbutils.secrets.get(scope = "scope-weather", key = "storage")}.dfs.core.windows.net/")
  }
}
