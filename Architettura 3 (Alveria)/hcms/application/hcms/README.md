# hcms

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.47.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.6.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.47.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ec2_ftp_server"></a> [ec2\_ftp\_server](#module\_ec2\_ftp\_server) | terraform-aws-modules/ec2-instance/aws | ~> 5.6.1 |
| <a name="module_ec2_hcms"></a> [ec2\_hcms](#module\_ec2\_hcms) | terraform-aws-modules/ec2-instance/aws | ~> 5.6.1 |
| <a name="module_ec2_hcms_clone"></a> [ec2\_hcms\_clone](#module\_ec2\_hcms\_clone) | terraform-aws-modules/ec2-instance/aws | ~> 5.6.1 |
| <a name="module_rds_custom_mssql"></a> [rds\_custom\_mssql](#module\_rds\_custom\_mssql) | terraform-aws-modules/rds/aws | ~> 6.5.5 |
| <a name="module_rds_custom_mssql_new"></a> [rds\_custom\_mssql\_new](#module\_rds\_custom\_mssql\_new) | terraform-aws-modules/rds/aws | ~> 6.5.5 |
| <a name="module_s3_bucket"></a> [s3\_bucket](#module\_s3\_bucket) | terraform-aws-modules/s3-bucket/aws | ~> 4.1.2 |
| <a name="module_sg_custom_mssql"></a> [sg\_custom\_mssql](#module\_sg\_custom\_mssql) | terraform-aws-modules/security-group/aws | ~> 5.1.2 |
| <a name="module_sg_ftp"></a> [sg\_ftp](#module\_sg\_ftp) | terraform-aws-modules/security-group/aws | ~> 5.1.2 |
| <a name="module_sg_hcms"></a> [sg\_hcms](#module\_sg\_hcms) | terraform-aws-modules/security-group/aws | ~> 5.1.2 |

## Resources

| Name | Type |
|------|------|
| [aws_ebs_volume.extra_hcms_clone_ebs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_volume) | resource |
| [aws_ebs_volume.extra_hcms_ebs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_volume) | resource |
| [aws_iam_instance_profile.ec2_iam_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_instance_profile.rds_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.ec2_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.rds_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.backup_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.ec2_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.rds_custom_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.s3_inline_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.rds_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachments_exclusive.ec2_role_policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachments_exclusive) | resource |
| [aws_iam_role_policy_attachments_exclusive.rds_custom_role_policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachments_exclusive) | resource |
| [aws_lb_listener_rule.backoffice_hcms_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_listener_rule.collaudo_hcms_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_listener_rule.connector_api_2_hcms_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_listener_rule.formazione_hcms_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_listener_rule.hcms_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_listener_rule.jakala_hcms_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_listener_rule.zefiro_hcms_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_target_group.hcms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group_attachment.ec2_hcms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_lb_target_group_attachment.ec2_hcms_clone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_network_acl.dmz](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_network_acl_association.dmz_nacl_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_association) | resource |
| [aws_route_table.dmz_rt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.dmz_rt_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.dmz](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_volume_attachment.extra_ebs_hcms_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/volume_attachment) | resource |
| [aws_volume_attachment.extra_ebs_hcms_clone_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/volume_attachment) | resource |
| [random_password.custom_rds_password](https://registry.terraform.io/providers/hashicorp/random/3.6.2/docs/resources/password) | resource |
| [aws_iam_policy.managed_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy.managed_policy_rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_internet_gateway.ig](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/internet_gateway) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_tag"></a> [backup\_tag](#input\_backup\_tag) | Bakcup tag to switch on/off resources | <pre>object({<br>    hcms       = string<br>    hcms_clone = string<br>    ftp        = string<br>  })</pre> | <pre>{<br>  "ftp": null,<br>  "hcms": null,<br>  "hcms_clone": null<br>}</pre> | no |
| <a name="input_ec2_ftp_server"></a> [ec2\_ftp\_server](#input\_ec2\_ftp\_server) | n/a | <pre>object({<br>    create        = bool<br>    ami           = string<br>    instance_type = string<br>    volume_size   = number<br>    key_name      = string<br>  })</pre> | <pre>{<br>  "ami": "",<br>  "create": false,<br>  "instance_type": "",<br>  "key_name": "",<br>  "volume_size": 0<br>}</pre> | no |
| <a name="input_ec2_hcms_config"></a> [ec2\_hcms\_config](#input\_ec2\_hcms\_config) | ##################################### EC2 ##################################### | <pre>map(object({<br>    create        = bool<br>    ami           = string<br>    instance_type = string<br>    volume_size   = number<br>    key_name      = string<br>    subnet_id     = string<br>    extra_ebs = optional(map(object({<br>      size = number<br>    })), {})<br>  }))</pre> | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | n/a | yes |
| <a name="input_hcms_tg_cfg"></a> [hcms\_tg\_cfg](#input\_hcms\_tg\_cfg) | n/a | <pre>object({<br>    port                        = string<br>    health_check_path           = string<br>    domain_names                = list(string)<br>    collaudo_domain_names       = list(string)<br>    formazione_domain_names     = optional(list(string), [])<br>    backoffice_domain_names     = optional(list(string), [])<br>    zefiro_domain_names         = optional(list(string), [])<br>    jakala_domain_names         = optional(list(string), [])<br>    connector_api2_domain_names = optional(list(string), [])<br>  })</pre> | n/a | yes |
| <a name="input_networking"></a> [networking](#input\_networking) | n/a | <pre>object({<br>    vpc_id                        = string<br>    route53_zone_id               = string<br>    sg_public_alb_id              = string<br>    alb_public_https_listener_arn = string<br>    alb_public_http_listener_arn  = string<br>    alb_public_dns_name           = string<br>    alb_public_zone_id            = string<br>    sg_vpn_id                     = string<br>    dmz_cidr_block                = optional(string, "")<br>    az = object({<br>      ec2        = string<br>      rds_custom = string<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | n/a | `string` | n/a | yes |
| <a name="input_rds_custom_mssql_config"></a> [rds\_custom\_mssql\_config](#input\_rds\_custom\_mssql\_config) | n/a | <pre>object({<br><br>    engine                 = string<br>    engine_version         = string<br>    family                 = string<br>    major_engine_version   = string<br>    instance_class         = string<br>    allocated_storage      = number<br>    storage_type           = string<br>    username               = string<br>    create_db_subnet_group = bool<br>    db_subnet_group_name   = string<br>    kms_key_arn            = string<br>    subnet_ids             = list(string)<br>    character_set_name     = string<br>    timezone               = string<br>  })</pre> | n/a | yes |
| <a name="input_rds_custom_mssql_config_new"></a> [rds\_custom\_mssql\_config\_new](#input\_rds\_custom\_mssql\_config\_new) | n/a | <pre>object({<br><br>    engine                 = string<br>    engine_version         = string<br>    family                 = string<br>    major_engine_version   = string<br>    instance_class         = string<br>    allocated_storage      = number<br>    storage_type           = string<br>    username               = string<br>    create_db_subnet_group = bool<br>    db_subnet_group_name   = string<br>    kms_key_arn            = string<br>    subnet_ids             = list(string)<br>    character_set_name     = string<br>    timezone               = string<br>  })</pre> | n/a | yes |
| <a name="input_schedule_tag"></a> [schedule\_tag](#input\_schedule\_tag) | Schedule tag to switch on/off resources | <pre>object({<br>    ec2_hcms       = string<br>    ec2_hcms_clone = string<br>    rds            = string<br>  })</pre> | n/a | yes |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
