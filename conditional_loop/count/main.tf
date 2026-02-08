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

variable "container_name" {
  type        = string
  default     = "nginx-container"
}

resource "docker_container" "nginx" {
  count = 3

  name  = "${var.container_name}-${count.index}"
  image = docker_image.nginx_alpine.image_id
  ports {
    internal = 80
    external = 8080 + count.index
  }
}