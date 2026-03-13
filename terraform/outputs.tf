# terraform/outputs.tf

output "vpc_id" {
  description = "VPC ID"
  value       = module.networking.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.networking.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.networking.private_subnet_ids
}

output "database_subnet_ids" {
  description = "Database subnet IDs"
  value       = module.networking.database_subnet_ids
}

output "alb_dns_name" {
  description = "ALB DNS name — use this to test before domain is set up"
  value       = module.compute.alb_dns_name
}

output "bastion_public_ip" {
  description = "Bastion host IP for SSH access"
  value       = module.compute.bastion_public_ip
}

output "db_endpoint" {
  value = module.database.db_endpoint
}

output "db_host" {
  value = module.database.db_host
}

output "ecr_repo_url" { 
  value = module.compute.ecr_repo_url 
}

output "target_group_arn" {
  value = module.compute.target_group_arn
}

output "github_actions_role_arn" {
  value = module.security.github_actions_role_arn
}