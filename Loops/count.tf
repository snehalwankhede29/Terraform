provider "aws" {
   region = "us-east-1"
}

resource "aws_instance" "ec2" {
  ami = "ami-0ecb62995f68bb549"
  instance_type = "t3.micro"
  count = 3                                # it creates 3 instances
}

