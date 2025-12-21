# Simplified AWS Deployment for Learning
# This creates: VPC, EC2, RDS PostgreSQL (no SSL/ALB for simplicity)

terraform {
  required_version = ">= 1.1.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Data source for availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet"
  }
}

# Second subnet for RDS (requires 2 AZs)
resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet-2"
  }
}

# Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

# Route Table Associations
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

# Security Group for EC2
resource "aws_security_group" "ec2" {
  name        = "${var.project_name}-ec2-sg"
  description = "Security group for Serverpod EC2 instance"
  vpc_id      = aws_vpc.main.id

  # SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
  }

  # Serverpod API
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Serverpod API"
  }

  # Serverpod Insights
  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Serverpod Insights"
  }

  # Serverpod Web
  ingress {
    from_port   = 8082
    to_port     = 8082
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Serverpod Web"
  }

  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-ec2-sg"
  }
}

# Security Group for RDS
resource "aws_security_group" "rds" {
  name        = "${var.project_name}-rds-sg"
  description = "Security group for RDS PostgreSQL"
  vpc_id      = aws_vpc.main.id

  # PostgreSQL from EC2
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2.id]
    description     = "PostgreSQL from EC2"
  }

  # PostgreSQL from your IP (for direct access/debugging)
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "PostgreSQL public access (for learning only!)"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-rds-sg"
  }
}

# DB Subnet Group
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet"
  subnet_ids = [aws_subnet.public.id, aws_subnet.public_2.id]

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

# RDS PostgreSQL
resource "aws_db_instance" "main" {
  identifier             = "${var.project_name}-db"
  engine                 = "postgres"
  engine_version         = "16.6"
  instance_class         = "db.t3.micro"  # Account restricted from changing
  allocated_storage      = 20
  storage_type           = "gp2"
  db_name                = "serverpod"
  username               = "postgres"
  password               = var.db_password
  publicly_accessible    = true
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name

  tags = {
    Name = "${var.project_name}-db"
  }
}

# Key Pair for SSH
resource "aws_key_pair" "main" {
  key_name   = "${var.project_name}-key"
  public_key = var.ssh_public_key
}

# EC2 Instance
resource "aws_instance" "serverpod" {
  ami                         = var.instance_ami
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.main.key_name
  vpc_security_group_ids      = [aws_security_group.ec2.id]
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true

  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }

  user_data = <<-EOF
              #!/bin/bash
              set -e

              # Update system
              dnf update -y

              # Install Docker
              dnf install -y docker
              systemctl start docker
              systemctl enable docker
              usermod -a -G docker ec2-user

              # Install Docker Compose
              curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
              chmod +x /usr/local/bin/docker-compose

              # Install Git
              dnf install -y git

              # Create serverpod directory
              mkdir -p /home/ec2-user/serverpod
              chown ec2-user:ec2-user /home/ec2-user/serverpod

              echo "Setup complete!" > /home/ec2-user/setup-complete.txt
              EOF

  tags = {
    Name = "${var.project_name}-server"
  }
}

# Outputs
output "ec2_public_ip" {
  value       = aws_instance.serverpod.public_ip
  description = "Public IP of the EC2 instance"
}

output "ec2_public_dns" {
  value       = aws_instance.serverpod.public_dns
  description = "Public DNS of the EC2 instance"
}

output "rds_endpoint" {
  value       = aws_db_instance.main.endpoint
  description = "RDS PostgreSQL endpoint"
}

output "rds_address" {
  value       = aws_db_instance.main.address
  description = "RDS PostgreSQL address (without port)"
}

output "api_url" {
  value       = "http://${aws_instance.serverpod.public_ip}:8080"
  description = "Serverpod API URL"
}

output "insights_url" {
  value       = "http://${aws_instance.serverpod.public_ip}:8081"
  description = "Serverpod Insights URL"
}

output "ssh_command" {
  value       = "ssh -i ~/.ssh/serverpod_key ec2-user@${aws_instance.serverpod.public_ip}"
  description = "SSH command to connect to the server"
}
