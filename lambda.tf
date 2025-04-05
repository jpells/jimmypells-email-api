resource "aws_iam_role" "lambda_exec" {
  name = "${var.lambda_function_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })

  path = "/service-role/"
}

resource "aws_lambda_function" "send_email" {
  function_name    = var.lambda_function_name
  runtime          = "nodejs18.x"
  handler          = "index.handler"
  role             = aws_iam_role.lambda_exec.arn
  filename         = "email_api/email_api.zip"
  source_code_hash = filebase64sha256("email_api/email_api.zip")

  environment {
    variables = {
      FROM_EMAIL          = var.from_email
      TO_EMAIL            = var.to_email
      ALLOWED_CORS_ORIGIN = var.allowed_cors_origin
    }
  }
}

resource "aws_lambda_permission" "apigw_lambda" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.send_email.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.email_api.execution_arn}/*/*"
}
