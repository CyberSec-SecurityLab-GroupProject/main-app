# VPC Endpoint for S3
resource "aws_vpc_endpoint" "s3" {
  count             = var.enable_vpc_endpoints ? 1 : 0
  vpc_id            = data.aws_vpc.shared.id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [
    data.aws_route_table.public.id,
    data.aws_route_table.private_a.id,
    data.aws_route_table.private_b.id
  ]

  tags = {
    Name = "breach-beach-s3-endpoint"
  }
}

# VPC Endpoint for EC2
resource "aws_vpc_endpoint" "ec2" {
  count               = var.enable_vpc_endpoints ? 1 : 0
  vpc_id              = data.aws_vpc.shared.id
  service_name        = "com.amazonaws.${var.aws_region}.ec2"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids = [
    data.aws_subnet.private_a.id,
    data.aws_subnet.private_b.id
  ]

  security_group_ids = [
    aws_security_group.vpc_endpoints.id
  ]

  tags = {
    Name = "breach-beach-ec2-endpoint"
  }
}

output "vpc_endpoint_ids" {
  value = var.enable_vpc_endpoints ? {
    s3  = aws_vpc_endpoint.s3[0].id
    ec2 = aws_vpc_endpoint.ec2[0].id
  } : {}
}