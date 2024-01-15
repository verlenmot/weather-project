package forecast.processing

import forecast.sparkConfig
//object DataframeFlattener {

//  import org.apache.spark.sql.DataFrame
//  import org.apache.spark.sql.functions.explode
//
//  def flattenDataframe (nestedDF: DataFrame): DataFrame = {
//    val stageOne = nestedDF.selectExpr("location.*", "timelines.*")
//    return stageOne.select(explode($"daily"))
//  }