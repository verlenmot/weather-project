package forecast.ingestion
import forecast.sparkConfig

object DataFrameCreator extends sparkConfig.sparkProvider {

  // Create a test DataFrame with a list of tuples
  val data = Seq(
    ("Alice", 25, "New York"),
    ("Bob", 30, "San Francisco"),
    ("Charlie", 22, "Los Angeles")
  )

  // Create a DataFrame without specifying a schema
  val df = spark.createDataFrame(data)}