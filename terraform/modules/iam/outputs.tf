output "security_engineer_role_arn" {
  description = "ARN of the Security Engineer IAM role"
  value       = aws_iam_role.security_engineer.arn
}

output "security_services_policy_arn" {
  description = "ARN of the Security Services IAM policy"
  value       = aws_iam_policy.security_services.arn
}