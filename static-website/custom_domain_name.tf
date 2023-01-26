locals {
  is_custom_domain = var.custom_domain_name != null ? 1 : 0
}

data "aws_route53_zone" "site" {
  provider = aws.global
  count    = local.is_custom_domain
  name     = var.custom_domain_name
}

resource "aws_route53_record" "site_A" {
  provider = aws.global
  count    = local.is_custom_domain

  zone_id = data.aws_route53_zone.site[0].zone_id
  name    = var.custom_domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_acm_certificate" "cert" {
  provider = aws.global
  count    = local.is_custom_domain

  domain_name               = var.custom_domain_name
  subject_alternative_names = ["*.${var.custom_domain_name}"]

  validation_method = "DNS"



  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  provider = aws.global

  for_each = var.custom_domain_name != null ? {
    for dvo in aws_acm_certificate.cert[0].domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  } : {}

  # The same record may be created more than once by the above loop,
  # allowing overwrite resolves any errors
  allow_overwrite = true

  name    = each.value.name
  records = [each.value.record]
  ttl     = 60
  type    = each.value.type
  zone_id = data.aws_route53_zone.site[0].zone_id
}

resource "aws_acm_certificate_validation" "cert" {
  provider = aws.global
  count    = local.is_custom_domain

  certificate_arn         = aws_acm_certificate.cert[0].arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}