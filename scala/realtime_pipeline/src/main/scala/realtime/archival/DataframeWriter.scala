package realtime.archival

import com.databricks.dbutils_v1.DbfsUtils
import realtime.sparkConfig.sparkProvider
import com.databricks.dbutils_v1.DBUtilsHolder.dbutils

object DataframeWriter extends sparkProvider {

  import spark.implicits._
  import org.apache.spark.sql.DataFrame
  import org.apache.spark.sql.types._
  import org.apache.spark.sql.functions._

  def storeDataframe(dataFrame: DataFrame): Unit = {
    dataFrame.write.mode("overwrite").partitionBy("request_timestamp").parquet(s"abfss://realtime@${dbutils.secrets.get(scope = "scope-weather", key = "storage")}.dfs.core.windows.net/")
  }
}
