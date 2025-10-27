output "security_engineer_role_arn" {
  description = "IAM role for Security Engineer (scaffold)"
  value       = module.iam.security_engineer_role_arn
}

output "security_services_policy_arn" {
  description = "Policy ARN attached to the Security Engineer role (scaffold)"
  value       = module.iam.security_services_policy_arn
}
