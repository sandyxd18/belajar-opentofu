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

resource "docker_image" "nginx_alpine" {
  name         = "nginx:alpine"
  keep_locally = true
}

variable "container_name" {
  type = string
  default = "nginx-container"
}

variable "allow_expose_port" {
  type    = bool
  default = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx_alpine.image_id
  name  = var.container_name

  ports {
    internal = 80
    external = 8086
  }

  network_mode = data.docker_network.default_bridge.name

  lifecycle {
    # Precondition to check that the image tag is not 'latest'
    precondition {
      condition = !contains(split(":", docker_image.nginx_alpine.name), "latest")
      error_message = "The image tag 'latest' is not allowed. Please specify a specific version tag."
    }

    # Postcondition to ensure at least one port is exposed
    postcondition {
      condition = length(self.ports) > 0
      error_message = "Please, specify at least 1 port expose"
    }

    # Postcondition to check if exposing port is allowed
    postcondition {
      condition = !(var.allow_expose_port == false)
      error_message = "Not allowed to expose port"
    }
  }
}

data "docker_network" "default_bridge" {
  name = "bridge"

  lifecycle {
    postcondition {
      condition = self.driver == "bridge"
      error_message = "Docker driver must be \"bridge\""
    }
  }
}

output "subnet_network" {
  value = one(data.docker_network.default_bridge.ipam_config).subnet

  # lifecycle {
  #   precondition {
  #     condition     = parseint(split("/", one(data.docker_network.default_bridge.ipam_config).subnet)[1], 100) < 16
  #     error_message = "pastikan gunakan subnet lebih dari /16"
  #   }
  # }
}