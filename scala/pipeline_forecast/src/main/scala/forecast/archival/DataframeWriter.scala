package forecast.archival
import com.databricks.dbutils_v1.DbfsUtils
import forecast.sparkConfig.sparkProvider
import forecast.devConfig._
import com.databricks.dbutils_v1.DBUtilsHolder.dbutils

object DataframeWriter extends sparkProvider {

  import spark.implicits._
  import org.apache.spark.sql.DataFrame
  import org.apache.spark.sql.types._
  import org.apache.spark.sql.functions.lit

  def storeDataframe(dataFrame: DataFrame): Unit = {
      dataFrame.write.parquet(s"abfss://forecast@${dbutils.widgets.get("storageAccount")}.dfs.core.windows.net/test1?/${dbutils.secrets.get("scope-weather", "sas")}")
  }
}
