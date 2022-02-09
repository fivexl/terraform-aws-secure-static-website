output "cloudfront_distribution_id" {
  description = "The identifier for the CloudFront distribution"
  value       = module.cloudfront.cloudfront_distribution_id
}

output "s3_bucket_id" {
  description = "The name of the S3 bucket"
  value       = module.s3_bucket.s3_bucket_id
}

