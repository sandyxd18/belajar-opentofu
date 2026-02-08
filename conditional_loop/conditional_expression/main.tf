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
  name         = "nginx:alpine"
  keep_locally = true
}

variable "container_name" {
  type = string
  default = "hehe"
}

resource "docker_container" "nginx" {
  image = docker_image.nginx_alpine.image_id
  name = substr(var.container_name, 0, 6) == "nginx-" ? var.container_name : "nginx-false-${var.container_name}" # Conditional expression to set container name

  ports {
    internal = 80
    external = 8085
  }
}