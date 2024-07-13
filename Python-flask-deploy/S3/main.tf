variable "bucket_name" {}
variable "name" {}

output "remote_backend_s3_bucket_name" {
    value = aws_s3_bucket.remote_backend_s3.id
}

# Create S3 bucket for remote backend 
resource "aws_s3_bucket" "remote_backend_s3" {
    bucket = var.bucket_name

    tags = {
      Name = var.name 
    }
}