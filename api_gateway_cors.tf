resource "aws_api_gateway_method" "options_method" {
  rest_api_id   = aws_api_gateway_rest_api.email_api.id
  resource_id   = aws_api_gateway_resource.send_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "options_integration" {
  rest_api_id = aws_api_gateway_rest_api.email_api.id
  resource_id = aws_api_gateway_resource.send_resource.id
  http_method = aws_api_gateway_method.options_method.http_method
  type        = "MOCK"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "options_response" {
  rest_api_id = aws_api_gateway_rest_api.email_api.id
  resource_id = aws_api_gateway_resource.send_resource.id
  http_method = aws_api_gateway_method.options_method.http_method

  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

resource "aws_api_gateway_integration_response" "options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.email_api.id
  resource_id = aws_api_gateway_resource.send_resource.id
  http_method = aws_api_gateway_method.options_method.http_method

  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'${var.allowed_cors_origin}'",
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST'",
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type'"
  }

  response_templates = {
    "application/json" = ""
  }
}
