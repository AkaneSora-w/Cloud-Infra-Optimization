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
| <a name="input_certificates"></a> [certificates](#input\_certificates) | n/a | <pre>map(object({<br>    domain_name               = string<br>    subject_alternative_names = optional(list(string), [])<br>    zone_id                   = optional(string, "")<br>    validation_method         = optional(string, "DNS")<br>  }))</pre> | n/a | yes |
| <a name="input_create_alb"></a> [create\_alb](#input\_create\_alb) | Create an Application Load Balancer | `bool` | `true` | no |
| <a name="input_create_kms_key"></a> [create\_kms\_key](#input\_create\_kms\_key) | Create a KMS key for the S3 bucket | `bool` | n/a | yes |
| <a name="input_create_kms_key_shared"></a> [create\_kms\_key\_shared](#input\_create\_kms\_key\_shared) | Create a shared KMS key for the S3 bucket | `bool` | `false` | no |
| <a name="input_db_private_subnets"></a> [db\_private\_subnets](#input\_db\_private\_subnets) | CIDR of the database private subnets | `list(string)` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | n/a | `string` | n/a | yes |
| <a name="input_public_subnet_ids"></a> [public\_subnet\_ids](#input\_public\_subnet\_ids) | List of public subnet IDs | `list(string)` | n/a | yes |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | CIDR of the public-facing subnets | `list(string)` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | n/a | yes |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | n/a | `string` | n/a | yes |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR of the VPC to create | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_certificates"></a> [certificates](#output\_certificates) | n/a |
| <a name="output_public_alb_info"></a> [public\_alb\_info](#output\_public\_alb\_info) | n/a |
| <a name="output_route53_zones"></a> [route53\_zones](#output\_route53\_zones) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
