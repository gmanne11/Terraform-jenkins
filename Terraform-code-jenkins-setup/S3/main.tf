variable "jenkins_bucket_name" {}
variable "name" {}

output "jenkins_bucket_name" {
    value = aws_s3_bucket.my-dev-demo-jenkins-bucket.id
}

resource "aws_s3_bucket" "my-dev-demo-jenkins-bucket" {
    bucket = var.jenkins_bucket_name
    tags = {
      Name = var.name 
    }
}