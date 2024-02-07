ThisBuild / version := "0.1.0-SNAPSHOT"

ThisBuild / scalaVersion := "2.12.18"

lazy val root = (project in file("."))
  .settings(
    name := "forecast"
  )

val sparkVersion = "3.4.2"

libraryDependencies ++= Seq(
  // Spark
  "org.apache.spark" %% "spark-core" % sparkVersion % "provided",
  "org.apache.spark" %% "spark-sql" % sparkVersion % "provided",

  // API Request
  "com.lihaoyi" %% "requests" % "0.8.0",

  // Storage
  "com.databricks" %% "dbutils-api" % "0.0.6"
  )