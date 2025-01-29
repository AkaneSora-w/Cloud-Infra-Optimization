######################################
# Global
######################################

owner        = "alveria"
environment  = "prod"
service_name = "middleware"
region       = "eu-west-1"
### Reminder to ask the app name and tags

######################################
# VPC
######################################

vpc_cidr            = "10.101.0.0/16"
public_subnets      = ["10.101.0.0/24", "10.101.1.0/24", "10.101.2.0/24"]
app_private_subnets = ["10.101.10.0/24", "10.101.11.0/24", "10.101.12.0/24"]
db_private_subnets  = ["10.101.20.0/24", "10.101.21.0/24", "10.101.22.0/24"]
public_subnet_ids   = ["subnet-0c6a6036b343ff845", "subnet-0d8429e76bce79c73", "subnet-0072c66f3734849e2"]


######################################
# ACM
######################################
certificates = {
  "hcms" = {
    domain_name               = "hcms.it"
    subject_alternative_names = ["*.hcms.it"]
  }
  "collaudo.hcms" = {
    domain_name               = "collaudo.hcms.it"
    subject_alternative_names = ["*.collaudo.hcms.it"]
  }
  "prod.hcms" = {
    domain_name               = "prod.hcms.it"
    subject_alternative_names = ["*.prod.hcms.it"]
  }
}

######################################
# Shared
######################################

######################################
# Conditional variables
######################################

create_kms_key        = false
create_alb            = true
create_kms_key_shared = true