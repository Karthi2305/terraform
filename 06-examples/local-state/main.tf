# Configure the AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"  # Change to your preferred region
}

# Get the latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical's AWS account ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Create a security group
resource "aws_security_group" "test_sg" {
  name        = "terraform-test-sg"
  description = "Security group for testing Terraform"

  # Allow SSH from anywhere (adjust for production)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name        = "terraform-test-sg"
    Environment = "testing"
  }
}

# Create an EC2 instance
resource "aws_instance" "test_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"  # Free tier eligible

  # Associate the security group
  vpc_security_group_ids = [aws_security_group.test_sg.id]

  tags = {
    Name        = "terraform-test-instance"
    Environment = "testing"
    ManagedBy   = "Terraform"
  }

  # Optional: Add a key pair for SSH access
  # key_name = "windows"  # Uncomment and add your key pair name
}

# Output the instance details
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.test_instance.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.test_instance.public_ip
}

output "instance_state" {
  description = "State of the EC2 instance"
  value       = aws_instance.test_instance.instance_state
}
