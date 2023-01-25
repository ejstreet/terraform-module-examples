# Static Website
This module deploys an S3 bucket and Cloudfront CDN, with the option of using a custom domain complete with TLS, in order to deploy a website.

The only required variables are the AWS `region` where the bucket will be deployed, and the unique `bucket_name`. This bucket will then be accessible via cloudfront at the `cloudfront_distribution_domain_name` given as output.

The variable `custom_domain_name` can be passed to the module to deploy the resources required to support it. The module will create a hosted zone, or if one already exists, then records can be deployed there by setting `create_hosted_zone` to `false`. The module will provide a `name_servers` output to configure your domain name provider.

## Uploading to the bucket
The site files can be uploaded to S3 bucket using the AWSCLI. If the site is updated often, it is recommended to use `--cache-control` headers on the `index.html` to either disable or set a short cache duration.

This can be done using the following commands:
```bash
aws s3 sync index.html s3://yourbucket/ --cache-control max-age=60
aws s3 sync /path s3://yourbucket/ --cache-control max-age=604800 --recursive --exclude index.html
```

# Module details

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.50 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.51.0 |
| <a name="provider_aws.global"></a> [aws.global](#provider\_aws.global) | 4.51.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) | resource |
| [aws_cloudfront_distribution.s3_distribution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_route53_record.cert_validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.site_A](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.site](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [aws_s3_bucket.site](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.site](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_website_configuration.site](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration) | resource |
| [aws_route53_zone.site](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | The name of the S3 bucket where the site assets will be stored. | `string` | n/a | yes |
| <a name="input_create_hosted_zone"></a> [create\_hosted\_zone](#input\_create\_hosted\_zone) | Set to true to create a hosted zone based on the custom domain name. False will use an existing zone as a data source. | `bool` | `true` | no |
| <a name="input_custom_domain_name"></a> [custom\_domain\_name](#input\_custom\_domain\_name) | Custom domain to use. Leave unset to use cloudfront domain only. | `string` | `null` | no |
| <a name="input_default_cache_allowed_methods"></a> [default\_cache\_allowed\_methods](#input\_default\_cache\_allowed\_methods) | Supported lists are:<br>    - ["GET", "HEAD"]<br>    - ["GET", "HEAD", "OPTIONS"]<br>    - ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]<br>    See [cloudfront docs](https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_AllowedMethods.html) for further details. | `list(string)` | <pre>[<br>  "GET",<br>  "HEAD"<br>]</pre> | no |
| <a name="input_default_cache_cached_methods"></a> [default\_cache\_cached\_methods](#input\_default\_cache\_cached\_methods) | Supported lists are:<br>    - ["GET", "HEAD"]<br>    - ["GET", "HEAD", "OPTIONS"]<br>    See [cloudfront docs](https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_CachedMethods.html) for further details. | `list(string)` | <pre>[<br>  "GET",<br>  "HEAD"<br>]</pre> | no |
| <a name="input_error_document"></a> [error\_document](#input\_error\_document) | n/a | `string` | `"error.html"` | no |
| <a name="input_geo_restriction"></a> [geo\_restriction](#input\_geo\_restriction) | Geo restrictions to apply to the cloudfront distribution.<br><br>    Restriction types: One of "none", "whitelist", or "blacklist"<br>    Locations:  List of ISO 3166-1-alpha-2 codes the restriction type applies to, e.g. ["US", "CA", "GB", "DE"]<br><br>    Default behaviour is no restrictions. | <pre>object({<br>    restriction_type = optional(string, "none")<br>    locations        = optional(list(string), [])<br>  })</pre> | `{}` | no |
| <a name="input_index_document"></a> [index\_document](#input\_index\_document) | n/a | `string` | `"index.html"` | no |
| <a name="input_price_class"></a> [price\_class](#input\_price\_class) | The price class for this distribution. One of "PriceClass\_All", "PriceClass\_200", "PriceClass\_100".<br>    See [cloudfront docs](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/PriceClass.html) for further details." | `string` | `"PriceClass_All"` | no |
| <a name="input_region"></a> [region](#input\_region) | The region in which the bucket(s) will deployed. Note that the CDN can be deployed across regions. | `string` | n/a | yes |
| <a name="input_tags_bucket"></a> [tags\_bucket](#input\_tags\_bucket) | Tags to apply to the S3 bucket created by this module. | `map(string)` | `{}` | no |
| <a name="input_tags_cloudfront"></a> [tags\_cloudfront](#input\_tags\_cloudfront) | n/a | `map(string)` | `{}` | no |
| <a name="input_tags_default"></a> [tags\_default](#input\_tags\_default) | Tags to apply to all resources in this module. | `map(string)` | <pre>{<br>  "Terraform": "True"<br>}</pre> | no |
| <a name="input_tags_route53"></a> [tags\_route53](#input\_tags\_route53) | n/a | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudfront_distribution_domain_name"></a> [cloudfront\_distribution\_domain\_name](#output\_cloudfront\_distribution\_domain\_name) | n/a |
| <a name="output_cloudfront_distribution_hosted_zone"></a> [cloudfront\_distribution\_hosted\_zone](#output\_cloudfront\_distribution\_hosted\_zone) | n/a |
| <a name="output_cloudfront_distribution_id"></a> [cloudfront\_distribution\_id](#output\_cloudfront\_distribution\_id) | n/a |
| <a name="output_domain_name"></a> [domain\_name](#output\_domain\_name) | n/a |
| <a name="output_name_servers"></a> [name\_servers](#output\_name\_servers) | n/a |
| <a name="output_next_steps"></a> [next\_steps](#output\_next\_steps) | n/a |
| <a name="output_s3_bucket_endpoint"></a> [s3\_bucket\_endpoint](#output\_s3\_bucket\_endpoint) | n/a |
| <a name="output_s3_bucket_id"></a> [s3\_bucket\_id](#output\_s3\_bucket\_id) | n/a |
| <a name="output_s3_bucket_website_endpoint"></a> [s3\_bucket\_website\_endpoint](#output\_s3\_bucket\_website\_endpoint) | n/a |