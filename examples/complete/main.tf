provider "aws" {}

terraform {
}

resource "random_string" "random" {
  length  = 6
  special = false
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  logging_bucket_name = "access-logs-${random_string.random.result}"
  s3_bucket_name      = "website-${random_string.random.result}"
}

module "website" {
  source                         = "../../"
  acm_domain_name                = var.acm_domain_name
  aliases                        = var.aliases
  create_monitoring_subscription = var.create_monitoring_subscription
  logging_bucket_name            = module.logging_bucket.s3_bucket_id
  s3_bucket_name                 = local.s3_bucket_name
  forwarded_values_query_string  = var.forwarded_values_query_string
  include_cookies                = var.include_cookies
  custom_error_response = {
    error403 = {
      error_code            = 403
      error_caching_min_ttl = 300
      response_code         = 200
      response_page_path    = var.error403_response_page_path
    }
    error404 = {
      error_code            = 404
      error_caching_min_ttl = 300
      response_code         = 200
      response_page_path    = var.error404_response_page_path
    }
  }
  lambda_viewer_request = {
    create        = var.lambda_viewer_request.create
    function_name = "${var.application_name}_${var.lambda_viewer_request.function_name}"
    description   = "Viewer Request for CloudFront"
    handler       = var.lambda_viewer_request.handler
    runtime       = var.lambda_viewer_request.runtime
    source_path   = var.lambda_viewer_request.source_path
    role_name     = ""
  }
  lambda_viewer_response = {
    create        = var.lambda_viewer_response.create
    function_name = "${var.application_name}_${var.lambda_viewer_response.function_name}"
    description   = "Viewer Response for CloudFront"
    handler       = var.lambda_viewer_response.handler
    runtime       = var.lambda_viewer_response.runtime
    source_path   = var.lambda_viewer_response.source_path
    role_name     = ""
  }
  lambda_origin_request = {
    create        = var.lambda_origin_request.create
    function_name = "${var.application_name}_${var.lambda_origin_request.function_name}"
    description   = "Origin Request for CloudFront"
    handler       = var.lambda_origin_request.handler
    runtime       = var.lambda_origin_request.runtime
    source_path   = var.lambda_origin_request.source_path
    role_name     = ""
  }
  lambda_origin_response = {
    create        = var.lambda_origin_response.create
    function_name = "${var.application_name}_${var.lambda_origin_response.function_name}"
    description   = "Origin Response for CloudFront and S3"
    handler       = var.lambda_origin_response.handler
    runtime       = var.lambda_origin_response.runtime
    source_path   = var.lambda_origin_response.source_path
    role_name     = ""
  }
  tags = var.tags
}

