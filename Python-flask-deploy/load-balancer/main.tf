variable "lb_name" {}
variable "is_external" {}
variable "lb_type" {}
variable "lb_sg" {}
variable "subnet_ids" {}
variable "lb_target_group_arn" {}
variable "lb_target_group_attachment_port" {}
variable "ec2_instance_id" {}
variable "lb_listener_port" {}
variable "lb_listener_protocol" {}
variable "lb_listener_default_action" {}

output "aws_lb_dns_name" {
  value = aws_lb.python_flask_ec2_elb.dns_name
}


#Create ELB for high availabilty and load distribution to our application 
resource "aws_lb" "python_flask_ec2_elb" {
    name = var.lb_name 
    internal = var.is_external
    load_balancer_type = var.lb_type
    security_groups = [var.lb_sg]
    subnets = var.subnet_ids

    enable_deletion_protection = false

    tags = {
      Name = "example-lb"
    }
  
}

# Create Load balancer-TG attachement
resource "aws_lb_target_group_attachment" "dev_lb_target_group_attachment" {
    target_id = var.ec2_instance_id 
    target_group_arn = var.lb_target_group_arn
    port = var.lb_target_group_attachment_port
  
}

# Create ELB Listener rules 
resource "aws_lb_listener" "dev_lb_listener_rule_1" {
    load_balancer_arn = aws_lb.python_flask_ec2_elb.arn
    port = var.lb_listener_port
    protocol = var.lb_listener_protocol

    default_action {
      type = var.lb_listener_default_action
      target_group_arn = var.lb_target_group_arn
    }
}


