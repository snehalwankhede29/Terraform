provider "aws" {
  region = "ap-south-1"
}

module "aws_vpc" {
  source = "./VPC/"
  vpc_cidr_block = var.vpc_cidr_block
  sub_pub_cidr_block = var.sub_pub_cidr_block
  sub_pri_cidr_block = var.sub_pri_cidr_block
}

module "aws_instance" {
  source = "./EC2/"
  ami = var.ami
  instance_type = var.instance_type
}

module "aws_alb" {
  source = "./ALB/"
  cidr_block = var.cidr_block
  aws_subnet_sub_pub1_cidr_block = var.aws_subnet_sub_pub1_cidr_block
  availability_zone_pub1 = var.availability_zone_pub1
  aws_subnet_sub_pub2_cidr_block = var.aws_subnet_sub_pub2_cidr_block
  availability_zone_pub2 = var.availability_zone_pub2
}