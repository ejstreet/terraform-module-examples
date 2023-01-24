variable "region" {
  type        = string
  description = "The region in which the bucket(s) will deployed. Note that the CDN can be deployed across regions."
}

variable "bucket_name" {
  type        = string
  description = "The name of the S3 bucket where the site assets will be stored."
}

variable "default_tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to all resources in this module."
}

variable "bucket_tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to the S3 bucket created by this module."
}

variable "index_document" {
  type    = string
  default = "index.html"
}

variable "error_document" {
  type    = string
  default = "error.html"
}
