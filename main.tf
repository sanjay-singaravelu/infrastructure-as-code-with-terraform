# Terraform Block
terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws" # Use the AWS provider from HashiCorp
            version = "~> 4.16" # Use AWS provider version 4.16 or newer
        }
    }

    required_version = ">= 1.2.0" # Require Terraform version 1.20 or newer
}

# Provider Configuration
provider "aws" {
    region = var.aws_region # Set the AWS region using a variable
}

# Define Security Groups
resource "aws_security_group" "allow_ssh" {
    name = "allow_ssh" # Name of the security group
    description = "Allow SSH connection to EC2 Instance" # Description of the security group

    # Define inbound rules (ingress)
    ingress {
        from_port   = 22 # Allow traffic from port 22 (SSH)
        to_port     = 22 # Allow traffic to port 22 (SSH)
        protocol    = "tcp" # Use TCP protocol
        cidr_blocks = [var.ssh_access_cidr] # Allow traffic from specified IP range
    }

    # Define outbound rules (egress)
    egress {
        from_port = 0 # Allow traffic from all ports
        to_port = 0 # Allow traffic to all ports
        protocol = "-1" # Allow all protocols
        cidr_blocks = ["0.0.0.0/0"] # Allow traffic to all IP addresses
    }
}

# EC2 instance definition
resource "aws_instance" "app_server" {
    ami = var.ami_id # Use the AMI ID from a variable
    instance_type = var.instance_type # Use the instance type from a variable

    key_name = var.key_name # Use the key name from a variable
    security_groups = [aws_security_group.allow_ssh.name] # Assign the security group defined above

    tags = {
        Name = "ExampleServerInstance" # Tag the instance with a name
    }
}

# Output the public IP of the EC2 instance
output "instance_public_ip" {
    value = aws_instance.app_server.public_ip # Get the public IP of the instance
}

# Output the public DNS of the EC2 instance
output "instance_public_dns" {
    value = aws_instance.app_server.public_dns # Get the public DNS of the instance
}
