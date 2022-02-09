locals {
  origin_id                   = format("S3-Website-%s", module.s3_bucket.s3_bucket_website_endpoint)
  origin_access_identity      = "s3_bucket"
  lambda_viewer_request       = var.lambda_viewer_request.create ? { viewer-request = { lambda_arn = module.lambda_viewer_request.lambda_function_qualified_arn } } : {}
  lambda_viewer_response      = var.lambda_viewer_response.create ? { viewer-response = { lambda_arn = module.lambda_viewer_response.lambda_function_qualified_arn } } : {}
  lambda_origin_request       = var.lambda_origin_request.create ? { origin-request = { lambda_arn = module.lambda_origin_request.lambda_function_qualified_arn } } : {}
  lambda_origin_response      = var.lambda_origin_response.create ? { origin-response = { lambda_arn = module.lambda_origin_response.lambda_function_qualified_arn } } : {}
  lambda_function_association = merge(local.lambda_viewer_request, local.lambda_viewer_response, local.lambda_origin_request, local.lambda_origin_response, {})
}

module "cloudfront" {
  source  = "terraform-aws-modules/cloudfront/aws"
  version = "2.8.0"

  create_distribution            = var.create
  aliases                        = var.aliases
  comment                        = var.s3_bucket_name
  enabled                        = true
  is_ipv6_enabled                = true
  price_class                    = var.price_class
  http_version                   = "http2"
  retain_on_delete               = var.retain_on_delete
  wait_for_deployment            = true
  create_monitoring_subscription = var.create_monitoring_subscription
  create_origin_access_identity  = var.create
  logging_config = {
    include_cookies = var.include_cookies
    bucket          = one(data.aws_s3_bucket.logging[*].bucket_domain_name)
    prefix          = "cloudfront/${var.s3_bucket_name}"
  }
  origin_access_identities = {
    "${local.origin_access_identity}" = "access-identity-${module.s3_bucket.s3_bucket_bucket_regional_domain_name}"
  }
  default_root_object = var.index_document
  origin = {
    "${local.origin_id}" = {
      domain_name = module.s3_bucket.s3_bucket_bucket_regional_domain_name
      s3_origin_config = {
        origin_access_identity = local.origin_access_identity # key in `origin_access_identities`
      }
    }
  }
  default_cache_behavior = {
    target_origin_id       = local.origin_id
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true

    use_forwarded_values = true
    query_string         = var.forwarded_values_query_string
    cookies_forward      = "none"

    min_ttl     = 0
    default_ttl = 86400  # 24h
    max_ttl     = 604800 # 7d

    viewer_protocol_policy      = "redirect-to-https"
    lambda_function_association = local.lambda_function_association
  }

  custom_error_response = var.custom_error_response

  geo_restriction = {
    restriction_type = "none"
  }

  viewer_certificate = {
    acm_certificate_arn      = one(data.aws_acm_certificate.this[*].arn)
    minimum_protocol_version = var.minimum_protocol_version
    ssl_support_method       = "sni-only"
  }

  tags = var.tags
}

