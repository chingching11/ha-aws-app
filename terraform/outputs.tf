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
