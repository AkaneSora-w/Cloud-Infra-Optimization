module "public_alb" {
  count   = var.create_alb ? 1 : 0
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 9.9.0"

  name    = "${local.networking_prefix}-public-alb"
  vpc_id  = local.vpc_id
  subnets = var.vpc_mode == "centralized" ? var.public_subnet_ids : module.vpc[0].public_subnets

  // Security Group
  security_groups = [] // Additional sg

  create_security_group          = true
  security_group_name            = "${local.networking_prefix}-public-alb-sg"
  security_group_use_name_prefix = false
  security_group_ingress_rules = {

    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      description = "HTTP web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
    all_https = {
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      description = "HTTPS web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }

  }

  security_group_egress_rules = {

    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  // Listener(s)

  listeners = {
    http = {
      port     = 80
      protocol = "HTTP"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }

    }

    https = {
      port                        = 443
      protocol                    = "HTTPS"
      ssl_policy                  = "ELBSecurityPolicy-TLS13-1-2-2021-06"
      certificate_arn             = module.regional_certificate["prod.hcms"].acm_certificate_arn
      additional_certificate_arns = [for cert in module.regional_certificate : cert.acm_certificate_arn]

      fixed_response = {
        content_type = "text/plain"
        message_body = "Coming soon"
        status_code  = "200"
      }

    }
  }
  security_group_tags = { Name = "${local.networking_prefix}-public-alb-sg" }
  enable_deletion_protection = false
  depends_on = [module.vpc]

}

moved {
  from = module.public_alb
  to   = module.public_alb[0]
}