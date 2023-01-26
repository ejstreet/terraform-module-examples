resource "aws_s3_bucket" "site" {
  bucket = var.bucket_name

  tags = merge(
    { Name = var.bucket_name },
    var.tags_bucket
  )
}

resource "aws_s3_bucket_acl" "site" {
  bucket = aws_s3_bucket.site.id
  acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "site" {
  bucket = aws_s3_bucket.site.id

  index_document {
    suffix = var.index_document
  }

  error_document {
    key = var.error_document
  }
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  provider = aws.global

  origin {
    connection_attempts = 3
    connection_timeout  = 10
    domain_name         = aws_s3_bucket_website_configuration.site.website_endpoint
    origin_id           = aws_s3_bucket.site.id

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "http-only"
      origin_read_timeout      = 30
      origin_ssl_protocols = [
        "TLSv1.2",
      ]
    }
  }

  aliases = var.custom_domain_name != null ? [var.custom_domain_name] : []

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = var.index_document

  default_cache_behavior {
    allowed_methods  = var.default_cache_allowed_methods #["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = var.default_cache_cached_methods  # ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.site.id

    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  price_class = var.price_class

  restrictions {
    geo_restriction {
      restriction_type = var.geo_restriction.restriction_type
      locations        = var.geo_restriction.locations
    }
  }

  tags = var.tags_cloudfront

  viewer_certificate {
    cloudfront_default_certificate = var.custom_domain_name == null
    acm_certificate_arn            = var.custom_domain_name != null ? aws_acm_certificate.cert[0].arn : null
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = var.custom_domain_name != null ? "sni-only" : null
  }
}
