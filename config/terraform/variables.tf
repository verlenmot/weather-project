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

variable "backend_resource_group_name" {
  default = ""
}

variable "backend_storage_account_name" {
  default = ""
}

variable "backend_container_name" {
  default = ""
}

variable "backend_key" {
  default = ""
}