module "guardduty"  { source = "../../modules/guardduty" }
module "cloudtrail" { source = "../../modules/cloudtrail" }

module "waf_api" {
  source                  = "../../modules/waf_api"
  resource_arn_to_protect = var.api_gateway_stage_arn
}

module "gd_alerts" {
  source      = "../../modules/gd_alerts"
  alert_email = var.alert_email
}
