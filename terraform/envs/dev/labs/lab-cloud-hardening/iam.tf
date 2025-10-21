resource "aws_iam_role" "terraform_exec_role" {
  name = "TerraformExecutionRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "codebuild.amazonaws.com"
      }
    }]
  })
  tags = {
    Project     = "breachbeach"
    Environment = "dev"
  }
}

resource "aws_iam_policy" "terraform_exec_policy" {
  name        = "TerraformExecutionPolicy"
  description = "Allows Terraform to create and destroy lab resources"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ec2:*",
          "iam:PassRole",
          "s3:*",
          "logs:*",
          "cloudwatch:*",
          "guardduty:*",
          "securityhub:*"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.terraform_exec_role.name
  policy_arn = aws_iam_policy.terraform_exec_policy.arn
}
