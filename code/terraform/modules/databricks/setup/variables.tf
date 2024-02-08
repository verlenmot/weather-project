variable "project_name" {
}

variable "secret_kv" {
  description = "Key vault which serves as secret scope"
  sensitive   = true
}

variable "forecast_source" {
  sensitive = true
}

variable "realtime_source" {
  sensitive = true
}

