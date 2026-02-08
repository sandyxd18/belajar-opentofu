terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = ">= 3.0.0"
    }
  }
}

# Provider block
provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_image" "nginx_alpine" {
  name = "nginx:alpine"
  keep_locally = true
}

variable "env_config" {
  type = list(object({
    key = string
    value = string
    is_enabled = bool
  }))

  default = [ {
    key = "SECRET_KEY"
    value = "aaabbbccc"
    is_enabled = true
  }, {
    key = "order_svc_host" 
    value = "example.order.local"
    is_enabled = false
  } ]
}

resource "docker_container" "nginx" {
  count = 3
  image = docker_image.nginx_alpine.image_id

  name = "nginx-${count.index}"

  ports {
    internal = 80
    external = 8080 + count.index
  }

  env = [
    for e in var.env_config : "${upper(e.key)}=${e.value}"
  ]
}

output "list_env_created" {
  value = {  
    for e in var.env_config : upper(e.key) => e.value
  }
  description = "environment variables created in the container"
}

output "list_ip_container" {
  value = [
    for con in docker_container.nginx : one(con.network_data).ip_address
  ]
  description = "All Container IP Address"
}