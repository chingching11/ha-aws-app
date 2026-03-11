variable "project_name" {
  description = "Prefix for all resource names"
  type        = string
}

variable "database_subnet_ids" {
  description = "Database subnet IDs for RDS subnet group"
  type        = list(string)
}

variable "rds_sg_id" {
  description = "Security group ID for RDS"
  type        = string
}

variable "db_secret_name" {
  description = "Secrets Manager secret name containing DB credentials"
  type        = string
}