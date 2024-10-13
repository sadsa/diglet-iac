resource "aws_lb" "keycloak_lb" {
  name               = "keycloak-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.keycloak_security_group.id]
  subnets            = aws_subnet.keycloak_subnet_public[*].id
}

resource "aws_lb_target_group" "keycloak_lb_target_group" {
  name        = "keycloak-lb-target-group"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = aws_vpc.keycloak_vpc.id
  target_type = "ip"

  health_check {
    path                = "/auth/health"
    healthy_threshold   = 2
    unhealthy_threshold = 10
  }
}

resource "aws_lb_listener" "keycloak_lb_listener" {
  load_balancer_arn = aws_lb.keycloak_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.keycloak_lb_target_group.arn
  }
}
