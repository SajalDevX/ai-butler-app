# Variables for simplified AWS deployment

variable "project_name" {
  description = "Name of your project (no underscores)"
  type        = string
  default     = "recall-butler"
}

variable "aws_region" {
  description = "AWS region to deploy to"
  type        = string
  default     = "us-west-2"
}

variable "instance_type" {
  description = "EC2 instance type (t2.micro is free tier eligible)"
  type        = string
  default     = "t2.micro"
}

variable "instance_ami" {
  description = "Amazon Linux 2 AMI ID for us-west-2"
  type        = string
  default     = "ami-0ca285d4c2cda3300"
}

variable "db_password" {
  description = "Password for PostgreSQL database"
  type        = string
  sensitive   = true
}

variable "ssh_public_key" {
  description = "SSH public key for EC2 access"
  type        = string
}
