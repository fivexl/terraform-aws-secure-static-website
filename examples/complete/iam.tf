data "aws_iam_policy_document" "lambda_at_edge" {
  statement {
    sid = "AllowCWCreate"
    actions = [
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
    ]
    resources = [
      "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/us-east-1.*",
    ]
  }
  statement {
    sid = "AllowCWPutLogs"
    actions = [
      "logs:PutLogEvents",
    ]
    resources = [
      "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/us-east-1.*:log-stream:*",
    ]
  }
}

resource "aws_iam_policy" "lambda_at_edge" {
  name_prefix = "${var.lambda_at_edge_role_name}_"
  description = "Lambda @Edge"
  path        = "/"
  policy      = data.aws_iam_policy_document.lambda_at_edge.json
  tags        = var.tags
  lifecycle {
    create_before_destroy = true
  }
}

module "lambda_at_edge" {
  source            = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version           = "4.2.0"
  create_role       = true
  role_requires_mfa = false
  role_name         = var.lambda_at_edge_role_name
  role_description  = "Lambda @Edge"
  trusted_role_services = [
    "lambda.amazonaws.com",
    "edgelambda.amazonaws.com",
  ]
  custom_role_policy_arns = [
    aws_iam_policy.lambda_at_edge.arn
  ]
  number_of_custom_role_policy_arns = 1

  tags = var.tags
}