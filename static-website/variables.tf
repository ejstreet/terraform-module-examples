variable "region" {
  type        = string
  description = "The region in which the bucket(s) will deployed. Note that the CDN can be deployed across regions."
}

variable "custom_domain_name" {
  type        = string
  default     = null
  description = "Custom domain to use. Leave unset to use cloudfront domain only."

}

variable "create_hosted_zone" {
  type        = bool
  default     = true
  description = "Set to true to create a hosted zone based on the custom domain name. False will use an existing zone as a data source."
}

variable "bucket_name" {
  type        = string
  description = "The name of the S3 bucket where the site assets will be stored."
}

variable "default_tags" {
  type = map(string)
  default = {
    "Terraform" = "True"
  }
  description = "Tags to apply to all resources in this module."
}

variable "bucket_tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to the S3 bucket created by this module."
}

variable "cloudfront_tags" {
  type    = map(string)
  default = {}
}

variable "route53_tags" {
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