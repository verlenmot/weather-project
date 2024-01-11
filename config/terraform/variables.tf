variable "subscription_id" {
  description = "Subscription ID to be used"
  default     = ""
  type        = string
}
variable "ip" {
  default = ""
}

variable "ip2" {
  default = ""
}

variable "alert-email" {
  default = ""
}

variable "grafana_instance_url" {
  default = ""
}

variable "grafana_auth" {
  default = ""
}