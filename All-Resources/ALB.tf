provider "aws" {
  region = "us-west-1"
}

# vpc & subnets

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "sub_pub1" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.0.0/17"
  map_public_ip_on_launch = true
  availability_zone = "us-west-1a"
}

resource "aws_subnet" "sub_pub2" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.128.0/17"
  map_public_ip_on_launch = true
  availability_zone = "us-west-1c"
}

resource "aws_internet_gateway" "my_ig" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route_table" "my_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_ig.id
  }
}

resource "aws_route_table_association" "sub_associ1" {
  subnet_id = aws_subnet.sub_pub1.id
  route_table_id = aws_route_table.my_rt.id
}

resource "aws_route_table_association" "sub_associ2" {
  subnet_id = aws_subnet.sub_pub2.id
  route_table_id = aws_route_table.my_rt.id
}



#security group 

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

# target group

resource "aws_lb_target_group" "my_tg" {
  vpc_id = aws_vpc.my_vpc.id
  port     = 80
  protocol = "HTTP"
}

# load balancer

resource "aws_lb" "my_load_balancer" {
  load_balancer_type = "application"
  security_groups = [aws_security_group.my_sg.id]
  subnets = [
    aws_subnet.sub_pub1.id,
    aws_subnet.sub_pub2.id]
}

# load balancer listener

resource "aws_lb_listener" "lb_lister" {
  certificate_arn = "arn:aws:acm:us-west-1:351931931835:certificate/d90e4630-9a19-4b30-812e-d99a9bad6312"
  load_balancer_arn = aws_lb.my_load_balancer.arn
  port = 443
  protocol = "HTTPS"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.my_tg.arn
  }
}