resource "aws_cloudfront_origin_access_control" "cf_oac" {
  name = "s3-couldfront-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior = "always"
  signing_protocol = "sigv4"
}

resource "aws_cloudfront_cache_policy" "cf_cache_policy" {
  name = "cf-cache_policy"

  default_ttl = 3600
  max_ttl = 86400
  min_ttl = 0

  parameters_in_cache_key_and_forwarded_to_origin {
    query_strings_config {
      query_string_behavior = "none"
    }

    cookies_config {
      cookie_behavior = "none"
    }
    
    headers_config {
      header_behavior = "none"
    }
  }
}

resource "aws_cloudfront_distribution" "cf_distribution" {
  enabled = true
  is_ipv6_enabled = true
  default_root_object = "index.html"
  comment = "Distribuzione CloudFront per il sito statico"
  aliases = var.cloudfront_aliases

  origin {
    domain_name = aws_s3_bucket.cf_bucket.bucket_regional_domain_name
    origin_id = "bucket_default"
    origin_access_control_id = aws_cloudfront_origin_access_control.cf_oac.id
  }

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "bucket_default"
    viewer_protocol_policy = "redirect-to-https"
    # cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    cache_policy_id = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
  }

  dynamic "origin" {
    for_each = var.ec2_instances
    content {
      domain_name = origin.value.public_dns
      origin_id = "origin-${origin.value.work_env}"
        # origin_access_control_id = aws_cloudfront_origin_access_control.cf_oac.id
        custom_origin_config {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "http-only"
        origin_ssl_protocols   = ["TLSv1.2"]
      }
    }
  }

  dynamic "ordered_cache_behavior" {
    for_each = var.ec2_instances
    content {
      path_pattern = "/${ordered_cache_behavior.value.work_env}/*"
      target_origin_id = "origin-${ordered_cache_behavior.value.work_env}"

      viewer_protocol_policy = "redirect-to-https"

      allowed_methods = ["GET", "HEAD", "OPTIONS"]
      cached_methods = ["GET", "HEAD", "OPTIONS"]

      cache_policy_id = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
    }
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.cert.arn
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1.2_2019"
  }
  # depends_on = [ aws_route53_record.acm_validation ]
}

resource "aws_acm_certificate" "cert" {
  domain_name       = "tesi.awslab.epsilonline.com"
  validation_method = "DNS"
  provider = aws.virginia
  subject_alternative_names = [ "*.tesi.awslab.epsilonline.com" ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "acm_valid" {
  provider = aws.virginia
  certificate_arn = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.acm_validation: record.fqdn]
}
