variable "bucket_name" {}
variable "name" {}
variable "dynamodb_table_name" {}
variable "read_capacity" {}
variable "write_capacity" {}


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

# S3 bucket versioning enabled
resource "aws_s3_bucket_versioning" "versioning_enabled" {
  bucket = aws_s3_bucket.remote_backend_s3.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Create dynamodb for s3 bucket locking
resource "aws_dynamodb_table" "s3_bucket_lock" {
  name           = var.dynamodb_table_name
  billing_mode   = "PROVISIONED"
  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "S3BucketLock"
  }
}