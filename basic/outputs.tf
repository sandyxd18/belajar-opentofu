output "container_ip" {
  value       = "Internal: ${docker_container.nginx.ports[0].internal}, External: ${docker_container.nginx.ports[0].external}"
  description = "IP dari Container Nginx pertama"
}