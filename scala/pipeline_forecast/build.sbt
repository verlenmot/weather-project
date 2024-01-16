ThisBuild / version := "0.1.0-SNAPSHOT"

ThisBuild / scalaVersion := "2.12.18"

lazy val root = (project in file("."))
  .settings(
    name := "pipeline_foreceast"
  )

val sparkVersion = "3.4.2"

libraryDependencies ++= Seq(
  // Spark
  "org.apache.spark" %% "spark-core" % sparkVersion % "provided",
  "org.apache.spark" %% "spark-sql" % sparkVersion % "provided",

  // API Request
  "com.lihaoyi" %% "requests" % "0.8.0",

  // Storage
   "org.apache.hadoop" % "hadoop-azure" % "3.3.2",
   "com.microsoft.azure" % "azure-storage" % "8.6.6",
   "org.apache.hadoop" % "hadoop-azure-datalake" % "3.3.2",
   "com.databricks" %% "dbutils-api" % "0.0.6"
  )