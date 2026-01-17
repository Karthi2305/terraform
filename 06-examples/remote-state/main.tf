## create a first tf file called backend.tf

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


## create a second tf file called provider.tf

# Provider configuration
terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}


## create a third tf file called vpc.tf

# Create VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = {
    Name = "demo-vpc"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  
  tags = {
    Name = "demo-igw"
  }
}

# Create Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  
  tags = {
    Name = "demo-public-subnet"
  }
}

# Create Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  
  tags = {
    Name = "demo-public-rt"
  }
}

# Associate Route Table with Subnet
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}


## create a fouth tf file called security-group.tf

 Create Security Group
resource "aws_security_group" "web_sg" {
  name        = "demo-web-sg"
  description = "Security group for web server"
  vpc_id      = aws_vpc.main.id

  # Allow SSH from anywhere (for demo - restrict in production!)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
  }

  # Allow HTTP from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP access"
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }

  tags = {
    Name = "demo-web-sg"
  }
}



## create a fifth tf file called ec2.tf


# Get latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]
  
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Create EC2 Instance
resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  
  # User data to install Apache web server
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello from Terraform Remote State Demo!</h1>" > /var/www/html/index.html
              EOF
  
  tags = {
    Name        = "demo-web-server"
    Environment = "demo"
    ManagedBy   = "terraform"
  }
}


## create a sixth tf file called outputs.tf


# Output EC2 public IP
output "ec2_public_ip" {
  description = "Public IP of EC2 instance"
  value       = aws_instance.web_server.public_ip
}

# Output EC2 instance ID
output "ec2_instance_id" {
  description = "ID of EC2 instance"
  value       = aws_instance.web_server.id
}

# Output VPC ID
output "vpc_id" {
  description = "ID of VPC"
  value       = aws_vpc.main.id
}

# Output Security Group ID
output "security_group_id" {
  description = "ID of Security Group"
  value       = aws_security_group.web_sg.id
}

# Output website URL
output "website_url" {
  description = "URL to access the web server"
  value       = "http://${aws_instance.web_server.public_ip}"
}
