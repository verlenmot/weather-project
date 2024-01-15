package forecast.ingestion
import forecast.sparkConfig
object DataframeFlattener extends sparkConfig.sparkProvider {

  import spark.implicits._
  import org.apache.spark.sql.DataFrame
  import org.apache.spark.sql.types._
  import org.apache.spark.sql.functions._
  import org.apache.spark.sql.functions.explode

  def flattenDataframe (nestedDF: DataFrame): DataFrame = {
    val stageOne = nestedDF.selectExpr("location.*", "timelines.*")
    return stageOne.select(explode($"daily"))
  }
}
