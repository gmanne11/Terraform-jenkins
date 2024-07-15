variable "bucket_name" {}
variable "name" {}
variable "vpc_cidr" {}
variable "vpc_name" {}
variable "cidr_public_subnet" {}
variable "cidr_private_subnet" {}
variable "az" {}
variable "ami_id" {}
variable "dynamodb_table_name" {}
  


module "S3" {
    source = "./S3"
    bucket_name = var.bucket_name 
    name = var.name
    dynamodb_table_name = var.dynamodb_table_name
    read_capacity = 5
    write_capacity = 5
}

module "networking" {
    source = "./networking"
    vpc_cidr = var.vpc_cidr
    vpc_name = var.vpc_name
    cidr_public_subnet = var.cidr_public_subnet
    cidr_private_subnet = var.cidr_private_subnet
    az = var.az

}

module "security_group" {
    source = "./security-groups"
    vpc_id = module.networking.python_flask_vpc_id
    ec2_sg = "SG for EC2 to enable SSH(22) and HTTP(80)"
    public_subnet_cidr_block = tolist(module.networking.python_flask_public_subnet_cidr_block)
    ec2_sg_name_python_api = "SG for EC2 for enabling port 5000"

}

module "ec2" {
    source = "./ec2"
    instance_name = "python_flask_node"
    ami_id = var.ami_id 
    subnet_id = tolist(module.networking.python_flask_public_subnets)[0]
    enable_public_ip_python = true 
    public_key = var.public_key
    ec2_sg_python_api_id = module.security_group.ec2_sg_python_api_id
    ec2_sg_id = module.security_group.ec2_sg_id
    instance_type = "t2.micro"
    user_data_install_python = file("./template/ec2_install_python.sh")
  
}

module "lb_target_group" {
    source = "./load-balancer-target-group"
    lb_target_group_name = "python-flask-app-target-group"
    lb_target_group_port = 5000
    lb_targte_group_protocol = "HTTP"
    vpc_id = module.networking.python_flask_vpc_id
    ec2_instance_id = module.ec2.python_flask_ec2_instance_id
}

module "alb" {
    source = "./load-balancer"
    lb_name = "python-flask-app-alb"
    is_external = false
    lb_type = "application"
    ec2_sg = module.security_group.ec2_sg_id
    subnet_ids = tolist(module.networking.python_flask_public_subnets)
    lb_target_group_arn = module.lb_target_group.aws_lb_target_group_arn
    lb_target_group_attachment_port = 5000
    ec2_instance_id = module.ec2.python_flask_ec2_instance_id
    lb_listener_port = 80
    lb_listener_protocol = "HTTP"
    lb_listener_default_action = "forward"
  
}

module "rds" {
    source = "./rds"
    db_subnet_group_name = "python-flask-rds-subnet-group"
    subnet_ids = tolist(module.networking.python_flask_private_subnets)[0]
    mysql_db_identifier = "mydb"
    mysql_username = "dbuser"
    mysql_password = "dbpassword"
    rds_mysql_sg_id = module.security_group.rds_mysql_sg_id
    mysql_dbname = "devprojdb"

}