variable "vpc_cidr" {}
variable "vpc_name" {}
variable "cidr_public_subnet" {}
variable "cidr_private_subnet" {}
variable "az" {}

output "vpc_id" {
    value = aws_vpc.my_vpc.id 
  
}

output "public_subnets" {
    value = aws_subnet.public_subnets.*.id 
  
}

output "private_subnets" {
    value = aws_subnet.private_subnets.*.id 
  
}



# Setup VPC
resource "aws_vpc" "my_vpc" {
    cidr_block = var.vpc_cidr 
    tags = {
      Name = var.vpc_name
    }
}

# Setup public subnet 
resource "aws_subnet" "public_subnets" {
    vpc_id = aws_vpc.my_vpc.id 
    count = length(var.cidr_public_subnet)
    cidr_block = element(var.cidr_public_subnet, count.index)
    availability_zone = element(var.az, count.index)

    tags = {
      Name = "public_subnet-${count.index + 1}"
    }
}

# Setup private subnet 
resource "aws_subnet" "private_subnets" {
    vpc_id = aws_vpc.my_vpc.id
    count = length(var.cidr_private_subnet)
    cidr_block = element(var.cidr_private_subnet, count.index)
    availability_zone = element(var.az, count.index)

    tags = {
      Name = "private_subnet-${count.index + 1}"
    }
}

#Setup interent gateway 
resource "aws_internet_gateway" "my_igw" {
    vpc_id = aws_vpc.my_vpc.id 
    tags = {
      Name = "my-igw"
    }
}

# Setup public Routetable 
resource "aws_route_table" "public_rtb" {
    vpc_id = aws_vpc.my_vpc.id 
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my_igw.id  
    }
    tags = {
      Name = "rtb-publicsubnet"
    }      
}

# Route table association with public subnet 
resource "aws_route_table_association" "rtba1" {
    count = length(aws_subnet.public_subnets)
    subnet_id = aws_subnet.public_subnets[count.index].id 
    route_table_id = aws_route_table.public_rtb.id  

}

# Private route table 
resource "aws_route_table" "private_rtb" {
    vpc_id = aws_vpc.my_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.jenkins_nat_gateway.id 
    }
    tags = {
      Name = "rtb-privatesubnet"
    }      
}

#Private subnet and private subnet association 
resource "aws_route_table_association" "rtba2" {
    count = length(aws_subnet.private_subnets)
    subnet_id = aws_subnet.private_subnets[count.index].id  
    route_table_id = aws_route_table.private_rtb.id 

}


# Create EIP for NAT GATEWAY association
resource "aws_eip" "nat_eip" {
  domain   = "vpc"
  
}

# Create NAT GATEWAY in public subnet for jenkins node to access internet
resource "aws_nat_gateway" "jenkins_nat_gateway" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id     = aws_subnet.public_subnets[0].id

    tags = {
        Name = "NAT-Jenkins"
    }

}

  