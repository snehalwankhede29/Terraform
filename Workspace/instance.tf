provider "aws" {
  region = "us-west-1"
}

resource "aws_instance" "my_instance" {
  ami = var.ami
  instance_type = var.instance_type
}
