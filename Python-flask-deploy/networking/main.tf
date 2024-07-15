variable "vpc_cidr" {}
variable "vpc_name" {}
variable "cidr_public_subnet" {}
variable "cidr_private_subnet" {}
variable "az" {}

output "python_flask_vpc_id" {
    value = aws_vpc.python_flask_vpc.id 
  
}

output "python_flask_public_subnets" {
    value = aws_subnet.python_flask_public_subnets.*.id 
  
}

output "python_flask_private_subnets" {
    value = aws_subnet.python_flask_private_subnets.*.id 
  
}

output "python_flask_public_subnet_cidr_block" {
    value = aws_subnet.python_flask_public_subnets.*.cidr_block

}

output "python_flask_private_subnet_cidr_block" {
    value = aws_subnet.python_flask_private_subnets.*.cidr_block
    
}

# Setup VPC
resource "aws_vpc" "python_flask_vpc" {
    cidr_block = var.vpc_cidr 
    tags = {
      Name = var.vpc_name
    }
}

# Setup public subnet 
resource "aws_subnet" "python_flask_public_subnets" {
    vpc_id = aws_vpc.python_flask_vpc.id 
    count = length(var.cidr_public_subnet)
    cidr_block = element(var.cidr_public_subnet, count.index)
    availability_zone = element(var.az, count.index)

    tags = {
      Name = "python_flask_public_subnet-${count.index + 1}"
    }
}

# Setup private subnet 
resource "aws_subnet" "python_flask_private_subnets" {
    vpc_id = aws_vpc.python_flask_vpc.id 
    count = length(var.cidr_private_subnet)
    cidr_block = element(var.cidr_private_subnet, count.index)
    availability_zone = element(var.az, count.index)

    tags = {
      Name = "python_flask_private_subnet-${count.index + 1}"
    }
}

#Setup interent gateway 
resource "aws_internet_gateway" "python_flask_igw" {
    vpc_id = aws_vpc.python_flask_vpc.id 
    tags = {
      Name = "python-flask-igw"
    }
}

# Setup public Routetable 
resource "aws_route_table" "python_flask_public_rtb" {
    vpc_id = aws_vpc.python_flask_vpc.id 
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.python_flask_igw.id   
    }
    tags = {
      Name = "rtb-public-subnet"
    }      
}

# Route table association with public subnet 
resource "aws_route_table_association" "rtba1" {
    count = length(aws_subnet.python_flask_public_subnets)
    subnet_id = aws_subnet.python_flask_public_subnets[count.index].id 
    route_table_id = aws_route_table.python_flask_public_rtb.id 

}

# Private route table 
resource "aws_route_table" "python_flask_private_rtb" {
    vpc_id = aws_vpc.python_flask_vpc.id 
    route {
        cidr_block = "0.0.0.0/0"

    }
    tags = {
      Name = "rtb-private-subnet"
    }      
}

#Private subnet and private subnet association 
resource "aws_route_table_association" "rtba2" {
    count = length(aws_subnet.python_flask_private_subnets)
    subnet_id = aws_subnet.python_flask_private_subnets[count.index].id  
    route_table_id = aws_route_table.python_flask_private_rtb.id 

}

  