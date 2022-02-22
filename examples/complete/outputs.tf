output "cloudfront_distribution_id" {
  description = "The identifier for the CloudFront distribution"
  value       = module.website.cloudfront_distribution_id
}

output "s3_bucket_id" {
  description = "The name of the S3 bucket"
  value       = module.website.s3_bucket_id
}
