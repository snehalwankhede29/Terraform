provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "my_instance" {
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

output "public_ip" {
  value = {for id, instance in aws_instance.my_instance: id=> instance.public_ip}
}