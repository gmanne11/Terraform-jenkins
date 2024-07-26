terraform { # Make sure this bucket is created as part of Pyth-n-flask-deploy terraform setup before configuring it as backend.
  backend "s3" {
    bucket = "python-flask-remote-state-bucket"
    key = "python-flask-api/terraform.tfstate"
    dynamodb_table = "s3-dev-bucket-locking"
    region = "ca-central-1"
    
  }
}