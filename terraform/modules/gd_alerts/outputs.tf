output "security_engineer_role_arn" {
  value = aws_iam_role.security_engineer.arn
}

output "security_services_policy_arn" {
  value = aws_iam_policy.security_services.arn
}