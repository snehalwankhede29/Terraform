# VPC

variable "vpc_cidr_block" {
    default = "10.0.0.0/16"
}

variable "sub_pub_cidr_block" {
  default = "10.0.0.0/17"
}

variable "sub_pri_cidr_block" {
  default = "10.0.128.0/17"
}

# EC2

variable "ami" {
  default = "ami-0e6a50b0059fd2cc3"
}

variable "instance_type" {
  default = "t3.small"
}

# ALB

variable "cidr_block" {
  default = "10.0.0.0/16"
}

variable "aws_subnet_sub_pub1_cidr_block" {
  default = "10.0.0.0/17"
} 

variable "availability_zone_pub1" {
  default = "ap-south-1a"
}

variable "aws_subnet_sub_pub2_cidr_block" {
  default = "10.0.128.0/17"
} 

variable "availability_zone_pub2" {
  default = "ap-south-1b"
}
