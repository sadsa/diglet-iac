resource "aws_db_instance" "keycloak" {
  identifier           = "keycloak-db"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine              = "postgres"
  engine_version      = "14"
  instance_class      = "db.t3.micro"
  username            = "keycloak"
  password            = "keycloak123"  # Change this in production
  skip_final_snapshot = true

  vpc_security_group_ids = [aws_security_group.database.id]
  db_subnet_group_name   = aws_db_subnet_group.keycloak.name
}

resource "aws_db_subnet_group" "keycloak" {
  name       = "keycloak-db-subnet-group"
  subnet_ids = aws_subnet.private[*].id
}