resource "aws_s3_bucket" "site" {
  bucket = var.bucket_name

  tags = merge(
    { Name = var.bucket_name },
    var.bucket_tags
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

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = var.index_document

  # logging_config {
  #   include_cookies = false
  #   bucket          = "mylogs.s3.amazonaws.com"
  #   prefix          = "myprefix"
  # }

  #aliases = var.aliases

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"] #["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
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

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none" #"whitelist"
      locations        = []     #["US", "CA", "GB", "DE"]
    }
  }

  #tags = var.cloudfront_tags

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}