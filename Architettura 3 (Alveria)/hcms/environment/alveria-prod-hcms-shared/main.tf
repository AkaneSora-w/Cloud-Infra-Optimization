terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.47.0"
    }
  }
  backend "http" {
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


module "hcms" {
  source = "../../application/hcms"

  ### Global ###
  owner        = var.owner
  environment  = var.environment
  service_name = var.service_name
  schedule_tag = var.schedule_tag
  backup_tag   = var.backup_tag


  ### VPC ###
  networking  = var.networking
  hcms_tg_cfg = var.hcms_tg_cfg

  ### EC2 ###
  ec2_hcms_config = var.ec2_hcms_config
  ec2_ftp_server  = var.ec2_ftp_server

  ### RDS ###
  rds_custom_mssql_config     = var.rds_custom_mssql_config
  rds_custom_mssql_config_new = var.rds_custom_mssql_config_new

}
