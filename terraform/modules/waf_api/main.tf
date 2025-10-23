variable "resource_arn_to_protect" {
  type    = string
  default = ""
}

resource "aws_wafv2_web_acl" "api" {
  name  = "seclab-waf"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "AWSManagedCommon"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "waf-managed-common"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "waf"
    sampled_requests_enabled   = true
  }
}

# Associate later when API stage ARN is provided
resource "aws_wafv2_web_acl_association" "maybe" {
  count        = var.resource_arn_to_protect != "" ? 1 : 0
  resource_arn = var.resource_arn_to_protect
  web_acl_arn  = aws_wafv2_web_acl.api.arn
}

output "web_acl_arn" {
  value = aws_wafv2_web_acl.api.arn
}
