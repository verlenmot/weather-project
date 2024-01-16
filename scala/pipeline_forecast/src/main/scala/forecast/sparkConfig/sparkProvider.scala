package forecast.sparkConfig

import org.apache.spark.SparkConf
import org.apache.spark.sql.SparkSession
import forecast.devConfig
trait sparkProvider {

  val config = "test"
  val accountKey = "test"

  val defaultConf = new SparkConf()
    .setAppName("weatherForecast")
    .set("spark.serializer", "org.apache.spark.serializer.KryoSerializer")
    .set("spark.sql.parquet.compression.codec", "snappy")
    .set("spark.sql.parquet.mergeSchema", "false")
    .set("spark.sql.sources.partitionOverwriteMode", "dynamic")
    .set("spark.log.level", "Warn")
  // Databricks storage config added at job cluster creation


    val conf = {
      if (defaultConf.contains("spark.master")) defaultConf
      else defaultConf.setMaster("local[*]")
    }

  val spark = SparkSession.builder.config(conf).getOrCreate()
  lazy val sc = spark.sparkContext

}
