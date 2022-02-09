data "aws_iam_policy_document" "s3_policy" {
  count = var.create ? 1 : 0
  statement {
    sid     = "AllowCloudFrontReadObjects"
    actions = ["s3:GetObject"]
    principals {
      type        = "AWS"
      identifiers = module.cloudfront.cloudfront_origin_access_identity_iam_arns
    }
    resources = [
      "arn:aws:s3:::${var.s3_bucket_name}",
    ]
  }
}

module "s3_bucket" {
  source        = "terraform-aws-modules/s3-bucket/aws"
  version       = "2.13.0"
  create_bucket = var.create
  bucket        = var.s3_bucket_name
  acl           = "private"
  logging = {
    target_bucket = var.logging_bucket_name
    target_prefix = "s3/${var.s3_bucket_name}/"
  }
  versioning = {
    enabled = var.s3_versioning
  }
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  attach_policy = true
  policy        = data.aws_iam_policy_document.s3_policy[0].json

  attach_deny_insecure_transport_policy = true

  # S3 bucket-level Public Access Block configuration
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  # S3 Bucket Ownership Controls
  control_object_ownership = true
  object_ownership         = "BucketOwnerPreferred"

  tags = var.tags
}
