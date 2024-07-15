variable "vpc_cidr" {
    type = string
    description = "CIDR block for vpc"
}

variable "vpc_name" {
    type = string
    description = "vpc name"
}
variable "cidr_public_subnet" {
    type = list(string)
    description = "public subnets list CIDR values"
  
}

variable "cidr_private_subnet" {
    type = list(string)
    description = "private subnet CIDR values"
}


variable "az" {
    type = list(string)
    description = "list of azs"
}

variable "ami_id" {
    type = string 
    description = "AMI ID for EC2 instance"
}

variable "public_key" {
    type = string 
    description = "Public key for EC2 instance"
}

variable "jenkins_bucket_name" {
    type = string
    description = "jenkins s3 bucket name"
}

variable "name" {
    type = string 
    description = "jenkins bucket tag name"
}
