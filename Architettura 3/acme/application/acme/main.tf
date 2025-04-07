locals {
  prefix     = "${var.owner}-${var.service_name}-${var.environment}"
  create_dmz = length(var.networking.dmz_cidr_block) > 0 ? 1 : 0
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.47.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.2"
    }
  }

  required_version = ">= 1.0"
}

data "aws_iam_policy" "managed_policy" {
  name = "AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy" "managed_policy_rds" {
  name = "AmazonRDSCustomInstanceProfileRolePolicy"
}