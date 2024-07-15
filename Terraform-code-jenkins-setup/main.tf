module "S3" {
    source = "./S3"
    jenkins_bucket_name = var.jenkins_bucket_name
    name = var.name
}

module "networking" {
  source = "./networking"
  vpc_cidr = var.vpc_cidr
  vpc_name = var.vpc_name
  cidr_public_subnet = var.cidr_public_subnet
  cidr_private_subnet = var.cidr_private_subnet
  az = var.az
}

module "security_groups" {
    source = "./security-groups"
    vpc_id = module.networking.vpc_id
    ec2_jenkins_sg = "Allow port 8080 for jenkins"
    ec2_sg = "SG for ec2 to enable SSH,HTTP,access"
    sg_bastion_host = "Allow SSH(22) access from anywhere for bastion host"
    sg_bastion_to_jenkins = "Allow SSH(22) access from bastion to jenkins node"
}
    

module "jenkins" {
    source = "./jenkins"
    instance_name = "jenkins-node"
    ami_id = var.ami_id
    instance_type = "t2.medium"
    subnet_id = tolist(module.networking.private_subnets)[0]
    sg_jenkins = [ module.security_groups.ec2_sg_id, module.security_groups.ec2_jenkins_sg_id, module.security_groups.sg_bastion_to_jenkins_id ]
    enable_public_ip_jenkins = false
    user_data_install_jenkins = file("./jenkins-runner-script/jenkins-installer.sh")

    depends_on = [ module.security_groups ]

}

module "bastion_host" {
    source = "./bastion-host"
    ami_id = var.ami_id
    subnet_id = tolist(module.networking.public_subnets)[0]
    sg_bastion_host = [ module.security_groups.sg_bastion_host_id ]
    enable_public_ip_bastion = true 
    bastion_instance_name = "bastion-host"
    bastion_instance_type = "t2.micro"
}


module "lb_target_group" {
    source = "./load-balancer-target-group"
    lb_target_group_name = "jenkins-lb-target-group"
    lb_target_group_port = 8080
    lb_targte_group_protocol = "HTTP"
    vpc_id = module.networking.vpc_id
    ec2_instance_id = module.jenkins.ec2_instance_id

}

module "alb" {
    source = "./load-balancer"
    lb_type = "application"
    ec2_sg = module.security_groups.ec2_sg_id
    subnet_ids = tolist(module.networking.public_subnets)
    lb_target_group_arn = module.lb_target_group.aws_lb_target_group_arn
    lb_target_group_attachment_port = 8080
    ec2_instance_id = module.jenkins.ec2_instance_id
    lb_listener_port = 80
    lb_name = "my-alb"
    is_external = false
    lb_listener_protocol = "HTTP"
    lb_listener_default_action = "forward"
    
}
