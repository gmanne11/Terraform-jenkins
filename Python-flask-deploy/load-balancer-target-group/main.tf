variable "lb_target_group_name" {}
variable "lb_target_group_port" {}
variable "lb_targte_group_protocol" {}
variable "vpc_id" {}

output "aws_lb_target_group_arn" {
    value = aws_lb_target_group.python_flask_tg.arn
}

# Create ELB target group 
resource "aws_lb_target_group" "python_flask_tg" {
  name        = var.lb_target_group_name
  port        = var.lb_target_group_port 
  protocol    = var.lb_targte_group_protocol
  vpc_id      = var.vpc_id 

  health_check {
    path = "/health"
    port = 5000
    healthy_threshold = 3
    unhealthy_threshold = 2
    timeout = 5
    interval = 30
    matcher = "200"  # has to be HTTP 200 or fails
  }
}

/*# Create ELB - TG attachement
resource "aws_lb_target_group_attachment" "python_flask_alb_group_attachment" {
    target_group_arn = aws_lb_target_group.python_flask_tg.arn 
    target_id = var.ec2_instance_id 
    port = 5000
  
}*/