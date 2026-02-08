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

variable "exposed_ports" {
  type = list(object({
    ext = number
    int = number
  }))

  default = [ {
    ext = 8080
    int = 80
  }, {
    ext = 8181
    int = 81
  } ]
}

resource "docker_container" "nginx" {
  image = "nginx:alpine"

  name = "nginx-con-alpine"

  dynamic "ports" {
    for_each = toset(var.exposed_ports)

    content {
      external = ports.value.ext
      internal = ports.value.int
    }
  }
}

resource "docker_container" "apache" {
  image = "httpd:alpine"

  name = "apache-con-alpine"

  dynamic "ports" {
    for_each = toset(var.exposed_ports)

    content {
      external = ports.value.ext + 2
      internal = ports.value.int
    }
  }
}