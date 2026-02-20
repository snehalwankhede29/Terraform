provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "instance" {
  ami = "ami-0ecb62995f68bb549"
  instance_type = each.value
  for_each = var.instance_type
}

variable "instance_type" {
  default = {
    dev = "t3.small"
    prod = "t3.micro"
  }
}
