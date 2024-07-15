terraform { # Make sure to create this bucket manually before configuring it as backend.
  backend "s3" {
    bucket = "dev-demo-jenkins-bucket"
    key = "devops-project-1/jenkins/terraform.tfstate"
    region = "us-east-1"
    
  }
}