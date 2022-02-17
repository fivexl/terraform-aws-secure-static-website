variable "application_name" {
  description = "Name to be used on service_name, ssm prefix, mesh router and route names, mesh service name and for tags"
  type        = string
}

variable "acm_domain_name" {
  description = "Domain names used to find TLS certificate"
  type        = string
}

variable "aliases" {
  description = "Alternate domain names for cloudfront distribution"
  type        = list(string)
}

variable "create_monitoring_subscription" {
  description = "If enabled, the resource for monitoring subscription for CloudFront will created."
  type        = bool
  default     = false
}

variable "error403_response_page_path" {
  description = "Path in S3 for html with 403 template"
  type        = string
}

variable "error404_response_page_path" {
  description = "Path in S3 for html with 404 template"
  type        = string
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
  description = "Lambda@Edge configuration for viewer-request"
  type = object({
    create        = bool
    function_name = string
    handler       = string
    runtime       = string
    source_path   = string
  })
  default = {
    create        = false
    function_name = ""
    handler       = ""
    runtime       = ""
    source_path   = ""
  }
}

variable "lambda_viewer_response" {
  description = "Lambda@Edge configuration for viewer-response"
  type = object({
    create        = bool
    function_name = string
    handler       = string
    runtime       = string
    source_path   = string
  })
  default = {
    create        = false
    function_name = ""
    handler       = ""
    runtime       = ""
    source_path   = ""
  }
}

variable "lambda_origin_request" {
  description = "Lambda@Edge configuration for origin-request"
  type = object({
    create        = bool
    function_name = string
    handler       = string
    runtime       = string
    source_path   = string
  })
  default = {
    create        = false
    function_name = ""
    handler       = ""
    runtime       = ""
    source_path   = ""
  }
}

variable "lambda_origin_response" {
  description = "Lambda@Edge configuration for origin-response"
  type = object({
    create        = bool
    function_name = string
    handler       = string
    runtime       = string
    source_path   = string
  })
  default = {
    create        = false
    function_name = ""
    handler       = ""
    runtime       = ""
    source_path   = ""
  }
}

variable "tags" {
  description = "Tags"
  type        = map(string)
  default     = {}
}
