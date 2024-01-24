package forecast.archival

import com.databricks.dbutils_v1.DBUtilsHolder.dbutils
import org.apache.spark.sql.DataFrame
import org.apache.spark.sql.functions.{col, regexp_replace}

object DataframeWriter  {

  def storeDataframe(dataFrame: DataFrame): Unit = {
    dataFrame
      .withColumn("timestamp", regexp_replace(col("timestamp"), ":", "-"))
      .write.mode("overwrite").
      partitionBy("timestamp", "timestep").
      parquet(s"abfss://forecast@${dbutils.secrets.get(scope = "scope-weather", key = "storage")}.dfs.core.windows.net/")
  }
}
