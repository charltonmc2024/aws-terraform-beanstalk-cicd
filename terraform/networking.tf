# VPC
resource "aws_vpc" "main" {

  cidr_block = var.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.app_name}-${var.environment}-vpc"
  }
}


# Internet Gateway
resource "aws_internet_gateway" "main" {

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.app_name}-igw"
  }
}


# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {

  domain = "vpc"

  tags = {
    Name = "${var.app_name}-nat-eip"
  }
}


# NAT Gateway
resource "aws_nat_gateway" "main" {

  allocation_id = aws_eip.nat.id

  subnet_id = aws_subnet.public_1.id

  depends_on = [
    aws_internet_gateway.main
  ]

  tags = {
    Name = "${var.app_name}-nat"
  }
}


# Public Route Table
resource "aws_route_table" "public" {

  vpc_id = aws_vpc.main.id

  route {

    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.main.id
  }


  tags = {
    Name = "${var.app_name}-public-route-table"
  }
}


# Private Route Table
resource "aws_route_table" "private" {

  vpc_id = aws_vpc.main.id

  route {

    cidr_block = "0.0.0.0/0"

    nat_gateway_id = aws_nat_gateway.main.id
  }


  tags = {
    Name = "${var.app_name}-private-route-table"
  }
}
