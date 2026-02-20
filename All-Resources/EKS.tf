# Provider

provider "aws" {
  region = "us-east-1"
}


# VPC

resource "aws_default_vpc" "default" {}


data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [aws_default_vpc.default.id]
  }

  filter {
    name   = "availability-zone"
    values = [
      "us-east-1a",
      "us-east-1b",
      "us-east-1c"
    ]
  }
}


# IAM-role for EKS-Cluster

resource "aws_iam_role" "eks_cluster" {
  name = "eks-cluster-role"

 assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "eks.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}


# EKS-Cluster

resource "aws_eks_cluster" "my_cluster" {
  name = "new-eks-cluster-new"
  role_arn = aws_iam_role.eks_cluster.arn
  version  = "1.31"

vpc_config {
    subnet_ids = data.aws_subnets.default.ids
    endpoint_public_access  = true
  }
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]
}


# IAM-Role for Node-group

resource "aws_iam_role" "eks_node_group" {
    name = "eks_node_group"


  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "CNI_Policy" {
  role = aws_iam_role.eks_node_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "EKSWorkerNodePolicy" {
  role = aws_iam_role.eks_node_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "ecr_readonly" {
  role = aws_iam_role.eks_node_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}


# Node-Group

resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.my_cluster.name
  node_group_name = "eks-node-group"
  node_role_arn   = aws_iam_role.eks_node_group.arn
  subnet_ids = data.aws_subnets.default.ids

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

   instance_types = ["t3.micro"]

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.

   depends_on = [
    aws_eks_cluster.my_cluster,
    aws_iam_role_policy_attachment.EKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.CNI_Policy,
    aws_iam_role_policy_attachment.ecr_readonly
  ]
}


