terraform {
	source = "../../application/middleware"
}

locals {
  owner        = "alveria"
  environment  = "prod"
  service_name = "middleware"
  region       = "eu-west-1"
}

#removed terraform required provider & required version

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

generate "outputs" {
  path      = "generated_output.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
output "vpc_id" {
  value = try(module.vpc[0].vpc_id, null)
}

output "vpn_sgid" {
  value = try(module.sg_openvpn[0].security_group_id, null)
}

output "alb_http_arn" {
  value = try(module.public_alb[0].listeners.http.arn, null)
}

output "alb_https_arn" {
  value = try(module.public_alb[0].listeners.https.arn, null)
}

output "kms_arn" {
  value = try(aws_kms_key.rds_key[0].arn, null)
}

output "shared_kms_arn" {
  value = try(aws_kms_key.shared_key[0].arn, null)
}

output "list_db_subnet" {
  value = try(module.vpc[0].database_subnets)
}
EOF
}

inputs = {
  #global
  owner        = local.owner
  environment  = local.environment
  service_name = local.service_name
  region       = local.region
}