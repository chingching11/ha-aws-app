variable "project_name" {
  description = "Prefix for all resource names"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for ALB and Bastion"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for EC2 instances"
  type        = list(string)
}

variable "alb_sg_id" {
  description = "Security group ID for the ALB"
  type        = string
}

variable "ec2_sg_id" {
  description = "Security group ID for EC2 instances"
  type        = string
}

variable "bastion_sg_id" {
  description = "Security group ID for the Bastion host"
  type        = string
}

variable "ec2_instance_profile_name" {
  description = "IAM instance profile name for EC2"
  type        = string
}

variable "key_pair_name" {
  description = "EC2 key pair name for SSH"
  type        = string
}

variable "target_group_arn" {
  description = "ALB target group ARN for ASG attachment"
  type        = string
  default     = ""
}

variable "db_secret_name" {
  description = "Secrets Manager secret name for DB credentials"
  type        = string
}

variable "ecr_repo_url" {
  description = "ECR repository URL for Docker image pulls"
  type        = string
  default     = ""
}

variable "db_host" {
  description = "RDS endpoint host for DB connections"
  type        = string
  default     = ""
}