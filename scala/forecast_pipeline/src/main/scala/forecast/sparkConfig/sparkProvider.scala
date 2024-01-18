package forecast.sparkConfig

import org.apache.spark.SparkConf
import org.apache.spark.sql.SparkSession
import com.databricks.dbutils_v1.DBUtilsHolder.dbutils

trait sparkProvider {

  val defaultConf = new SparkConf()
    .setAppName("weatherForecast")
    .set("spark.serializer", "org.apache.spark.serializer.KryoSerializer")
    .set("spark.sql.parquet.compression.codec", "snappy")
    .set("spark.sql.parquet.mergeSchema", "false")
    .set("spark.sql.sources.partitionOverwriteMode", "dynamic")
    .set("spark.log.level", "Warn")
    .set(s"fs.azure.account.auth.type.${dbutils.secrets.get(scope = "scope-weather", key = "storage")}.dfs.core.windows.net", "SAS")
    .set(s"fs.azure.sas.token.provider.type.${dbutils.secrets.get(scope = "scope-weather", key = "storage")}.dfs.core.windows.net", "org.apache.hadoop.fs.azurebfs.sas.FixedSASTokenProvider")
    .set(s"fs.azure.sas.fixed.token.${dbutils.secrets.get(scope = "scope-weather", key = "storage")}.dfs.core.windows.net", dbutils.secrets.get(scope = "scope-weather", key = "sas"))

    val conf = {
      if (defaultConf.contains("spark.master")) defaultConf
      else defaultConf.setMaster("local[*]")
    }

  val spark = SparkSession.builder.config(conf).getOrCreate()
  lazy val sc = spark.sparkContext

}
