variable "rg_id" {
}

variable "alert_email" {
  sensitive = true
}

variable "amount_array" {
  description = "Array containing budget sizes"
  type        = list(number)
}
