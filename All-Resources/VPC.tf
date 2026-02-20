provider "aws" {
  region = "us-west-1"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Subnets-2 (public, private)

resource "aws_subnet" "sub_pub" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.0.0/17"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "sub_pri" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.128.0/17"
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