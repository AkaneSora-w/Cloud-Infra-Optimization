output "route53_zones" {
  value = module.middleware.route53_zones
}

output "public_alb_info" {
  value = module.middleware.public_alb_info
}

output "certificates" {
  value = [module.middleware.certificates]
}