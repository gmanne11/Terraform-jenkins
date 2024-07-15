variable "bastion_instance_type" {}
variable "bastion_instance_name" {}
variable "sg_bastion_host" {}
variable "ami_id" {}
variable "subnet_id" {}
variable "enable_public_ip_bastion" {}

output "bastion_host_instance_public_ip" {
    value = aws_instance.bastion_host.public_ip
}

output "bastion_host_instance_id" {
    value = aws_instance.bastion_host.id
}

# Setup Bastion host in public sunet to access jenkins node in private subnet
resource "aws_instance" "bastion_host" {
    ami = var.ami_id
    instance_type = var.bastion_instance_type
    key_name = "testing" #I'm using my existing keypair
    tags = {
      Name = var.bastion_instance_name
    }

    subnet_id = var.subnet_id 
    vpc_security_group_ids = var.sg_bastion_host
    associate_public_ip_address = var.enable_public_ip_bastion

    provisioner "file" {
    source      = "/Users/vivekmanne/Downloads/testing1-public-key.pub"
    destination = "/tmp/testing1-public-key.pub"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("/Users/vivekmanne/Downloads/testing.pem")
      host        = self.public_ip
    }
  }

    provisioner "remote-exec" {
    inline = [
      "mkdir -p ~/.ssh",
      "cat /tmp/testing1-public-key.pub >> ~/.ssh/authorized_keys",
      #"cp /Users/vivekmanne/Downloads/testing.pem ~/.ssh/testing.pem",
      "chmod 600 ~/.ssh/authorized_keys",
      #"chmod 600 ~/.ssh/testing.pem"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("/Users/vivekmanne/Downloads/testing.pem")
      host        = self.public_ip
    }
  }
}