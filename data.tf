data "aws_acm_certificate" "this" {
  count       = var.create ? 1 : 0
  provider    = aws.us-east-1 # CloudFront expects ACM resources in us-east-1 region only
  domain      = var.acm_domain_name
  most_recent = true
  statuses    = ["ISSUED"]
}

data "aws_s3_bucket" "logging" {
  count  = var.create ? 1 : 0
  bucket = var.logging_bucket_name
}

data "aws_iam_role" "lambda_viewer_request" {
  count = var.create && var.lambda_viewer_request.create && var.lambda_viewer_request.role_name != "" ? 1 : 0
  name  = var.lambda_viewer_request.role_name
}

data "aws_iam_role" "lambda_viewer_response" {
  count = var.create && var.lambda_viewer_response.create && var.lambda_viewer_response.role_name != "" ? 1 : 0
  name  = var.lambda_viewer_response.role_name
}

data "aws_iam_role" "lambda_origin_request" {
  count = var.create && var.lambda_origin_request.create && var.lambda_origin_request.role_name != "" ? 1 : 0
  name  = var.lambda_origin_request.role_name
}

data "aws_iam_role" "lambda_origin_response" {
  count = var.create && var.lambda_origin_response.create && var.lambda_origin_response.role_name != "" ? 1 : 0
  name  = var.lambda_origin_response.role_name
}
