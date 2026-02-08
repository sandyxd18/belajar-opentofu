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

variable "list_container" {
  type = list(string)
  default = [ "dev", "staging", "prod", "prod" ]
}

resource "docker_container" "list_nginx" {
  for_each = toset(var.list_container)

  image = docker_image.nginx_alpine.image_id
  name  = "nginx-list-${each.value}"

  ports {
    internal = 80
    external = 8080 + index(var.list_container, each.key)
  }
}

variable "map_container" {
  type = map(object({
    name = string
    external_port = number
  }))

  default = {
    "con_1" = {
      name = "container_1",
      external_port = 7676
    },
    "con_2" = {
      name = "container_2",
      external_port = 6969
    },
  }
}

resource "docker_container" "map_nginx" {
  for_each = var.map_container

  image = docker_image.nginx_alpine.image_id
  name  = "nginx-map-${each.key}-${each.value.name}"

  ports {
    internal = 80
    external = each.value.external_port
  }

  depends_on = [ docker_container.list_nginx ]
}