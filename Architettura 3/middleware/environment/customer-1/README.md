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
| <a name="module_middleware"></a> [middleware](#module\_middleware) | ../../application/middleware | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_private_subnets"></a> [app\_private\_subnets](#input\_app\_private\_subnets) | CIDR of the application private subnets | `list(string)` | n/a | yes |
| <a name="input_central_transit_gateway_id"></a> [central\_transit\_gateway\_id](#input\_central\_transit\_gateway\_id) | Id of transit gateway for centralized outgress | `string` | `null` | no |
| <a name="input_certificates"></a> [certificates](#input\_certificates) | n/a | <pre>map(object({<br>    domain_name               = string<br>    subject_alternative_names = optional(list(string), [])<br>    zone_id                   = optional(string, "")<br>    validation_method         = optional(string, "DNS")<br>  }))</pre> | n/a | yes |
| <a name="input_create_kms_key"></a> [create\_kms\_key](#input\_create\_kms\_key) | Create a KMS key for the S3 bucket | `bool` | `false` | no |
| <a name="input_db_private_subnets"></a> [db\_private\_subnets](#input\_db\_private\_subnets) | CIDR of the database private subnets | `list(string)` | n/a | yes |
| <a name="input_ec2_openvpn_config"></a> [ec2\_openvpn\_config](#input\_ec2\_openvpn\_config) | ##################################### EC2 OPENVPN ##################################### | <pre>object({<br>    ami           = string<br>    instance_type = string<br>    volume_size   = number<br>  })</pre> | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | n/a | `string` | n/a | yes |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | CIDR of the public-facing subnets | `list(string)` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | n/a | yes |
| <a name="input_schedule_tag"></a> [schedule\_tag](#input\_schedule\_tag) | Schedule tag to switch on/off resources | <pre>object({<br>    ec2 = string<br>  })</pre> | n/a | yes |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | n/a | `string` | n/a | yes |
| <a name="input_use_centralized_nat"></a> [use\_centralized\_nat](#input\_use\_centralized\_nat) | If true not create dedicated nat but use shared nat trougth transit gateway | `bool` | `false` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR of the VPC to create | `string` | n/a | yes |
| <a name="input_vpc_mode"></a> [vpc\_mode](#input\_vpc\_mode) | VPC network mode. If dedicated the VPC need have at least a dedicated Internet Gateway and VPN. If centralized Internet and VPN need to be centralized in organization, and VPN haven't a security group | `string` | `"centralized"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_certificates"></a> [certificates](#output\_certificates) | n/a |
| <a name="output_public_alb_info"></a> [public\_alb\_info](#output\_public\_alb\_info) | n/a |
| <a name="output_route53_zones"></a> [route53\_zones](#output\_route53\_zones) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
