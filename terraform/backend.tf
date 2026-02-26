#############################################
# S3 Backend for Remote State
#############################################

terraform {
  backend "s3" {
    bucket         = "gaurav-backend"      # Your existing bucket
    key            = "task11/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}