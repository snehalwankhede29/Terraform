provider "aws" {
   region = "us-west-1"
}

resource "aws_instance" "my_instance" {
  ami = "ami-0e6a50b0059fd2cc3"
  instance_type = "t3.small"
  key_name = "terraform-keypair"


  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file("terraform-keypair")
    host = self.public_ip
  }

  provisioner "local-exec" {
    command = "echo 'your will be ignore'"
  }
}