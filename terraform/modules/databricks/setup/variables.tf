variable "project_name" {
}

variable "secret_kv" {
  sensitive = true
}

variable "notebooks" {
  type = map(string)
}