resource "aws_db_instance" "keycloak_db" {
  identifier           = "keycloak-db"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine              = "postgres"
  engine_version      = "14"
  instance_class      = "db.t3.micro"
  username            = "keycloak"
  password            = "keycloak123"  # Change this in production
  skip_final_snapshot = true

  vpc_security_group_ids = [aws_security_group.keycloak_database_security_group.id]
  db_subnet_group_name   = aws_db_subnet_group.keycloak_db_subnet_group.name
}

resource "aws_db_subnet_group" "keycloak_db_subnet_group" {
  name       = "keycloak-db-subnet-group"
  subnet_ids = aws_subnet.keycloak_subnet_private[*].id
}