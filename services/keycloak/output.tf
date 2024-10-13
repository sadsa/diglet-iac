output "keycloak_url" {
  value = "http://${aws_lb.keycloak_lb.dns_name}"
}
