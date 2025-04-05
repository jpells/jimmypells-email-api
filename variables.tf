variable "region" {
  description = "The AWS region to create resources in."
  type        = string
}

variable "email_domain" {
  description = "The domain to verify with SES"
  type        = string
}

variable "from_email" {
  description = "Email address to send the form data from"
  type        = string
}

variable "to_email" {
  description = "Email address to send the form data to"
  type        = string
}

variable "lambda_function_name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "allowed_cors_origin" {
  description = "The allowed CORS origin for API Gateway"
  type        = string
}
