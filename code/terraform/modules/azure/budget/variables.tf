variable "rg_id" {
}

variable "alert_email" {
  sensitive = true
}

variable "amount_array" {
  type = list(number)
}
