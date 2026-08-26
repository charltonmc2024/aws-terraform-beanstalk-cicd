# Private Subnet 1
resource "aws_subnet" "private_1" {

  vpc_id = aws_vpc.main.id

  cidr_block = var.private_subnet_1_cidr

  availability_zone = "${var.aws_region}a"

  map_public_ip_on_launch = false

  tags = {
    Name = "${var.app_name}-private-subnet-1"
  }
}

resource "aws_subnet" "private_2" {

  vpc_id = aws_vpc.main.id

  cidr_block = var.private_subnet_2_cidr

  availability_zone = "${var.aws_region}b"

  map_public_ip_on_launch = false

  tags = {
    Name = "${var.app_name}-private-subnet-2"
  }
}



# Associate Private Subnet 1 with Private Route Table
resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private.id
}


