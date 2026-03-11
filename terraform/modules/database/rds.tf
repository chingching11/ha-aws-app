# Read credentials from Secrets Manager
# Terraform uses this to set the RDS username and password
data "aws_secretsmanager_secret_version" "db" {
  secret_id = var.db_secret_name
}

locals {
  db_creds = jsondecode(
    data.aws_secretsmanager_secret_version.db.secret_string
  )
}

# Subnet group — tells RDS which subnets it can use
# Must include subnets in at least 2 AZs for Multi-AZ to work
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.database_subnet_ids

  tags = { Name = "${var.project_name}-db-subnet-group" }
}

# RDS PostgreSQL instance
resource "aws_db_instance" "main" {
  identifier     = "${var.project_name}-db"
  engine         = "postgres"
  engine_version = "16.3"
  instance_class = "db.t3.micro"

  allocated_storage     = 20
  max_allocated_storage = 100
  storage_type          = "gp2"
  storage_encrypted     = true

  db_name  = local.db_creds["dbname"]
  username = local.db_creds["username"]
  password = local.db_creds["password"]

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.rds_sg_id]

  # Multi-AZ — AWS creates a synchronous standby replica
  # in the second AZ automatically
  # If primary fails, AWS promotes standby in ~60 seconds
  multi_az = true

  backup_retention_period = 0

  deletion_protection = false
  skip_final_snapshot = true

  tags = { Name = "${var.project_name}-db" }
}