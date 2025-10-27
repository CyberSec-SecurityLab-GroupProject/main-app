variable "alert_email" {
  type    = string
  default = ""
}

resource "aws_sns_topic" "gd_alerts" {
  name = "seclab-guardduty-alerts"
}

resource "aws_sns_topic_subscription" "email" {
  count     = length(var.alert_email) > 0 ? 1 : 0
  topic_arn = aws_sns_topic.gd_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

resource "aws_cloudwatch_event_rule" "gd_findings" {
  name = "seclab-guardduty-findings"
  event_pattern = jsonencode({
    "source" : ["aws.guardduty"],
    "detail-type" : ["GuardDuty Finding"]
  })
}

resource "aws_cloudwatch_event_target" "sns_target" {
  rule      = aws_cloudwatch_event_rule.gd_findings.name
  target_id = "sns"
  arn       = aws_sns_topic.gd_alerts.arn
}

output "topic_arn" {
  value = aws_sns_topic.gd_alerts.arn
}
