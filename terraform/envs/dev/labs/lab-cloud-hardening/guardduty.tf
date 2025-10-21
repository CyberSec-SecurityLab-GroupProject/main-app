resource "aws_guardduty_detector" "main" {
  enable = true
  finding_publishing_frequency = "FIFTEEN_MINUTES"

  tags = {
    Project     = "breachbeach"
    Environment = "dev"
  }
}

resource "aws_securityhub_account" "main" {
  depends_on = [aws_guardduty_detector.main]
}

resource "aws_securityhub_standards_subscription" "cis" {
  standards_arn = "arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.2.0"
  depends_on    = [aws_securityhub_account.main]
}
