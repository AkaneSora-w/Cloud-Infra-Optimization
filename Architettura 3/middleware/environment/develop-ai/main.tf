terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.47.0"
    }
  }

  

  required_version = ">= 1.0"
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Owner       = var.owner
      Environment = var.environment
      ServiceName = var.service_name
      CreatedBy   = "Terraform"
    }
  }
}


module "middleware" {
  source = "../../application/middleware"

  ### Global ###
  environment  = var.environment
  service_name = var.service_name
  owner        = var.owner
  schedule_tag = var.schedule_tag

  ### VPC ###
  vpc_cidr            = var.vpc_cidr
  public_subnets      = var.public_subnets
  app_private_subnets = var.app_private_subnets
  vpc_mode            = var.vpc_mode
  db_private_subnets  = var.db_private_subnets
  use_centralized_nat = var.use_centralized_nat
  create_alb          = var.create_alb


  ### ROUTE53 ###
  certificates = var.certificates

  ### EC2 OPENVPN ###
  ec2_openvpn_config = var.ec2_openvpn_config

  create_kms_key = var.create_kms_key

}