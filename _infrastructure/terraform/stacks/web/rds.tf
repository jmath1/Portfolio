resource "aws_db_instance" "portfolio_db" {
  count = var.use_rds ? 1 : 0

  allocated_storage    = 20
  storage_type         = "gp2"
  engine              = "postgres"
  engine_version      = "17.4"
  instance_class      = "db.t3.micro"
  identifier          = "portfolio-db"
  username           = local.env_vars["DB_USER"]
  password           = local.env_vars["DB_PASSWORD"]
  db_name            = local.env_vars["DB_NAME"]
  publicly_accessible = var.use_vpc ? false : true
  skip_final_snapshot = true
  db_subnet_group_name = local.use_rds_and_vpc ? aws_db_subnet_group.rds_subnet_group[0].name : null
  vpc_security_group_ids = local.use_rds_and_vpc ? [aws_security_group.rds_sg[0].id] : null
}

resource "aws_db_subnet_group" "rds_subnet_group" {

  count = local.use_rds_and_vpc ? 1 : 0

  name       = "rds-private-subnet-group"
  subnet_ids = local.private_subnets

  tags = {
    Name = "RDS Private Subnet Group"
  }
}

resource "aws_security_group" "rds_sg" {

  count = var.use_rds ? 1 : 0

  name        = "rds-security-group"
  description = "Allow database access from ec2 subnet"
  vpc_id      = local.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}