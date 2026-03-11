output "db_endpoint" {
  description = "Full RDS endpoint including port"
  value       = aws_db_instance.main.endpoint
}

output "db_host" {
  description = "RDS hostname without port — used by Flask app"
  value       = split(":", aws_db_instance.main.endpoint)[0]
}

output "db_instance_identifier" {
  description = "RDS instance identifier — used by CloudWatch"
  value       = aws_db_instance.main.identifier
}