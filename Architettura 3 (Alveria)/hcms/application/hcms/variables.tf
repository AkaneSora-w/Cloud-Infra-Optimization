######################################
# Global
######################################

variable "environment" {
  type = string
}
variable "service_name" {
  type = string
}
variable "owner" {
  type = string
}

######################################
# Networking
######################################

variable "networking" {
  type = object({
    vpc_id                        = string
    route53_zone_id               = string
    sg_public_alb_id              = string
    alb_public_https_listener_arn = string
    alb_public_http_listener_arn  = string
    alb_public_dns_name           = string
    alb_public_zone_id            = string
    sg_vpn_id                     = string
    dmz_cidr_block                = optional(string, "")
    az = object({
      ec2        = string
      rds_custom = string
    })
  })
}
variable "hcms_tg_cfg" {
  type = object({
    port                        = string
    health_check_path           = string
    domain_names                = list(string)
    collaudo_domain_names       = list(string)
    formazione_domain_names     = optional(list(string), [])
    backoffice_domain_names     = optional(list(string), [])
    zefiro_domain_names         = optional(list(string), [])
    jakala_domain_names         = optional(list(string), [])
    connector_api2_domain_names = optional(list(string), [])
  })
}

######################################
# EC2
######################################
variable "ec2_hcms_config" {
  type = map(object({
    create        = bool
    ami           = string
    instance_type = string
    volume_size   = number
    key_name      = string
    subnet_id     = string
    extra_ebs = optional(map(object({
      size = number
    })), {})
  }))
}

######################################
# RDS MSSQL
######################################

variable "rds_custom_mssql_config" {
  type = object({

    engine                 = string
    engine_version         = string
    family                 = string
    major_engine_version   = string
    instance_class         = string
    allocated_storage      = number
    storage_type           = string
    username               = string
    create_db_subnet_group = bool
    db_subnet_group_name   = string
    kms_key_arn            = string
    subnet_ids             = list(string)
    character_set_name     = string
    timezone               = string
  })

}

variable "rds_custom_mssql_config_new" {
  type = object({

    engine                 = string
    engine_version         = string
    family                 = string
    major_engine_version   = string
    instance_class         = string
    allocated_storage      = number
    storage_type           = string
    username               = string
    create_db_subnet_group = bool
    db_subnet_group_name   = string
    kms_key_arn            = string
    subnet_ids             = list(string)
    character_set_name     = string
    timezone               = string
  })

}


######################################
# Scheduler
######################################

variable "schedule_tag" {
  type = object({
    ec2_hcms       = string
    ec2_hcms_clone = string
    rds            = string
  })

  description = "Schedule tag to switch on/off resources"
}

variable "backup_tag" {
  type = object({
    hcms       = string
    hcms_clone = string
    ftp        = string
  })
  default = {
    hcms       = null
    hcms_clone = null
    ftp        = null
  }
  description = "Bakcup tag to switch on/off resources"
}

######################################
# EC2 FTP
######################################

variable "ec2_ftp_server" {
  type = object({
    create        = bool
    ami           = string
    instance_type = string
    volume_size   = number
    key_name      = string
  })

  default = {
    create        = false
    ami           = ""
    instance_type = ""
    volume_size   = 0
    key_name      = ""
  }
}