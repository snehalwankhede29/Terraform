provider "aws" {
  region = "us-west-1"
}

# default vpc

resource "aws_default_vpc" "default_vpc" {

}

# Security group

resource "aws_security_group" "my_sg" {
  name = "my_security_group"
  description = "allow access"
  vpc_id = aws_default_vpc.default_vpc.id

  ingress {
    to_port = 22
    from_port = 22
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    to_port = 0
    from_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#ec2 - instance 

resource "aws_instance" "my_instance" {
  ami = var.ami
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.my_sg.id]
}