variable "region" {
  type        = string
  description = "The region in which the bucket(s) will deployed. Note that the CDN can be deployed across regions."
}

variable "custom_domain_name" {
  type        = string
  default     = null
  description = "Custom domain to use. Leave unset to use cloudfront domain only."

}

variable "bucket_name" {
  type        = string
  description = "The name of the S3 bucket where the site assets will be stored."
}

variable "tags_default" {
  type = map(string)
  default = {
    "Terraform" = "True"
  }
  description = "Tags to apply to all resources in this module."
}

variable "tags_bucket" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to the S3 bucket created by this module."
}

variable "tags_cloudfront" {
  type    = map(string)
  default = {}
}

variable "tags_route53" {
  type    = map(string)
  default = {}
}

variable "index_document" {
  type    = string
  default = "index.html"
}

variable "error_document" {
  type    = string
  default = "error.html"
}

variable "price_class" {
  type        = string
  default     = "PriceClass_All"
  description = <<EOF
    The price class for this distribution. One of "PriceClass_All", "PriceClass_200", "PriceClass_100".
    See [cloudfront docs](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/PriceClass.html) for further details."
  EOF
}

variable "default_cache_allowed_methods" {
  type        = list(string)
  default     = ["GET", "HEAD"]
  description = <<EOF
    Supported lists are:
    - ["GET", "HEAD"]
    - ["GET", "HEAD", "OPTIONS"]
    - ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    See [cloudfront docs](https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_AllowedMethods.html) for further details.
  EOF
}

variable "default_cache_cached_methods" {
  type        = list(string)
  default     = ["GET", "HEAD"]
  description = <<EOF
    Supported lists are:
    - ["GET", "HEAD"]
    - ["GET", "HEAD", "OPTIONS"]
    See [cloudfront docs](https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_CachedMethods.html) for further details.
  EOF
}


variable "geo_restriction" {
  type = object({
    restriction_type = optional(string, "none")
    locations        = optional(list(string), [])
  })
  default     = {}
  description = <<EOF
    Geo restrictions to apply to the cloudfront distribution.

    Restriction types: One of "none", "whitelist", or "blacklist"
    Locations:  List of ISO 3166-1-alpha-2 codes the restriction type applies to, e.g. ["US", "CA", "GB", "DE"]
    
    Default behaviour is no restrictions.
  EOF
}