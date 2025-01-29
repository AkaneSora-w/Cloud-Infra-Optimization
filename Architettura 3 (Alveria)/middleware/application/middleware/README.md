# middleware

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.47.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.47.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ec2_openvpn"></a> [ec2\_openvpn](#module\_ec2\_openvpn) | terraform-aws-modules/ec2-instance/aws | ~> 5.6.1 |
| <a name="module_public_alb"></a> [public\_alb](#module\_public\_alb) | terraform-aws-modules/alb/aws | ~> 9.9.0 |
| <a name="module_regional_certificate"></a> [regional\_certificate](#module\_regional\_certificate) | terraform-aws-modules/acm/aws | ~> 5.0.1 |
| <a name="module_sg_openvpn"></a> [sg\_openvpn](#module\_sg\_openvpn) | terraform-aws-modules/security-group/aws | ~> 5.1.2 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 5.8.1 |
| <a name="module_zones"></a> [zones](#module\_zones) | terraform-aws-modules/route53/aws//modules/zones | ~> 2.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudformation_stack.scheduler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack) | resource |
| [aws_ec2_transit_gateway_vpc_attachment.centralized_networking](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment) | resource |
| [aws_eip.openvpn_ip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_eip_association.openvpn_ip_assoc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip_association) | resource |
| [aws_iam_instance_profile.ec2_iam_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.ec2_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_key_pair.ec2_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_kms_alias.rds_key_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.rds_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key.shared_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key_policy.kms_shared_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key_policy) | resource |
| [aws_route.centralized](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy.managed_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_private_subnets"></a> [app\_private\_subnets](#input\_app\_private\_subnets) | CIDR of the application private subnets | `list(string)` | n/a | yes |
| <a name="input_central_transit_gateway_id"></a> [central\_transit\_gateway\_id](#input\_central\_transit\_gateway\_id) | Id of transit gateway for centralized outgress | `string` | `null` | no |
| <a name="input_certificates"></a> [certificates](#input\_certificates) | n/a | <pre>map(object({<br>    domain_name               = string<br>    subject_alternative_names = optional(list(string), [])<br>    zone_id                   = optional(string, "")<br>    validation_method         = optional(string, "DNS")<br>  }))</pre> | n/a | yes |
| <a name="input_create_alb"></a> [create\_alb](#input\_create\_alb) | Create an Application Load Balancer | `bool` | `true` | no |
| <a name="input_create_kms_key"></a> [create\_kms\_key](#input\_create\_kms\_key) | Create a KMS key for the S3 bucket | `bool` | `false` | no |
| <a name="input_create_kms_key_shared"></a> [create\_kms\_key\_shared](#input\_create\_kms\_key\_shared) | Create a shared KMS key for the S3 bucket | `bool` | `false` | no |
| <a name="input_create_openvpn"></a> [create\_openvpn](#input\_create\_openvpn) | Create an OpenVPN instance | `bool` | `false` | no |
| <a name="input_db_private_subnets"></a> [db\_private\_subnets](#input\_db\_private\_subnets) | CIDR of the database private subnets | `list(string)` | n/a | yes |
| <a name="input_ec2_openvpn_config"></a> [ec2\_openvpn\_config](#input\_ec2\_openvpn\_config) | ##################################### EC2 OPENVPN ##################################### | <pre>object({<br>    ami           = string<br>    instance_type = string<br>    volume_size   = number<br>  })</pre> | <pre>{<br>  "ami": "",<br>  "instance_type": "",<br>  "volume_size": 8<br>}</pre> | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ##################################### Global ##################################### | `string` | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | n/a | `string` | n/a | yes |
| <a name="input_public_subnet_ids"></a> [public\_subnet\_ids](#input\_public\_subnet\_ids) | List of public subnet IDs | `list(string)` | `[]` | no |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | CIDR of the public-facing subnets | `list(string)` | n/a | yes |
| <a name="input_schedule_tag"></a> [schedule\_tag](#input\_schedule\_tag) | Schedule tag to switch on/off resources | <pre>object({<br>    ec2 = string<br>  })</pre> | <pre>{<br>  "ec2": "it-office-hours"<br>}</pre> | no |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | n/a | `string` | n/a | yes |
| <a name="input_use_centralized_nat"></a> [use\_centralized\_nat](#input\_use\_centralized\_nat) | If true not create dedicated nat but use shared nat trougth transit gateway | `bool` | `true` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR of the VPC to create | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID to use if VPC mode is centralized | `string` | `"vpc-0576ab4be450f2d9c"` | no |
| <a name="input_vpc_mode"></a> [vpc\_mode](#input\_vpc\_mode) | VPC network mode. If dedicated the VPC need have at least a dedicated Internet Gateway and VPN. If centralized Internet and VPN need to be centralized in organization, and VPN haven't a security group | `string` | `"centralized"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_certificates"></a> [certificates](#output\_certificates) | n/a |
| <a name="output_public_alb_info"></a> [public\_alb\_info](#output\_public\_alb\_info) | n/a |
| <a name="output_route53_zones"></a> [route53\_zones](#output\_route53\_zones) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
