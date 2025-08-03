# AWS Email API

A serverless API for sending emails using AWS Lambda, API Gateway, and Simple Email Service (SES).

## Features

- AWS Lambda function for sending emails.
- API Gateway integration.
- reCAPTCHA validation for spam protection.

## Prerequisites

- Terraform installed.
- npm installed.
- An AWS account with permissions to create Lambda functions and API Gateway resources.
- Google reCAPTCHA site key and secret key.

## Setup

1. Install Terraform.
2. Run `terraform init` to initialize the project.
3. Zip the lambda function for deployment i.e. `cd email_api && npm install && zip -r email_api.zip index.js node_modules`.
4. Apply the configuration with `terraform apply`. *The API Gateway endpoint will be displayed in the output.*

## Example Usage

To send an email, make a POST request to the API Gateway endpoint with the following JSON payload:

```bash
curl -X POST https://your-api-id.execute-api.region.amazonaws.com/prod/send \
  -H "Content-Type: application/json; charset=UTF-8" \
  -d '{
    "subject": "Test Email",
    "message": "Hello, this is a test message!",
    "recaptchaResponse": "your-recaptcha-response-token"
  }'
```

Replace the endpoint URL with the one provided by your API Gateway after deployment, and include a valid reCAPTCHA response token obtained from your frontend.

## Security

This API includes reCAPTCHA validation to protect against spam and automated abuse. Ensure you implement the reCAPTCHA client-side integration on your frontend to generate valid response tokens.
