resource "aws_api_gateway_rest_api" "email_api" {
  name = var.lambda_function_name
}

resource "aws_api_gateway_resource" "send_resource" {
  rest_api_id = aws_api_gateway_rest_api.email_api.id
  parent_id   = aws_api_gateway_rest_api.email_api.root_resource_id
  path_part   = "send"
}

resource "aws_api_gateway_method" "post_method" {
  rest_api_id   = aws_api_gateway_rest_api.email_api.id
  resource_id   = aws_api_gateway_resource.send_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.email_api.id
  resource_id             = aws_api_gateway_resource.send_resource.id
  http_method             = aws_api_gateway_method.post_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.send_email.invoke_arn
  content_handling        = "CONVERT_TO_TEXT"
}

resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.email_api.id
  depends_on  = [aws_api_gateway_integration.lambda_integration]
}

resource "aws_api_gateway_stage" "default_stage" {
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.email_api.id
  stage_name    = "prod"

  # Prevent Terraform from deleting the deployment while the stage is pointing to it
  lifecycle {
    create_before_destroy = true
  }
}
