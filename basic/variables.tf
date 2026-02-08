variable "container_name" {
  type    = string
  default = "my_nginx_container"
}

variable "restart_policy" {
  type    = string
  default = "always"
}

variable "priviledged_mode" {
  type    = bool
  default = false
}