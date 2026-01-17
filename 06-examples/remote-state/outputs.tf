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
