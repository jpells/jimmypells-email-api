# AWS Email API

A serverless API for sending emails using AWS Lambda, API Gateway, and Simple Email Service (SES).

## Features

- AWS Lambda function for sending emails.
- API Gateway integration.

## Prerequisites

- Terraform installed.
- npm installed.
- An AWS account with permissions to create Lambda functions and API Gateway resources.

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
    "message": "Hello, this is a test message!"
  }'
```

Replace the endpoint URL with the one provided by your API Gateway after deployment.

## Warning

This API is publicly exposed and could be vulnerable to misuse by bad actors. Ensure you implement proper security measures to protect your resources.
