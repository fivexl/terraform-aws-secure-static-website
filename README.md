[![FivexL](https://releases.fivexl.io/fivexlbannergit.jpg)](https://fivexl.io/)

# terraform-aws-secure-static-website
S3, CloudFront, Dynamic Lambda@Edge functions. Based on Terraform AWS modules

## Example

```hcl 
data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  logging_bucket_name = "access-logs-${md5(format("%s-%s", data.aws_caller_identity.current.account_id, data.aws_region.current.name))}"
  s3_bucket_name      = "web-service-${md5(format("%s-%s", data.aws_caller_identity.current.account_id, data.aws_region.current.name))}"
}

module "website" {
  source                        = "../"
  acm_domain_name               = "*.example.com"
  aliases                       = ["tewfew23d23as.example.com", "zs3ft6ers3as.example.com"]
  logging_bucket_name           = local.logging_bucket_name
  s3_bucket_name                = local.s3_bucket_name
  forwarded_values_query_string = true
  include_cookies               = true
  custom_error_response = {
    error404 = {
      error_code            = 404
      error_caching_min_ttl = 300
      response_code         = 200
      response_page_path    = "/404/index.html"
    }
  }
  lambda_origin_response = {
    create        = true
    function_name = "addResponseHeaders"
    description   = "Response Headers for CloudFront and S3"
    handler       = "index.handler"
    runtime       = "nodejs12.x"
    source_path   = "./functions/addResponseHeaders"
    role_arn      = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/lambda_at_edge"
  }
  s3_cors_rules = [
    {
      allowed_methods = ["GET"]
      allowed_origins = ["https://api.example.com"]
      allowed_headers = ["Authorization", "Content-Length"]
      expose_headers  = []
      max_age_seconds = 3000
    }
  ]
  tags = {}
}
```
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.69 |
| <a name="requirement_external"></a> [external](#requirement\_external) | >= 1.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 1.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.69 |
| <a name="provider_aws.us-east-1"></a> [aws.us-east-1](#provider\_aws.us-east-1) | ~> 3.69 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloudfront"></a> [cloudfront](#module\_cloudfront) | terraform-aws-modules/cloudfront/aws | 2.9.2 |
| <a name="module_lambda_origin_request"></a> [lambda\_origin\_request](#module\_lambda\_origin\_request) | terraform-aws-modules/lambda/aws | 2.34.0 |
| <a name="module_lambda_origin_response"></a> [lambda\_origin\_response](#module\_lambda\_origin\_response) | terraform-aws-modules/lambda/aws | 2.34.0 |
| <a name="module_lambda_viewer_request"></a> [lambda\_viewer\_request](#module\_lambda\_viewer\_request) | terraform-aws-modules/lambda/aws | 2.34.0 |
| <a name="module_lambda_viewer_response"></a> [lambda\_viewer\_response](#module\_lambda\_viewer\_response) | terraform-aws-modules/lambda/aws | 2.34.0 |
| <a name="module_s3_bucket"></a> [s3\_bucket](#module\_s3\_bucket) | terraform-aws-modules/s3-bucket/aws | 2.14.1 |

## Resources

| Name | Type |
|------|------|
| [random_uuid.lambda_origin_request](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [random_uuid.lambda_origin_response](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [random_uuid.lambda_viewer_request](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [random_uuid.lambda_viewer_response](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [aws_acm_certificate.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate) | data source |
| [aws_iam_policy_document.s3_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_role.lambda_origin_request](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |
| [aws_iam_role.lambda_origin_response](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |
| [aws_iam_role.lambda_viewer_request](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |
| [aws_iam_role.lambda_viewer_response](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |
| [aws_s3_bucket.logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acm_domain_name"></a> [acm\_domain\_name](#input\_acm\_domain\_name) | Domain names used to find TLS certificate | `string` | n/a | yes |
| <a name="input_aliases"></a> [aliases](#input\_aliases) | Alternate domain names for cloudfront distribution | `list(string)` | n/a | yes |
| <a name="input_cloudwatch_logs_retention_in_days"></a> [cloudwatch\_logs\_retention\_in\_days](#input\_cloudwatch\_logs\_retention\_in\_days) | Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, and 3653. | `number` | `14` | no |
| <a name="input_create"></a> [create](#input\_create) | Controls whether resources should be created | `bool` | `true` | no |
| <a name="input_create_monitoring_subscription"></a> [create\_monitoring\_subscription](#input\_create\_monitoring\_subscription) | If enabled, the resource for monitoring subscription for CloudFront will created. | `bool` | `false` | no |
| <a name="input_custom_error_response"></a> [custom\_error\_response](#input\_custom\_error\_response) | One or more custom error response elements | `any` | `{}` | no |
| <a name="input_forwarded_values_query_string"></a> [forwarded\_values\_query\_string](#input\_forwarded\_values\_query\_string) | Indicates whether you want CloudFront to forward query strings to the origin that is associated with this cache behavior. | `bool` | `false` | no |
| <a name="input_include_cookies"></a> [include\_cookies](#input\_include\_cookies) | Specifies whether you want CloudFront to include cookies in access logs | `bool` | `false` | no |
| <a name="input_index_document"></a> [index\_document](#input\_index\_document) | Amazon S3 returns this index document when requests are made to the root domain or any of the subfolders. | `string` | `"index.html"` | no |
| <a name="input_lambda_origin_request"></a> [lambda\_origin\_request](#input\_lambda\_origin\_request) | Lambda configuration for origin-request | <pre>object({<br>    create        = bool<br>    function_name = string<br>    description   = string<br>    handler       = string<br>    runtime       = string<br>    source_path   = string<br>    role_name     = string<br>  })</pre> | <pre>{<br>  "create": false,<br>  "description": "",<br>  "function_name": "",<br>  "handler": "",<br>  "role_name": "",<br>  "runtime": "",<br>  "source_path": ""<br>}</pre> | no |
| <a name="input_lambda_origin_response"></a> [lambda\_origin\_response](#input\_lambda\_origin\_response) | Lambda configuration for origin-response | <pre>object({<br>    create        = bool<br>    function_name = string<br>    description   = string<br>    handler       = string<br>    runtime       = string<br>    source_path   = string<br>    role_name     = string<br>  })</pre> | <pre>{<br>  "create": false,<br>  "description": "",<br>  "function_name": "",<br>  "handler": "",<br>  "role_name": "",<br>  "runtime": "",<br>  "source_path": ""<br>}</pre> | no |
| <a name="input_lambda_viewer_request"></a> [lambda\_viewer\_request](#input\_lambda\_viewer\_request) | Lambda configuration for viewer-request | <pre>object({<br>    create        = bool<br>    function_name = string<br>    description   = string<br>    handler       = string<br>    runtime       = string<br>    source_path   = string<br>    role_name     = string<br>  })</pre> | <pre>{<br>  "create": false,<br>  "description": "",<br>  "function_name": "",<br>  "handler": "",<br>  "role_name": "",<br>  "runtime": "",<br>  "source_path": ""<br>}</pre> | no |
| <a name="input_lambda_viewer_response"></a> [lambda\_viewer\_response](#input\_lambda\_viewer\_response) | Lambda configuration for viewer-response | <pre>object({<br>    create        = bool<br>    function_name = string<br>    description   = string<br>    handler       = string<br>    runtime       = string<br>    source_path   = string<br>    role_name     = string<br>  })</pre> | <pre>{<br>  "create": false,<br>  "description": "",<br>  "function_name": "",<br>  "handler": "",<br>  "role_name": "",<br>  "runtime": "",<br>  "source_path": ""<br>}</pre> | no |
| <a name="input_logging_bucket_name"></a> [logging\_bucket\_name](#input\_logging\_bucket\_name) | S3 bucket name for access logs | `string` | n/a | yes |
| <a name="input_minimum_protocol_version"></a> [minimum\_protocol\_version](#input\_minimum\_protocol\_version) | The minimum version of the SSL protocol that you want CloudFront to use for HTTPS connections. Can TLSv1.2\_2019 or TLSv1.2\_2021 | `string` | `"TLSv1.2_2019"` | no |
| <a name="input_price_class"></a> [price\_class](#input\_price\_class) | The price class for this distribution. One of PriceClass\_All, PriceClass\_200, PriceClass\_100 | `string` | `"PriceClass_100"` | no |
| <a name="input_retain_on_delete"></a> [retain\_on\_delete](#input\_retain\_on\_delete) | Disables the distribution instead of deleting it when destroying the resource through Terraform. If this is set, the distribution needs to be deleted manually afterwards. | `bool` | `false` | no |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | Name for S3 Bucket | `string` | n/a | yes |
| <a name="input_s3_versioning"></a> [s3\_versioning](#input\_s3\_versioning) | Enable versioning. Once you version-enable a bucket, it can never return to an unversioned state. You can, however, suspend versioning on that bucket. | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudfront_distribution_id"></a> [cloudfront\_distribution\_id](#output\_cloudfront\_distribution\_id) | The identifier for the CloudFront distribution |
| <a name="output_s3_bucket_id"></a> [s3\_bucket\_id](#output\_s3\_bucket\_id) | The name of the S3 bucket |
<!-- END_TF_DOCS -->
