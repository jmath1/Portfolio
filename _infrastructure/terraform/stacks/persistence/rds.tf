resource "aws_db_instance" "portfolio_db" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine              = "postgres"
  engine_version      = "17.4"
  instance_class      = "db.t3.micro"
  identifier          = "portfolio-db"
  username           = local.env_vars["DB_USER"]
  password           = local.env_vars["DB_PASSWORD"]
  db_name            = local.env_vars["DB_NAME"]
  publicly_accessible = false
  skip_final_snapshot = true
}


resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = local.database_subnet_ids

  tags = {
    Name = "rds-subnet-group"
  }
}