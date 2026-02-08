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
  default = "nginx-container"

  validation {
    # Validasi nama container harus diawali dengan "nginx-" dan tidak mengandung spasi
    condition = substr(var.container_name, 0, 6) == "nginx-" && !contains(regexall("[a-zA-Z0-9][a-zA-Z0-9_.-]", var.container_name), " ")
    error_message = "nama container tidak menggunakan prefix \"nginx-\" atau ada karakter space"
  }
}

resource "docker_container" "nginx" {
  image = docker_image.nginx_alpine.image_id
  name  = var.container_name

  ports {
    internal = 80
    external = 8085
  }
}