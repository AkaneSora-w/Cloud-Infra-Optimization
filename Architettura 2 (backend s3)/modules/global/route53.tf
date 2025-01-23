resource "aws_route53_zone" "r53_zone" {
  name = "tesi.awslab.epsilonline.com"
}

resource "aws_route53_record" "acm_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name    = dvo.resource_record_name
      record  = dvo.resource_record_value
      type    = dvo.resource_record_type
      zone_id = aws_route53_zone.r53_zone.id
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = each.value.zone_id
  # zone_id = aws_route53_zone.r53_zone.zone_id
}

resource "aws_route53_record" "root" {
  name = ""
  type = "A"
  zone_id = aws_route53_zone.r53_zone.id

  alias {
    name = aws_cloudfront_distribution.cf_distribution.domain_name
    zone_id = aws_cloudfront_distribution.cf_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www" {
  name = "www"
  type = "A"
  zone_id = aws_route53_zone.r53_zone.id

  alias {
    name = aws_cloudfront_distribution.cf_distribution.domain_name
    zone_id = aws_cloudfront_distribution.cf_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}