######################################
# Global
######################################

owner        = "architettura 3"
environment  = "prod"
service_name = "middleware"
region       = "eu-west-1"

######################################
# VPC
######################################

vpc_cidr                   = "10.100.0.0/16"
public_subnets             = ["10.100.10.0/24", "10.100.11.0/24", "10.100.12.0/24"]
app_private_subnets        = ["10.100.20.0/24", "10.100.21.0/24", "10.100.22.0/24"]
db_private_subnets         = ["10.100.30.0/24", "10.100.31.0/24", "10.100.32.0/24"]
use_centralized_nat        = false
central_transit_gateway_id = "tgw-0515fff6b303036ba"
vpc_mode                   = "dedicated"

######################################
# ACM
######################################
certificates = {
  "acme" = {
    domain_name               = "acme.it"
    subject_alternative_names = ["*.acme.it"]
  }
  "testing.acme" = {
    domain_name               = "testing.acme.it"
    subject_alternative_names = ["*.testing.acme.it"]
  }
  "prod.acme" = {
    domain_name               = "prod.acme.it"
    subject_alternative_names = ["*.prod.acme.it"]
  }
}

######################################
# EC2 OPENVPN
######################################
ec2_openvpn_config = {
  ami           = "ami-0a636034c582e2138"
  instance_type = "t4g.small"
  volume_size   = 10
}

######################################
# Scheduler
######################################
schedule_tag = {
  ec2 = "it-office-hours"
}

create_kms_key = true