locals {
  prefix            = "${var.owner}-${var.service_name}-${var.environment}"
  networking_prefix = "${var.owner}-${var.environment}"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.47.0"
    }
  }

  required_version = ">= 1.0"
}

data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}
data "aws_iam_policy" "managed_policy" {
  name = "AmazonSSMManagedInstanceCore"
}

moved {
  from = aws_iam_policy.managed_policy[0]
  to   = aws_iam_policy.managed_policy
}

locals {
  vpc_id                 = var.vpc_mode == "centralized" ? var.vpc_id : module.vpc[0].vpc_id
  create_dedicated_nat   = var.use_centralized_nat && var.central_transit_gateway_id == null
  centralized_networking = var.vpc_mode == "centralized"
  create_openvpn         = !local.centralized_networking || var.create_openvpn
}