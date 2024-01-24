variable "client_id" {
  description = "Service principal ID"
  default     = ""
  sensitive   = true
}

variable "client_secret" {
  description = "Service principal secret"
  default     = ""
  sensitive   = true
}

variable "tenant_id" {
  description = "Azure tenant ID"
  default     = ""
  sensitive   = true
}

variable "subscription_id" {
  description = "Azure subscription ID"
  default     = ""
  sensitive   = true
}

variable "api_key" {
  description = "API key"
  default     = ""
  sensitive   = true
}

variable "ip_exceptions" {
  description = "IP address of client Terraform runs on"
  default     = ""
  sensitive   = true
}

variable "subnets" {
  description = "List of subnets for databricks vnet injection"
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "alert_email" {
  description = "Email for budget alerts"
  default     = ""
  sensitive   = true
}

variable "project_name" {
  description = "Name of the project"
  default     = "weather"
}

variable "forecast_source" {
  description = "Path to forecast jar"
}

variable "realtime_source" {
  description = "Path to realtime jar"
}

variable "city" {
  description = "Desired prediction location (lower capital without spaces)"
}