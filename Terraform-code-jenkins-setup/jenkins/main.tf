variable "instance_name" {}
variable "ami_id" {}
variable "instance_type" {}
variable "subnet_id" {}
variable "sg_jenkins" {}
variable "enable_public_ip_jenkins" {}
variable "user_data_install_jenkins" {}

output "ec2_public_ip" {
    value = aws_instance.jenkins_node.public_ip
}

output "ec2_instance_id" {
    value = aws_instance.jenkins_node.id
}

# setup jenkins node in private subnet
resource "aws_instance" "jenkins_node" {
    ami = var.ami_id
    instance_type = var.instance_type
    key_name = "testing" #I'm using my existing keypair
    tags = {
      Name = var.instance_name
    }

    subnet_id = var.subnet_id 
    vpc_security_group_ids = var.sg_jenkins
    associate_public_ip_address = var.enable_public_ip_jenkins

    user_data = var.user_data_install_jenkins
}