output "keycloak_url" {
  value = "http://${aws_lb.keycloak.dns_name}"
}