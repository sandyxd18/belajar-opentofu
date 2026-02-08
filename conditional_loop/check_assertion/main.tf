terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = ">= 3.0.0"
    }
    http = {
      source = "hashicorp/http"
      version = "3.5.0"
    }
  }
}

# Provider block
provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_image" "nginx_alpine" {
  name = "nginx:alpine"
  keep_locally = false
}

resource "docker_container" "nginx" {
  name  = "nginx-con"
  image = docker_image.nginx_alpine.image_id
  ports {
    internal = 80
    external = 8086
  }
}

check "health_check" {
  data "http" "container" {
    method  = "GET"
    url     = "http://localhost:${docker_container.nginx.ports[0].external}/"
  }

  assert {
    condition = data.http.container.status_code == 200
    error_message = "${data.http.container.url} return http error"
  }

  assert {
    condition = length(regexall("nginx*", data.http.container.response_headers.Server)) > 0
    error_message = "Server header is not nginx"
  }
}