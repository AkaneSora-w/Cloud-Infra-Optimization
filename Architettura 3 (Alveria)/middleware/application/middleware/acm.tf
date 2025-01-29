
module "regional_certificate" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 5.0.1"

  for_each                  = var.certificates
  domain_name               = each.value.domain_name
  subject_alternative_names = each.value.subject_alternative_names

  zone_id                = each.value.zone_id
  validation_method      = each.value.validation_method
  create_route53_records = true
  wait_for_validation    = false

  depends_on = [module.zones]
}