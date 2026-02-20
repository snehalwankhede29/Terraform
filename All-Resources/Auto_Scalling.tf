provider "aws" {
   region = "us-west-1"
}

# Auto-scalling-group
#
resource "aws_autoscaling_group" "auto_scaling" {
  availability_zones = ["us-west-2"]
  desired_capacity = 2
  max_size = 5
  min_size = 1
}

# template --- 

resource "aws_launch_template" "template" {
  image_id = "ami-0e6a50b0059fd2cc3"
  instance_type = "t3.micro"
  
}

# placement group    optional may be

