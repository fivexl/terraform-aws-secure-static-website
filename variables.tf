variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "create" {
  description = "Controls whether resources should be created"
  type        = bool
  default     = true
}

variable "acm_domain_name" {
  description = "Domain names used to find TLS certificate"
  type        = string
}

variable "aliases" {
  description = "Alternate domain names for cloudfront distribution"
  type        = list(string)
}

variable "s3_bucket_name" {
  description = "Name for S3 Bucket"
  type        = string
}

variable "logging_bucket_name" {
  description = "S3 bucket name for access logs"
  type        = string
}

variable "retain_on_delete" {
  description = "Disables the distribution instead of deleting it when destroying the resource through Terraform. If this is set, the distribution needs to be deleted manually afterwards."
  type        = bool
  default     = false
}

variable "price_class" {
  description = "The price class for this distribution. One of PriceClass_All, PriceClass_200, PriceClass_100"
  type        = string
  default     = "PriceClass_100"
}

variable "include_cookies" {
  description = "Specifies whether you want CloudFront to include cookies in access logs"
  type        = bool
  default     = false
}

variable "forwarded_values_query_string" {
  description = "Indicates whether you want CloudFront to forward query strings to the origin that is associated with this cache behavior."
  type        = bool
  default     = false
}

variable "lambda_viewer_request" {
  description = "Lambda configuration for viewer-request"
  type = object({
    create        = bool
    function_name = string
    description   = string
    handler       = string
    runtime       = string
    source_path   = string
    role_name     = string
  })
  default = {
    create        = false
    function_name = ""
    description   = ""
    handler       = ""
    runtime       = ""
    source_path   = ""
    role_name     = ""
  }
}

variable "lambda_viewer_response" {
  description = "Lambda configuration for viewer-response"
  type = object({
    create        = bool
    function_name = string
    description   = string
    handler       = string
    runtime       = string
    source_path   = string
    role_name     = string
  })
  default = {
    create        = false
    function_name = ""
    description   = ""
    handler       = ""
    runtime       = ""
    source_path   = ""
    role_name     = ""
  }
}

variable "lambda_origin_request" {
  description = "Lambda configuration for origin-request"
  type = object({
    create        = bool
    function_name = string
    description   = string
    handler       = string
    runtime       = string
    source_path   = string
    role_name     = string
  })
  default = {
    create        = false
    function_name = ""
    description   = ""
    handler       = ""
    runtime       = ""
    source_path   = ""
    role_name     = ""
  }
}

variable "lambda_origin_response" {
  description = "Lambda configuration for origin-response"
  type = object({
    create        = bool
    function_name = string
    description   = string
    handler       = string
    runtime       = string
    source_path   = string
    role_name     = string
  })
  default = {
    create        = false
    function_name = ""
    description   = ""
    handler       = ""
    runtime       = ""
    source_path   = ""
    role_name     = ""
  }
}

variable "cloudwatch_logs_retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, and 3653."
  type        = number
  default     = 14
}

variable "custom_error_response" {
  description = "One or more custom error response elements"
  type        = any
  default     = {}
}

variable "minimum_protocol_version" {
  description = "The minimum version of the SSL protocol that you want CloudFront to use for HTTPS connections. Can TLSv1.2_2019 or TLSv1.2_2021"
  type        = string
  default     = "TLSv1.2_2019"
}

variable "s3_versioning" {
  description = "Enable versioning. Once you version-enable a bucket, it can never return to an unversioned state. You can, however, suspend versioning on that bucket."
  type        = bool
  default     = false
}

variable "s3_cors_rules" {
  description = "List of maps containing rules for Cross-Origin Resource Sharing"
  type        = any
  default     = []
}

variable "index_document" {
  description = "Amazon S3 returns this index document when requests are made to the root domain or any of the subfolders."
  type        = string
  default     = "index.html"
}

variable "error_document" {
  description = "An absolute path to the document to return in case of a 4XX error."
  type        = string
  default     = null
}

variable "create_monitoring_subscription" {
  description = "If enabled, the resource for monitoring subscription for CloudFront will created."
  type        = bool
  default     = false
}
