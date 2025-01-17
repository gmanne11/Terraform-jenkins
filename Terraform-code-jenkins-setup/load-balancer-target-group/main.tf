variable "lb_target_group_name" {}
variable "lb_target_group_port" {}
variable "lb_targte_group_protocol" {}
variable "vpc_id" {}
variable "ec2_instance_id" {}

output "aws_lb_target_group_arn" {
    value = aws_lb_target_group.my-tg.arn
}

# Create ELB target group 
resource "aws_lb_target_group" "my-tg" {
  name        = var.lb_target_group_name
  port        = var.lb_target_group_port 
  protocol    = var.lb_targte_group_protocol
  vpc_id      = var.vpc_id 

  health_check {
    path = "/login"
    port = 8080
    healthy_threshold = 6
    unhealthy_threshold = 2
    timeout = 2
    interval = 5
    matcher = "200"  # has to be HTTP 200 or fails
  }
}

# Create ELB - TG attachement
resource "aws_lb_target_group_attachment" "dev_elb_targte_group_attachment" {
    target_group_arn = aws_lb_target_group.my-tg.arn  
    target_id = var.ec2_instance_id 
    port = 8080
  
}