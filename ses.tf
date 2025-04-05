resource "aws_ses_domain_identity" "site" {
  domain = var.email_domain
}

resource "aws_ses_domain_dkim" "site_dkim" {
  domain = aws_ses_domain_identity.site.domain
}

resource "aws_iam_policy" "ses_send_policy" {
  name = "ses-send-email"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid : "AllowSESSendEmail",
        Effect : "Allow",
        Action   = "ses:SendEmail",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_ses_attach" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.ses_send_policy.arn
}
