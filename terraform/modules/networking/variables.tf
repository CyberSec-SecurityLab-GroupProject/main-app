variable "vpc_cidr" {}
variable "public_subnets" { type = list(string) }
variable "private_subnets" { type = list(string) }
variable "isolated_subnets" { type = list(string) }
variable "project" {}
variable "environment" {}
variable "lab_id" {}
