# Example

## Required
- TLS in ACM (us-east-1)
- DNS HostedZone
- Apex Zone redirect
- update `acm_domain_name` and `aliases` before run

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
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_logging_bucket"></a> [logging\_bucket](#module\_logging\_bucket) | terraform-aws-modules/s3-bucket/aws | 2.14.1 |
| <a name="module_website"></a> [website](#module\_website) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [random_string.random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_canonical_user_id.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/canonical_user_id) | data source |
| [aws_cloudfront_log_delivery_canonical_user_id.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudfront_log_delivery_canonical_user_id) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acm_domain_name"></a> [acm\_domain\_name](#input\_acm\_domain\_name) | Domain names used to find TLS certificate | `string` | n/a | yes |
| <a name="input_aliases"></a> [aliases](#input\_aliases) | Alternate domain names for cloudfront distribution | `list(string)` | n/a | yes |
| <a name="input_application_name"></a> [application\_name](#input\_application\_name) | Name to be used on service\_name, ssm prefix, mesh router and route names, mesh service name and for tags | `string` | n/a | yes |
| <a name="input_create_monitoring_subscription"></a> [create\_monitoring\_subscription](#input\_create\_monitoring\_subscription) | If enabled, the resource for monitoring subscription for CloudFront will created. | `bool` | `false` | no |
| <a name="input_error403_response_page_path"></a> [error403\_response\_page\_path](#input\_error403\_response\_page\_path) | Path in S3 for html with 403 template | `string` | n/a | yes |
| <a name="input_error404_response_page_path"></a> [error404\_response\_page\_path](#input\_error404\_response\_page\_path) | Path in S3 for html with 404 template | `string` | n/a | yes |
| <a name="input_forwarded_values_query_string"></a> [forwarded\_values\_query\_string](#input\_forwarded\_values\_query\_string) | Indicates whether you want CloudFront to forward query strings to the origin that is associated with this cache behavior. | `bool` | `false` | no |
| <a name="input_include_cookies"></a> [include\_cookies](#input\_include\_cookies) | Specifies whether you want CloudFront to include cookies in access logs | `bool` | `false` | no |
| <a name="input_lambda_origin_request"></a> [lambda\_origin\_request](#input\_lambda\_origin\_request) | Lambda@Edge configuration for origin-request | <pre>object({<br>    create        = bool<br>    function_name = string<br>    handler       = string<br>    runtime       = string<br>    source_path   = string<br>  })</pre> | <pre>{<br>  "create": false,<br>  "function_name": "",<br>  "handler": "",<br>  "runtime": "",<br>  "source_path": ""<br>}</pre> | no |
| <a name="input_lambda_origin_response"></a> [lambda\_origin\_response](#input\_lambda\_origin\_response) | Lambda@Edge configuration for origin-response | <pre>object({<br>    create        = bool<br>    function_name = string<br>    handler       = string<br>    runtime       = string<br>    source_path   = string<br>  })</pre> | <pre>{<br>  "create": false,<br>  "function_name": "",<br>  "handler": "",<br>  "runtime": "",<br>  "source_path": ""<br>}</pre> | no |
| <a name="input_lambda_viewer_request"></a> [lambda\_viewer\_request](#input\_lambda\_viewer\_request) | Lambda@Edge configuration for viewer-request | <pre>object({<br>    create        = bool<br>    function_name = string<br>    handler       = string<br>    runtime       = string<br>    source_path   = string<br>  })</pre> | <pre>{<br>  "create": false,<br>  "function_name": "",<br>  "handler": "",<br>  "runtime": "",<br>  "source_path": ""<br>}</pre> | no |
| <a name="input_lambda_viewer_response"></a> [lambda\_viewer\_response](#input\_lambda\_viewer\_response) | Lambda@Edge configuration for viewer-response | <pre>object({<br>    create        = bool<br>    function_name = string<br>    handler       = string<br>    runtime       = string<br>    source_path   = string<br>  })</pre> | <pre>{<br>  "create": false,<br>  "function_name": "",<br>  "handler": "",<br>  "runtime": "",<br>  "source_path": ""<br>}</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudfront_distribution_id"></a> [cloudfront\_distribution\_id](#output\_cloudfront\_distribution\_id) | The identifier for the CloudFront distribution |
| <a name="output_s3_bucket_id"></a> [s3\_bucket\_id](#output\_s3\_bucket\_id) | The name of the S3 bucket |
<!-- END_TF_DOCS -->