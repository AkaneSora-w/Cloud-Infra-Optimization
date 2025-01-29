terraform {
	source = "../../application/hcms"
}

locals {
  owner        = "alveria"
  environment  = "prod"
  # service_name = "hcms"
  region       = "eu-west-1"
}

generate "provider" {
  path = "generated_provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
  provider "aws" {
    region = "${local.region}"
    default_tags {
      tags = {
        Owner       = "${local.owner}"
        Environment = var.environment
        ServiceName = var.service_name
        CreatedBy   = "Terraform"
      }
    }
  }
  EOF
}

inputs = {
    # global
    owner        = local.owner
    environment  = local.environment
    # service_name = local.service_name
    region       = local.region

}