application_name = "website"
acm_domain_name  = "*.example.com"
aliases          = ["website.example.com"]

error403_response_page_path = "/403.html"
error404_response_page_path = "/404.html"

lambda_viewer_request = {
  create        = true
  function_name = "addBasicAuth"
  handler       = "index.handler"
  runtime       = "nodejs12.x"
  source_path   = "functions/addBasicAuth"
}

lambda_origin_request = {
  create        = true
  function_name = "addDefaultDirectoryIndexes"
  handler       = "index.handler"
  runtime       = "nodejs12.x"
  source_path   = "functions/addDefaultDirectoryIndexes"
}

lambda_origin_response = {
  create        = true
  function_name = "addResponseHeaders"
  handler       = "index.handler"
  runtime       = "nodejs12.x"
  source_path   = "functions/addResponseHeaders"
}

### Advanced settings
forwarded_values_query_string = true
include_cookies               = true


