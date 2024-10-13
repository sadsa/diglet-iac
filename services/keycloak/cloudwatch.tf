resource "aws_cloudwatch_log_group" "keycloak_cloudwatch_log_group" {
  name = "/ecs/keycloak"
}