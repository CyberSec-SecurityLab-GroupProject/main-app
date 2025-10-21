terraform {
  required_version  = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.60"
    }
  }
}

data "aws_iam_policy_document" "assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      # TODO: replace "*" with the real principal (e.g., GitHub OIDC role ARN)
      identifiers = ["*"]
    }
  }
}

resource "aws_iam_role" "security_engineer" {
  name               = "breachbeach-dev-SecurityEngineerRole"
  assume_role_policy = data.aws_iam_policy_document.assume.json
  tags               = var.tags
}

resource "aws_iam_policy" "security_services" {
  name        = "breachbeach-dev-SecurityServicesPolicy"
  description = "Draft policy for security services (scope by ARN later)"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "guardduty:*",
        "cloudtrail:*",
        "wafv2:List*","wafv2:Get*","wafv2:UpdateWebACL","wafv2:AssociateWebACL","wafv2:CreateIPSet",
        "sns:*"
      ],
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach_security" {
  role       = aws_iam_role.security_engineer.name
  policy_arn = aws_iam_policy.security_services.arn
}