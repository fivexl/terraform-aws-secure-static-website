data "aws_canonical_user_id" "current" {}

data "aws_cloudfront_log_delivery_canonical_user_id" "current" {}

module "logging_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "2.14.1"

  bucket = local.logging_bucket_name
  acl    = null
  grant = [{
    type        = "CanonicalUser"
    permissions = ["FULL_CONTROL"]
    id          = data.aws_canonical_user_id.current.id
    }, {
    type        = "CanonicalUser"
    permissions = ["FULL_CONTROL"]
    id          = data.aws_cloudfront_log_delivery_canonical_user_id.current.id
    }, {
    type        = "Group"
    permissions = ["READ_ACP", "WRITE"]
    uri         = "http://acs.amazonaws.com/groups/s3/LogDelivery"
  }]

  versioning = {
    enabled = true
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  attach_elb_log_delivery_policy = true # Required for ALB logs
  attach_lb_log_delivery_policy  = true # Required for ALB/NLB logs

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
