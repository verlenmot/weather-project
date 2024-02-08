variable "rg_name" {
}

variable "project_name" {
}

variable "project_instance" {
}

variable "ip_exceptions" {
}

variable "subnet_ids" {

}

variable "secrets" {
  description = "Map containing secrets to be inserted into key vault"
  type        = map(string)
}
