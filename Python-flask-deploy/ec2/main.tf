variable "instance_name" {}
variable "ami_id" {}
variable "instance_type" {}
variable "subnet_id" {}
variable "enable_public_ip_python" {}
variable "user_data_install_python" {}
variable "ec2_sg_python_api_id" {}
variable "ec2_sg_id" {}


output "python_flask_ec2_public_ip" {
    value = aws_instance.python_flask_node.public_ip
}

output "python_flask_ec2_instance_id" {
    value = aws_instance.python_flask_node.id
}

# setup python-flask app node in ca-central-1 region
resource "aws_instance" "python_flask_node" {
    ami = var.ami_id
    instance_type = var.instance_type
    key_name = data.aws_key_pair.python_flask_public_key #I'm using my existing keypair
    tags = {
      Name = var.instance_name
    }

    subnet_id = var.subnet_id 
    vpc_security_group_ids = [ var.ec2_sg_python_api_id, var.ec2_sg_id ]
    associate_public_ip_address = var.enable_public_ip_python

    user_data = var.user_data_install_python
}

data "aws_key_pair" "python_flask_public_key" {
    key_name = "testing-ca-central-1"
}
