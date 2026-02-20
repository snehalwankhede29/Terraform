provider "aws" {
  region = "us-west-1"
}

# vpc

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

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

# security group

resource "aws_security_group" "my_sg" {
  name = "my_security_group"
  description = "allow all access"
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    to_port = 22
    from_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    to_port = 80
    from_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    to_port = 0
    from_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

