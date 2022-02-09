module "s3_bucket" {
  source        = "terraform-aws-modules/s3-bucket/aws"
  version       = "2.7.0"
  create_bucket = var.create
  bucket        = var.s3_bucket_name
  acl           = "private"
  website = {
    index_document = var.index_document
    error_document = var.error_document
  }
  logging = {
    target_bucket = var.logging_bucket_name
    target_prefix = "s3/${var.s3_bucket_name}/"
  }
  versioning = {
    enabled = var.s3_versioning
  }
  cors_rule = concat([{
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = [for alias in var.aliases : "https://${alias}"]
    allowed_headers = ["*"]
    max_age_seconds = 3000
  }], var.s3_cors_rules)
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
  attach_public_policy = false

  tags = var.tags
}

data "aws_iam_policy_document" "s3_policy" {
  count = var.create ? 1 : 0
  statement {
    sid     = "AllowCloudFrontReadObjects"
    actions = ["s3:GetObject"]
    principals {
      type        = "AWS"
      identifiers = module.cloudfront.cloudfront_origin_access_identity_iam_arns
    }
    resources = ["${module.s3_bucket.s3_bucket_arn}/*"]
  }
  statement {
    sid     = "denyInsecureTransport"
    effect  = "Deny"
    actions = ["s3:*"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    resources = [
      module.s3_bucket.s3_bucket_arn,
      "${module.s3_bucket.s3_bucket_arn}/*",
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values = [
        "false"
      ]
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  count  = var.create ? 1 : 0
  bucket = module.s3_bucket.s3_bucket_id
  policy = data.aws_iam_policy_document.s3_policy[0].json
}

resource "aws_s3_bucket_public_access_block" "this" {
  # Chain resources (s3_bucket -> s3_bucket_policy -> s3_bucket_public_access_block)
  # to prevent "A conflicting conditional operation is currently in progress against this resource."
  count  = var.create ? 1 : 0
  bucket = aws_s3_bucket_policy.bucket_policy[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}