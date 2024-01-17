terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "=1.33.0"
    }
  }
}

# Forecast job

# resource "databricks_job" "forecast" {
#   name        = "Forecast pipeline"
#   description = "This job executes a JAR task and SQL tasks for the forecast dashboard."

#   job_cluster {
#     job_cluster_key = "a"

#     new_cluster {
#       spark_version           = "13.3.x-scala2.12"
#       node_type_id            = "Standard_D3_v2"
#       runtime_engine          = "STANDARD"
#       num_workers             = 0

#       spark_conf = {
#         "spark.databricks.cluster.profile" : "singleNode"
#         "spark.master" : "local[*]"
#       }

#       custom_tags = {
#         "ResourceClass" = "SingleNode"
#       }
#     }
#   }

#   email_notifications {
#     on_success = [var.dev_email]
#     on_failure = [var.dev_email]
#   }

#   schedule {
#     timezone_id            = "Europe/Amsterdam"
#     quartz_cron_expression = "0 0/6 * 1/1 * ? *"
#   }


#   ## tasks ##

#   task {
#     task_key = "a"

#     job_cluster_key = "a"


#     library {
#       jar = "dbfs:/${var.project_name}/forecast.jar"
#     }


#     spark_jar_task {
#       parameters      = ["st${var.project_name}${var.project_instance}"]
#       main_class_name = "forecast.Main"
#     }
#   }
# }




