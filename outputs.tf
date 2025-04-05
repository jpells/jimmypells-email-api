output "api_endpoint" {
  value = aws_api_gateway_stage.default_stage.invoke_url
}

output "dkim_tokens" {
  value = aws_ses_domain_dkim.site_dkim.dkim_tokens
}
