output "aws_alb_dns_name" {
    value = module.alb.aws_lb_dns_name
}

output "aws_lb_tg_arn" {
    value = module.lb_target_group.aws_lb_target_group_arn
  
}

output "aws_ec2_jenkins_instance_public_ip" {
    value = module.ec2.python_flask_ec2_public_ip
  
}

output "aws_rds_instance_name" {
    value = module.rds.mysql_dbname
  
}
output "aws_jenkins_instance_sg_ids" {
    value = module.security_group.ec2_sg_id
  
}

output "mysql_rds_sg_ids" {
    value = module.security_group.rds_mysql_sg_id
  
}

output "python_api_sg_id" {
    value = module.security_group.ec2_sg_python_api_id
  
}
output "vpc_id" {
    value = module.networking.python_flask_vpc_id
  
}

output "python_flask_s3_bucket" {
    value = module.S3.remote_backend_s3_bucket_name
  
}
