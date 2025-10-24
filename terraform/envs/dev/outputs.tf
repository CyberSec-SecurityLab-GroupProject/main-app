output "waf_acl_arn" { value = try(module.waf_api.web_acl_arn, null) }
output "trail_bucket" { value = try(module.cloudtrail.bucket_name, null) }
output "gd_sns_topic_arn" { value = try(module.gd_alerts.topic_arn, null) }
