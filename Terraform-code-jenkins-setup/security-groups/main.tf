variable "vpc_id" {}
variable "ec2_sg" {}
variable "ec2_jenkins_sg" {}
variable "sg_bastion_host" {}
variable "sg_bastion_to_jenkins" {}

output "ec2_sg_id" {
    value = aws_security_group.ec2_sg.id 
}

output "ec2_jenkins_sg_id" {
    value = aws_security_group.ec2_jenkins_sg.id
}

output "sg_bastion_to_jenkins_id" {
    value = aws_security_group.sg_bastion_to_jenkins.id
}

output "sg_bastion_host_id" {
    value = aws_security_group.sg_bastion_host.id 
}

# create security group for allowing SSH and HTTP access
resource "aws_security_group" "ec2_sg" {
    name = var.ec2_sg
    description = "Enable the port 22(SSH) and 80(HTTP)"
    vpc_id = var.vpc_id 

    ingress {
        description = "Allow remote SSH from anywhere"
        cidr_blocks = ["0.0.0.0/0"]
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"

    }
    ingress {
        description = "Allow HTTP from anywhere"
        cidr_blocks = ["0.0.0.0/0"]
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
    }
    egress {
        description = "Allow outgoing requests"
        cidr_blocks = ["0.0.0.0/0"]
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
    }

    tags = {
      Name = "Security group to allow SSH and HTTP traffic"
    }
}

# create security group for allowing access on port 8080 where jenkins is listening"
resource "aws_security_group" "ec2_jenkins_sg" {
    name = var.ec2_jenkins_sg
    description = "Enable the port 8080 for jenkins"
    vpc_id = var.vpc_id 

    ingress {
        description = "Allow 8080 port to access jenkins"
        cidr_blocks = ["0.0.0.0/0"]
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
    }

    tags = {
      Name = "security group to allow access jenkins on port 8080"
    }

}

# create security group for allowing SSH and HTTP access to bastion host
resource "aws_security_group" "sg_bastion_host" {
    name = var.sg_bastion_host
    description = "Enable the port 22(SSH) and 80(HTTP)"
    vpc_id = var.vpc_id 

    ingress {
        description = "Allow remote SSH from anywhere"
        cidr_blocks = ["0.0.0.0/0"]
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"

    }
    ingress {
        description = "Allow HTTP from anywhere"
        cidr_blocks = ["0.0.0.0/0"]
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
    }
    egress {
        description = "Allow outgoing requests"
        cidr_blocks = ["0.0.0.0/0"]
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
    }

    tags = {
      Name = "Security group to allow SSH and HTTP traffic"
    }
}

# create security group for allowing SSH from SG of jump server
resource "aws_security_group" "sg_bastion_to_jenkins" {
    name = var.sg_bastion_to_jenkins
    description = "Enable the port 22(SSH)from bastion host SG to jenkins"
    vpc_id = var.vpc_id 

    ingress {
        description = "Allow remote SSH from bastion host"
        security_groups = [aws_security_group.sg_bastion_host.id]
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"

    }
    tags = {
      Name = "Security group to allow SSH traffic from bastion host to jenkins node"
    }
}
