terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "BreachBeach-CyberRange"
      Sprint      = "Sprint3"
      ManagedBy   = "Terraform"
      Environment = var.environment
      Owner       = "Hasina-Joy-Belton"
    }
  }
}

# Data source to import existing VPC
data "aws_vpc" "shared" {
  filter {
    name   = "tag:Name"
    values = ["BreachBeach-VPC"]
  }

  filter {
    name   = "cidr"
    values = ["10.10.0.0/16"]
  }
}

# Data sources for subnets
data "aws_subnet" "public_a" {
  filter {
    name   = "tag:Name"
    values = ["Public-Subnet-A"]
  }
  vpc_id = data.aws_vpc.shared.id
}

data "aws_subnet" "public_b" {
  filter {
    name   = "tag:Name"
    values = ["Public-Subnet-B"]
  }
  vpc_id = data.aws_vpc.shared.id
}

data "aws_subnet" "private_a" {
  filter {
    name   = "tag:Name"
    values = ["Private-Subnet-A"]
  }
  vpc_id = data.aws_vpc.shared.id
}

data "aws_subnet" "private_b" {
  filter {
    name   = "tag:Name"
    values = ["Private-Subnet-B"]
  }
  vpc_id = data.aws_vpc.shared.id
}

# Data source for route tables
data "aws_route_table" "public" {
  filter {
    name   = "tag:Name"
    values = ["Public-Route-Table"]
  }
  vpc_id = data.aws_vpc.shared.id
}

data "aws_route_table" "private_a" {
  filter {
    name   = "tag:Name"
    values = ["Private-RT-A"]
  }
  vpc_id = data.aws_vpc.shared.id
}

data "aws_route_table" "private_b" {
  filter {
    name   = "tag:Name"
    values = ["Private-RT-B"]
  }
  vpc_id = data.aws_vpc.shared.id
}

# Security Group for VPC Endpoints
resource "aws_security_group" "vpc_endpoints" {
  name        = "breach-beach-vpc-endpoints-sg"
  description = "Security group for VPC Endpoints"
  vpc_id      = data.aws_vpc.shared.id

  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.shared.cidr_block]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "VPC-Endpoints-SG"
  }
}

# Outputs
output "vpc_id" {
  description = "The ID of the shared VPC"
  value       = data.aws_vpc.shared.id
}

output "vpc_cidr" {
  description = "The CIDR block of the shared VPC"
  value       = data.aws_vpc.shared.cidr_block
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value = [
    data.aws_subnet.public_a.id,
    data.aws_subnet.public_b.id
  ]
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value = [
    data.aws_subnet.private_a.id,
    data.aws_subnet.private_b.id
  ]
}

output "vpc_endpoints_sg_id" {
  description = "Security group ID for VPC endpoints"
  value       = aws_security_group.vpc_endpoints.id
}