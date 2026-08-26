# Public Subnet 1
resource "aws_subnet" "public_1" {

  vpc_id = aws_vpc.main.id

  cidr_block = var.public_subnet_1_cidr

  availability_zone = "${var.aws_region}a"

  map_public_ip_on_launch = true

  tags = {
    Name = "${var.app_name}-public-subnet-1"
  }
}

resource "aws_subnet" "public_2" {

  vpc_id = aws_vpc.main.id

  cidr_block = var.public_subnet_2_cidr

  availability_zone = "${var.aws_region}b"

  map_public_ip_on_launch = true

  tags = {
    Name = "${var.app_name}-public-subnet-2"
  }
}




# Associate Public Subnet 1 with Public Route Table
resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}


