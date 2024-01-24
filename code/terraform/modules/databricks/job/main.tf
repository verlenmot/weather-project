terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "=1.34.0"
    }
  }
}

# Forecast job
resource "databricks_job" "forecast" {
  name        = "Forecast pipeline"
  description = "This job executes a JAR task and SQL tasks for the forecast dashboard."

  max_concurrent_runs = 2

  queue {
    enabled = true
  }

  job_cluster {
    job_cluster_key = "a"

    new_cluster {
      spark_version    = "13.3.x-scala2.12"
      instance_pool_id = var.pool_id
      runtime_engine   = "STANDARD"
      num_workers      = 0

      spark_conf = {
        "spark.databricks.cluster.profile" : "singleNode"
        "spark.master" : "local[*]"
      }

      custom_tags = {
        "ResourceClass" = "SingleNode"
      }
    }
  }

  #   email_notifications {
  #     on_success = [var.dev_email]
  #     on_failure = [var.dev_email]
  #   }

  schedule {
    timezone_id            = "Europe/Amsterdam"
    quartz_cron_expression = "0 0/12 * 1/1 * ? *"
  }


  ## tasks
  task {
    task_key = "a"

    sql_task {
      warehouse_id = var.warehouse_id
      query {
        query_id = var.query_map["forecastTablesQuery"]
      }
    }
  }


  task {
    task_key = "b"

    depends_on {
      task_key = "a"
    }

    job_cluster_key = "a"


    library {
      jar = "dbfs:/${var.project_name}/forecast.jar"
    }


    spark_jar_task {
      main_class_name = "forecast.Main"
      parameters      = [var.city]
    }
  }

  task {
    task_key = "c"

    depends_on {
      task_key = "b"
    }

    sql_task {
      warehouse_id = var.warehouse_id

      dashboard {
        dashboard_id = var.dashboard_id
      }
    }
  }
}


# Realtime job
resource "databricks_job" "realtime" {
  name        = "Realtime pipeline"
  description = "This job executes a JAR task and SQL tasks for the realtime dashboard."

  max_concurrent_runs = 2

  queue {
    enabled = true
  }

  job_cluster {
    job_cluster_key = "b"

    new_cluster {
      spark_version    = "13.3.x-scala2.12"
      instance_pool_id = var.pool_id
      runtime_engine   = "STANDARD"
      num_workers      = 0

      spark_conf = {
        "spark.databricks.cluster.profile" : "singleNode"
        "spark.master" : "local[*]"
      }

      custom_tags = {
        "ResourceClass" = "SingleNode"
      }
    }
  }

  #   email_notifications {
  #     on_success = [var.dev_email]
  #     on_failure = [var.dev_email]
  #   }

  schedule {
    timezone_id            = "Europe/Amsterdam"
    quartz_cron_expression = "0 0/6 * 1/1 * ? *"
  }


  ## tasks
  task {
    task_key = "a"

    sql_task {
      warehouse_id = var.warehouse_id
      query {
        query_id = var.query_map["realtimeTableQuery"]
      }
    }
  }

  task {
    task_key = "b"

    depends_on {
      task_key = "a"
    }

    job_cluster_key = "b"
    library {
      jar = "dbfs:/${var.project_name}/realtime.jar"
    }


    spark_jar_task {
      main_class_name = "realtime.Main"
      parameters      = [var.city]
    }
  }

  task {
    task_key = "c"

    depends_on {
      task_key = "b"
    }

    sql_task {
      warehouse_id = var.warehouse_id

      dashboard {
        dashboard_id = var.dashboard_id
      }
    }
  }
}








