# Private Subnet 1
resource "aws_subnet" "private_1" {

  vpc_id = aws_vpc.main.id

  cidr_block = "10.0.3.0/24"

  availability_zone = "us-east-1a"

  map_public_ip_on_launch = false

  tags = {
    Name = "${var.app_name}-private-subnet-1"
  }
}


# Private Subnet 2
resource "aws_subnet" "private_2" {

  vpc_id = aws_vpc.main.id

  cidr_block = "10.0.4.0/24"

  availability_zone = "us-east-1b"

  map_public_ip_on_launch = false

  tags = {
    Name = "${var.app_name}-private-subnet-2"
  }
}


# Associate Private Subnet 1 with Private Route Table
resource "aws_route_table_association" "private_1" {

  subnet_id = aws_subnet.private_1.id

  route_table_id = aws_route_table.private.id
}


# Associate Private Subnet 2 with Private Route Table
resource "aws_route_table_association" "private_2" {

  subnet_id = aws_subnet.private_2.id

  route_table_id = aws_route_table.private.id
}
