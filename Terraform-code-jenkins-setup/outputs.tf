output "bastion_host_instance_id" {
    value = module.bastion_host.bastion_host_instance_id
}

output "lb_dns_name" {
    value = module.alb.aws_lb_dns_name
}

output "jenkins_s3_bucket_name" {
    value = module.S3.jenkins_bucket_name
}