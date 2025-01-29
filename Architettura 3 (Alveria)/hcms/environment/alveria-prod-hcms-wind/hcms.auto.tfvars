######################################
# Global
######################################

owner        = "alveria"
environment  = "prod"
service_name = "hcms"
region       = "eu-west-1"

######################################
# Networking
######################################

networking = {
  vpc_id                        = "vpc-0c3c0ccbc8ccca2bc"
  route53_zone_id               = "Z07346853JL1SIRXF3AET"
  sg_public_alb_id              = "sg-072d283e14fd6f59b"
  alb_public_https_listener_arn = "arn:aws:elasticloadbalancing:eu-west-1:339712698801:listener/app/alveria-prod-public-alb/c0bd0c1a79f9d720/e8ae41100dc35f27"
  alb_public_http_listener_arn  = "arn:aws:elasticloadbalancing:eu-west-1:339712698801:listener/app/alveria-prod-public-alb/c0bd0c1a79f9d720/4990103205dd7434"
  alb_public_dns_name           = "alveria-prod-public-alb-314004468.eu-west-1.elb.amazonaws.com"
  alb_public_zone_id            = "Z32O12XQLNTSW2"
  sg_vpn_id                     = "sg-0f8a8f0783a420708"
  az = {
    ec2        = "eu-west-1a"
    rds_custom = "eu-west-1c"
  }
}

hcms_tg_cfg = {
  port                    = "80"
  health_check_path       = "/"
  domain_names            = ["w3timeline-admin.prod.hcms.it", "w3timeline-apiservice.prod.hcms.it", "w3timeline.prod.hcms.it", "w3timeline-erec-apiservice-collaudo.prod.hcms.it", "w3timeline-elearning.prod.hcms.it"]
  collaudo_domain_names   = ["w3timeline-admin.collaudo.hcms.it", "w3timeline-apiservice.collaudo.hcms.it", "w3timeline.collaudo.hcms.it"]
  formazione_domain_names = ["w3formazione.prod.hcms.it", "w3formazione.collaudo.hcms.it"]
  backoffice_domain_names = ["peoplehub-backoffice.prod.hcms.it", "peoplehub-backoffice.collaudo.hcms.it", "peoplehub-frontline.prod.hcms.it", "peoplehub-frontline.collaudo.hcms.it"]
}

######################################
# EC2
######################################
ec2_hcms_config = {
  "hcms" = {
    create        = true
    ami           = "ami-05ed85bb0a2680064"
    instance_type = "t3a.xlarge"
    subnet_id     = "subnet-0f4cae047b947ae81"
    volume_size   = 50
    key_name      = "alveria-middleware-prod-key"
  },
  "hcms_clone" = {
    create        = true
    ami           = "ami-05ed85bb0a2680064"
    instance_type = "t3a.xlarge"
    subnet_id     = "subnet-0f4cae047b947ae81"
    volume_size   = 70
    key_name      = "alveria-middleware-prod-key"
    extra_ebs = {
      "xvdb" = {
        size = 500
      }
    }
  }
}
######################################
# RDS MSSQL
######################################
rds_custom_mssql_config = {
  engine                 = "custom-sqlserver-se"
  engine_version         = "15.00.4345.5.v1"
  family                 = "custom-sqlserver-se-15.0"
  major_engine_version   = "15.00"
  instance_class         = "db.r6i.large"
  allocated_storage      = 200
  storage_type           = "gp3"
  username               = "root"
  kms_key_arn            = "arn:aws:kms:eu-west-1:339712698801:key/20d1f313-a79e-48a2-a129-e6873fb1773e"
  db_subnet_group_name   = "alveria-middleware-prod"
  create_db_subnet_group = false #Please investiigate ,change if necessary
  subnet_ids             = []
  timezone               = "GMT Standard Time"
  character_set_name     = "Latin1_General_CI_AS"

}

rds_custom_mssql_config_new = {
  engine                 = "custom-sqlserver-se"
  engine_version         = "15.00.4345.5.v1"
  family                 = "custom-sqlserver-se-15.0"
  major_engine_version   = "15.00"
  instance_class         = "db.r6i.large"
  allocated_storage      = 200
  storage_type           = "gp3"
  username               = "root"
  kms_key_arn            = "arn:aws:kms:eu-west-1:339712698801:key/20d1f313-a79e-48a2-a129-e6873fb1773e"
  db_subnet_group_name   = "alveria-middleware-prod"
  create_db_subnet_group = false #Please investiigate ,change if necessary
  subnet_ids             = []
  timezone               = "W. Europe Standard Time"
  character_set_name     = "Latin1_General_CI_AS"

}

######################################
# Scheduler
######################################

schedule_tag = {
  ec2_hcms       = "stopped"
  ec2_hcms_clone = "it-office-hours"
  rds            = "it-office-hours"
}

backup_tag = {
  hcms       = null
  hcms_clone = "true"
  ftp        = "true"
}
