output "route53_zones" {
  value = try(module.zones[0].route53_zone_zone_id, null)
}

output "public_alb_info" {
  value = try({
    arn               = module.public_alb[0].zone_id
    security_group_id = module.public_alb[0].security_group_id
    dns_name          = module.public_alb[0].dns_name
    zone_id           = module.public_alb[0].zone_id
  }, null)
}

output "certificates" {
  value = [for cert in module.regional_certificate : cert.acm_certificate_arn]
}