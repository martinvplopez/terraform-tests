# Requiring a provider will add the necessary information when iniating terraform
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
} 

# Creating S3 Bucket and adding some ACL config and SSE.
resource "aws_s3_bucket" "bucket" {
  bucket = "test-training-budget-bucket"
  force_destroy = true
}

# Only accessible from this account
resource "aws_s3_bucket_acl" "example_bucket_acl" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "private"
}
  
# Every object inside the S3 bucket wille be encrypted when being stored
resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encrypt_config" {
  bucket = aws_s3_bucket.bucket.id
  rule {
    apply_server_side_encryption_by_default{
      sse_algorithm = "AES256"
    }
  }
}

terraform {
  backend "s3"{
    bucket = "test-training-budget-bucket"
    key = "folder/states/test-state"
    region = "us-east-1"
  }
}
