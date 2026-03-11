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

module "security" {
  source       = "./modules/security"
  vpc_id       = module.networking.vpc_id
  project_name = var.project_name
  my_ip        = var.my_ip
}

module "compute" {
  source                    = "./modules/compute"
  project_name              = var.project_name
  aws_region                = var.aws_region
  vpc_id                    = module.networking.vpc_id
  public_subnet_ids         = module.networking.public_subnet_ids
  private_subnet_ids        = module.networking.private_subnet_ids
  alb_sg_id                 = module.security.alb_sg_id
  ec2_sg_id                 = module.security.ec2_sg_id
  bastion_sg_id             = module.security.bastion_sg_id
  ec2_instance_profile_name = module.security.ec2_instance_profile_name
  key_pair_name             = var.key_pair_name
  db_secret_name            = var.db_secret_name
  # ecr_repo_url and db_host will be added later
  ecr_repo_url              = ""
  db_host                   = ""
}

module "database" {
  source              = "./modules/database"
  project_name        = var.project_name
  database_subnet_ids = module.networking.database_subnet_ids
  rds_sg_id           = module.security.rds_sg_id
  db_secret_name      = var.db_secret_name
}