resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr_block
}

# Subnets-2 (public, private)

resource "aws_subnet" "sub_pub" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.sub_pub_cidr_block
  map_public_ip_on_launch = true
}

resource "aws_subnet" "sub_pri" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.sub_pri_cidr_block
}

resource "aws_route_table" "my_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_ig.id
  }
}

resource "aws_route_table_association" "sub_associ" {
  subnet_id = aws_subnet.sub_pub.id
  route_table_id = aws_route_table.my_rt.id
}

resource "aws_internet_gateway" "my_ig" {
  vpc_id = aws_vpc.my_vpc.id
}