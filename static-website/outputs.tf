output "s3_bucket_id" {
  value = aws_s3_bucket.site.id
}

output "s3_bucket_endpoint" {
  value = aws_s3_bucket.site.bucket_domain_name
}

output "s3_bucket_website_endpoint" {
  value = aws_s3_bucket_website_configuration.site.website_endpoint
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.s3_distribution.id
}

output "cloudfront_distribution_domain_name" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "cloudfront_distribution_hosted_zone" {
  value = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
}

output "domain_name" {
  value = var.custom_domain_name
}

output "name_servers" {
  value = local.name_servers
}
output "next_steps" {
  value = var.custom_domain_name != null ? "Use the above name servers to point the domain at the distribution." : null
}