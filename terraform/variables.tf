variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Prefix for all resource names"
  type        = string
  default     = "ha-app"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability zones — always use 2 for high availability"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "my_ip" {
  description = "Your public IP for bastion SSH access. Get it with: curl ifconfig.me"
  type        = string
}

variable "key_pair_name" {
  description = "EC2 key pair name for SSH"
  type        = string
}

variable "db_secret_name" {
  description = "Name of the secret in Secrets Manager containing DB credentials"
  type        = string
  default     = "ha-app/db-credentials"
}

variable "domain_name" {
  description = "Your domain name e.g. yourapp.com"
  type        = string
}

variable "alert_email" {
  description = "Email address for CloudWatch alarm notifications"
  type        = string
}