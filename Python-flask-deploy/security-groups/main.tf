variable "vpc_id" {}
variable "ec2_sg" {}
variable "public_subnet_cidr_block" {}
variable "ec2_sg_name_python_api" {}
variable "ec2_sg_lb" {}

output "ec2_sg_python_api_id" {
    value = aws_security_group.ec2_sg_python_api.id
}

output "ec2_sg_id" {
    value = aws_security_group.ec2_sg.id 
}

output "rds_mysql_sg_id" {
    value = aws_security_group.rds_mysql_sg.id 
}

output "lb_sg_id" {
    value = aws_security_group.lb_sg.id
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

# create security group for AWS RDS
resource "aws_security_group" "rds_mysql_sg" {
    name = "rds-sg"
    description = "Allow access to RDS from EC2 present in public subnet"
    vpc_id = var.vpc_id 

    ingress {
        description = "Allow access to RDS instance from ec2 which resides in public subnet"
       # cidr_blocks = var.public_subnet_cidr_block
        security_groups = [ aws_security_group.ec2_sg.id ]
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
    }

    tags = {
      Name = "security group to allow access to RDS from ec2(app-node)"
    }

}

# create security group for Ec2-python-app node 
resource "aws_security_group" "ec2_sg_python_api" {
    name = var.ec2_sg_name_python_api
    description = "Enable the Port 5000 for python api"
    vpc_id = var.vpc_id 

    ingress {
        description = "Allow traffic on port 5000"
        cidr_blocks = ["0.0.0.0/0"]
        from_port   = 5000
        to_port     = 5000
        protocol    = "tcp"
    }

    tags = {
      Name = "security group to allow traffic on port 5000"
    }
}

# create security group for lb 
resource "aws_security_group" "lb_sg" {
    name = var.ec2_sg_lb
    description = "Security group for the load balancer"
    vpc_id = var.vpc_id 

    ingress {
        description = "Allow traffic on port 80"
        cidr_blocks = ["0.0.0.0/0"]
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
    }

    tags = {
      Name = "security group to allow traffic on port 80 for lb"
    }

}
