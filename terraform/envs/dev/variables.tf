variable "region" {
  type    = string
  default = "us-east-1"
}

variable "alert_email" {
  type    = string
  default = ""
}

variable "api_gateway_stage_arn" {
  type    = string
  default = ""
}
