# environment

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.47.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_hcms"></a> [hcms](#module\_hcms) | ../../application/hcms | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_tag"></a> [backup\_tag](#input\_backup\_tag) | Bakcup tag to switch on/off resources | <pre>object({<br>    hcms       = string<br>    hcms_clone = string<br>    ftp        = string<br>  })</pre> | n/a | yes |
| <a name="input_ec2_ftp_server"></a> [ec2\_ftp\_server](#input\_ec2\_ftp\_server) | n/a | <pre>object({<br>    create        = bool<br>    ami           = string<br>    instance_type = string<br>    volume_size   = number<br>    key_name      = string<br>  })</pre> | n/a | yes |
| <a name="input_ec2_hcms_config"></a> [ec2\_hcms\_config](#input\_ec2\_hcms\_config) | ##################################### EC2 ##################################### | <pre>map(object({<br>    create        = bool<br>    ami           = string<br>    instance_type = string<br>    volume_size   = number<br>    key_name      = string<br>    subnet_id     = string<br>    extra_ebs = optional(map(object({<br>      size = number<br>    })), {})<br>  }))</pre> | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | n/a | yes |
| <a name="input_hcms_tg_cfg"></a> [hcms\_tg\_cfg](#input\_hcms\_tg\_cfg) | n/a | <pre>object({<br>    port                        = string<br>    health_check_path           = string<br>    domain_names                = list(string)<br>    collaudo_domain_names       = list(string)<br>    zefiro_domain_names         = optional(list(string), [])<br>    jakala_domain_names         = optional(list(string), [])<br>    connector_api2_domain_names = optional(list(string), [])<br>  })</pre> | n/a | yes |
| <a name="input_networking"></a> [networking](#input\_networking) | n/a | <pre>object({<br>    vpc_id                        = string<br>    route53_zone_id               = string<br>    sg_public_alb_id              = string<br>    alb_public_https_listener_arn = string<br>    alb_public_http_listener_arn  = string<br>    alb_public_dns_name           = string<br>    alb_public_zone_id            = string<br>    sg_vpn_id                     = string<br>    dmz_cidr_block                = optional(string)<br>    az = object({<br>      ec2        = string<br>      rds_custom = string<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | n/a | `string` | n/a | yes |
| <a name="input_rds_custom_mssql_config"></a> [rds\_custom\_mssql\_config](#input\_rds\_custom\_mssql\_config) | ##################################### RDS MSSQL ##################################### | <pre>object({<br><br>    engine                 = string<br>    engine_version         = string<br>    family                 = string<br>    major_engine_version   = string<br>    instance_class         = string<br>    allocated_storage      = number<br>    storage_type           = string<br>    username               = string<br>    create_db_subnet_group = bool<br>    db_subnet_group_name   = string<br>    kms_key_arn            = string<br>    subnet_ids             = list(string)<br>    character_set_name     = string<br>    timezone               = string<br>  })</pre> | n/a | yes |
| <a name="input_rds_custom_mssql_config_new"></a> [rds\_custom\_mssql\_config\_new](#input\_rds\_custom\_mssql\_config\_new) | n/a | <pre>object({<br><br>    engine                 = string<br>    engine_version         = string<br>    family                 = string<br>    major_engine_version   = string<br>    instance_class         = string<br>    allocated_storage      = number<br>    storage_type           = string<br>    username               = string<br>    create_db_subnet_group = bool<br>    db_subnet_group_name   = string<br>    kms_key_arn            = string<br>    subnet_ids             = list(string)<br>    character_set_name     = string<br>    timezone               = string<br>  })</pre> | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | n/a | yes |
| <a name="input_schedule_tag"></a> [schedule\_tag](#input\_schedule\_tag) | Schedule tag to switch on/off resources | <pre>object({<br>    ec2_hcms       = string<br>    ec2_hcms_clone = string<br>    rds            = string<br>  })</pre> | n/a | yes |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
