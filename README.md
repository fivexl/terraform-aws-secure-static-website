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

module "web_service" {
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