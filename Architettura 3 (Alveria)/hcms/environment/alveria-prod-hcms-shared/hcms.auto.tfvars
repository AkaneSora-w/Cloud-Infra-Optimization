######################################
# Global
######################################

owner        = "alveria"
environment  = "prod"
service_name = "hcms-shared"
region       = "eu-west-1"

######################################
# Networking
######################################

networking = {
  vpc_id                        = "vpc-0576ab4be450f2d9c"
  route53_zone_id               = ""
  sg_public_alb_id              = "sg-0565c968eca8a3c6c"
  alb_public_https_listener_arn = "arn:aws:elasticloadbalancing:eu-west-1:891612549043:listener/app/alveria-prod-public-alb/889d0587646f4b4c/84e1478b99c6d30b"
  alb_public_http_listener_arn  = "arn:aws:elasticloadbalancing:eu-west-1:891612549043:listener/app/alveria-prod-public-alb/889d0587646f4b4c/2664175c63b87e85"
  alb_public_dns_name           = "alveria-prod-public-alb-1133306136.eu-west-1.elb.amazonaws.com"
  alb_public_zone_id            = "Z32O12XQLNTSW2"
  sg_vpn_id                     = "sg-00792e95dc0256885"
  dmz_cidr_block                = "10.101.3.0/24"
  az = {
    ec2        = "eu-west-1c"
    rds_custom = "eu-west-1c"
  }
}

hcms_tg_cfg = {
  port                        = "80"
  health_check_path           = "/"
  domain_names                = ["apiaws.prod.hcms.it", "art-admin.prod.hcms.it", "art.prod.hcms.it", "damico-admin.prod.hcms.it", "damico.prod.hcms.it"]
  collaudo_domain_names       = ["apiaws.collaudo.hcms.it", "art-admin.collaudo.hcms.it", "art.collaudo.hcms.it", "damico-admin.collaudo.hcms.it", "damico.collaudo.hcms.it"]
  zefiro_domain_names         = ["zefiro.collaudo.hcms.it", "zefiro-admin.collaudo.hcms.it", "connectorapi.collaudo.hcms.it"]
  jakala_domain_names         = ["jakala-admin.collaudo.hcms.it", "jakala.collaudo.hcms.it"]
  connector_api2_domain_names = ["connectorapi-02.collaudo.hcms.it"]
}

######################################
# EC2
######################################
ec2_hcms_config = {
  "hcms" = {
    create        = true
    ami           = "ami-09c5bdfbb0284812b"
    instance_type = "t3a.xlarge"
    subnet_id     = "subnet-05bee404114c72ddd"
    volume_size   = 50
    key_name      = "alveria-middleware-prod-key"
    extra_ebs = {
      "xvdb" = {
        size = 500
      }
    }
  },
  "hcms_clone" = {
    create        = false
    ami           = ""
    instance_type = ""
    subnet_id     = ""
    volume_size   = 0
    key_name      = ""
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
  kms_key_arn            = "arn:aws:kms:eu-west-1:891612549043:key/ee0e326f-74bb-468d-95ad-cc22effdcd87"
  db_subnet_group_name   = ""
  create_db_subnet_group = true
  subnet_ids             = ["subnet-00dffdd4d8c7a074a", "subnet-019fa4b2ac71bddff", "subnet-0ec5c1e5482cfb72b"]
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
  kms_key_arn            = "arn:aws:kms:eu-west-1:891612549043:key/ee0e326f-74bb-468d-95ad-cc22effdcd87"
  db_subnet_group_name   = ""
  create_db_subnet_group = true
  subnet_ids             = ["subnet-00dffdd4d8c7a074a", "subnet-019fa4b2ac71bddff", "subnet-0ec5c1e5482cfb72b"]
  timezone               = "W. Europe Standard Time"
  character_set_name     = "Latin1_General_CI_AS"

}

######################################
# Scheduler
######################################

schedule_tag = {
  ec2_hcms       = "it-office-hours"
  ec2_hcms_clone = "stopped"
  rds            = "it-office-hours"
}

backup_tag = {
  hcms       = "true"
  hcms_clone = null
  ftp        = "true"
}


######################################
# EC2 FTP
######################################

ec2_ftp_server = {
  create        = true
  ami           = "ami-0600784ba5c5c8073"
  instance_type = "t4g.small"
  volume_size   = 500
  key_name      = "alveria-middleware-prod-key"
}