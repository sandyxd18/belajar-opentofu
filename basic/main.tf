terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      # version = "3.6.2"
      version = ">= 3.0.0"
    }
  }
}

# Provider block
provider "docker" {
  host = "unix:///var/run/docker.sock"
}

# Data block
data "docker_network" "main" {
  name = "bridge"
}

# Resource block
# docker_image are types of resources
# nginx_alpine is the name of the resource
resource "docker_image" "nginx_alpine" {
  name         = "nginx:alpine"
  keep_locally = true
}

resource "docker_container" "nginx" {
  name       = var.container_name                 # Use the variable for container name
  image      = docker_image.nginx_alpine.image_id # Reference to the image resource attribute
  restart    = var.restart_policy                 # Use the variable for restart policy
  privileged = var.priviledged_mode               # Use the variable for privileged mode

  ports {
    internal = 80
    external = 8085
  }

  networks_advanced {
    name = data.docker_network.main.name # Use the name from the data block
  }
}

resource "docker_container" "nginx-2" {
  name       = "${var.container_name}-2" # Use the variable for container name with a suffix
  image      = docker_image.nginx_alpine.image_id
  restart    = var.restart_policy
  privileged = var.priviledged_mode

  ports {
    internal = 80
    external = 8086
  }

  networks_advanced {
    name = data.docker_network.main.name
  }

  lifecycle {
    prevent_destroy = false
  }
}