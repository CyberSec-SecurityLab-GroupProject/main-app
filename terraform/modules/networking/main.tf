data "aws_availability_zones" "available" {}

resource "aws_vpc" "lab_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.project}-${var.environment}-vpc-${var.lab_id}"
    Project     = var.project
    Environment = var.environment
    LabID       = var.lab_id
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.lab_vpc.id
  tags = { Name = "${var.project}-${var.environment}-igw-${var.lab_id}" }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.lab_vpc.id
  cidr_block              = var.public_subnets[0]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]
  tags = { Name = "${var.project}-public-${var.lab_id}" }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.lab_vpc.id
  cidr_block        = var.private_subnets[0]
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = { Name = "${var.project}-private-${var.lab_id}" }
}

resource "aws_subnet" "isolated" {
  vpc_id            = aws_vpc.lab_vpc.id
  cidr_block        = var.isolated_subnets[0]
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = { Name = "${var.project}-isolated-${var.lab_id}" }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.lab_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "${var.project}-public-rt-${var.lab_id}" }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_eip" "nat_eip" {
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public.id
  depends_on    = [aws_internet_gateway.igw]
  tags = { Name = "${var.project}-nat-${var.lab_id}" }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.lab_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = { Name = "${var.project}-private-rt-${var.lab_id}" }
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_rt.id
}
