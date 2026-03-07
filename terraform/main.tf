terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "ha-app-tfstate-702175641433"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "ha-app-terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Project   = var.project_name
      ManagedBy = "Terraform"
    }
  }
}

module "networking" {
  source       = "./modules/networking"
  vpc_cidr     = var.vpc_cidr
  project_name = var.project_name
  azs          = var.azs
}