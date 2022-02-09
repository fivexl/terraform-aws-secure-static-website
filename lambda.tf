resource "random_uuid" "lambda_viewer_request" {}

module "lambda_viewer_request" {
  providers = { aws = aws.us-east-1 }
  source    = "terraform-aws-modules/lambda/aws"
  version   = "2.34.0"
  create    = var.create && var.lambda_viewer_request.create

  function_name = var.lambda_viewer_request.function_name
  description   = var.lambda_viewer_request.description
  handler       = var.lambda_viewer_request.handler
  runtime       = var.lambda_viewer_request.runtime
  source_path   = var.lambda_viewer_request.source_path
  lambda_role   = var.lambda_viewer_request.create ? data.aws_iam_role.lambda_viewer_request[0].arn : ""

  lambda_at_edge = true
  create_role    = false

  hash_extra = var.lambda_viewer_request.create ? join(", ", concat([random_uuid.lambda_viewer_request.result], [for file in fileset("${path.root}/${var.lambda_viewer_request.source_path}", "**") : md5(file)])) : ""

  cloudwatch_logs_retention_in_days = var.cloudwatch_logs_retention_in_days

  tags = var.tags
}

resource "random_uuid" "lambda_viewer_response" {}

module "lambda_viewer_response" {
  providers = { aws = aws.us-east-1 }
  source    = "terraform-aws-modules/lambda/aws"
  version   = "2.34.0"
  create    = var.create && var.lambda_viewer_response.create

  function_name = var.lambda_viewer_response.function_name
  description   = var.lambda_viewer_response.description
  handler       = var.lambda_viewer_response.handler
  runtime       = var.lambda_viewer_response.runtime
  source_path   = var.lambda_viewer_response.source_path
  lambda_role   = var.lambda_viewer_response.create ? data.aws_iam_role.lambda_viewer_response[0].arn : ""

  lambda_at_edge = true
  create_role    = false

  hash_extra = var.lambda_viewer_response.create ? join(", ", concat([random_uuid.lambda_viewer_response.result], [for file in fileset("${path.root}/${var.lambda_viewer_response.source_path}", "**") : md5(file)])) : ""

  cloudwatch_logs_retention_in_days = var.cloudwatch_logs_retention_in_days

  tags = var.tags
}

resource "random_uuid" "lambda_origin_request" {}

module "lambda_origin_request" {
  providers = { aws = aws.us-east-1 }
  source    = "terraform-aws-modules/lambda/aws"
  version   = "2.34.0"
  create    = var.create && var.lambda_origin_request.create

  function_name = var.lambda_origin_request.function_name
  description   = var.lambda_origin_request.description
  handler       = var.lambda_origin_request.handler
  runtime       = var.lambda_origin_request.runtime
  source_path   = var.lambda_origin_request.source_path
  lambda_role   = var.lambda_origin_request.create ? data.aws_iam_role.lambda_origin_request[0].arn : ""

  lambda_at_edge = true
  create_role    = false

  hash_extra = var.lambda_origin_request.create ? join(", ", concat([random_uuid.lambda_origin_request.result], [for file in fileset("${path.root}/${var.lambda_origin_request.source_path}", "**") : md5(file)])) : ""

  cloudwatch_logs_retention_in_days = var.cloudwatch_logs_retention_in_days

  tags = var.tags
}

resource "random_uuid" "lambda_origin_response" {}

module "lambda_origin_response" {
  providers = { aws = aws.us-east-1 }
  source    = "terraform-aws-modules/lambda/aws"
  version   = "2.34.0"
  create    = var.create && var.lambda_origin_response.create

  function_name = var.lambda_origin_response.function_name
  description   = var.lambda_origin_response.description
  handler       = var.lambda_origin_response.handler
  runtime       = var.lambda_origin_response.runtime
  source_path   = var.lambda_origin_response.source_path
  lambda_role   = var.lambda_origin_response.create ? data.aws_iam_role.lambda_origin_response[0].arn : ""

  lambda_at_edge = true
  create_role    = false

  hash_extra = var.lambda_origin_response.create ? join(", ", concat([random_uuid.lambda_origin_response.result], [for file in fileset("${path.root}/${var.lambda_origin_response.source_path}", "**") : md5(file)])) : ""

  cloudwatch_logs_retention_in_days = var.cloudwatch_logs_retention_in_days

  tags = var.tags
}
