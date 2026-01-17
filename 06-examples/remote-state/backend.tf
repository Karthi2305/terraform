# Remote state configuration
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-demo-12345-v2"  # Your bucket name
    key            = "ec2-demo/terraform.tfstate"     # Path inside bucket
    region         = "ap-south-1"                     # Region of the bucket

    # Enable locking using DynamoDB
    dynamodb_table = "terraform-state-locks"

    # Encrypt state file
    encrypt        = true
  }
}

