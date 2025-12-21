# AWS Deployment Guide for Serverpod

This guide walks you through deploying a Serverpod application to AWS from scratch. Follow these steps in order.

## Table of Contents

1. [Prerequisites](#1-prerequisites)
2. [AWS Account Setup](#2-aws-account-setup)
3. [Install Tools](#3-install-tools)
4. [Configure AWS CLI](#4-configure-aws-cli)
5. [Generate SSH Key](#5-generate-ssh-key)
6. [Configure Terraform](#6-configure-terraform)
7. [Deploy Infrastructure](#7-deploy-infrastructure)
8. [Deploy Application](#8-deploy-application)
9. [Verify Deployment](#9-verify-deployment)
10. [Troubleshooting](#10-troubleshooting)
11. [Clean Up](#11-clean-up)
12. [Production Checklist](#12-production-checklist)

---

## 1. Prerequisites

Before starting, ensure you have:
- A computer with Linux, macOS, or Windows (WSL)
- Internet connection
- Credit/debit card (for AWS account - free tier available)
- Basic terminal/command line knowledge

---

## 2. AWS Account Setup

### 2.1 Create AWS Account

1. Go to https://aws.amazon.com
2. Click **"Create an AWS Account"**
3. Enter your email and choose an account name
4. Verify email and set a password
5. Add payment method (won't be charged for free tier)
6. Complete phone verification
7. Select **Basic Support - Free**

### 2.2 Understand Free Tier

AWS Free Tier (12 months) includes:
| Service | Free Allowance |
|---------|---------------|
| EC2 | 750 hours/month t2.micro |
| RDS | 750 hours/month db.t3.micro |
| S3 | 5GB storage |
| Data Transfer | 15GB out/month |

**Cost Warning Signs:**
- Running multiple EC2 instances
- Using larger instance types
- High data transfer
- Forgetting to terminate resources

---

## 3. Install Tools

### 3.1 AWS CLI

```bash
# Linux/macOS
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Verify installation
aws --version
```

### 3.2 Terraform

```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install -y gnupg software-properties-common

# Add HashiCorp GPG key
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

# Add HashiCorp repository
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

# Install Terraform
sudo apt update
sudo apt install terraform

# Verify installation
terraform --version
```

### 3.3 Dart SDK (for building Serverpod)

```bash
# Using apt
sudo apt-get install apt-transport-https
wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/dart.gpg
echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' | sudo tee /etc/apt/sources.list.d/dart_stable.list
sudo apt-get update
sudo apt-get install dart

# Verify
dart --version
```

---

## 4. Configure AWS CLI

### 4.1 Create IAM User

1. Log into AWS Console: https://console.aws.amazon.com
2. Search for **"IAM"** and open it
3. Click **Users** → **Create user**
4. Username: `terraform-admin`
5. Click **Next**
6. Select **Attach policies directly**
7. Search and check **AdministratorAccess**
8. Click **Next** → **Create user**

### 4.2 Create Access Keys

1. Click on the user you just created
2. Go to **Security credentials** tab
3. Scroll to **Access keys** → **Create access key**
4. Select **Command Line Interface (CLI)**
5. Check the confirmation box
6. Click **Next** → **Create access key**
7. **IMPORTANT:** Download or copy both keys immediately!

### 4.3 Configure CLI

```bash
aws configure
```

Enter when prompted:
```
AWS Access Key ID: YOUR_ACCESS_KEY_ID
AWS Secret Access Key: YOUR_SECRET_ACCESS_KEY
Default region name: us-west-2
Default output format: json
```

### 4.4 Verify Configuration

```bash
aws sts get-caller-identity
```

You should see your account ID and user ARN.

---

## 5. Generate SSH Key

SSH keys allow you to securely connect to your EC2 instance.

```bash
# Generate a new key pair
ssh-keygen -t rsa -b 4096 -f ~/.ssh/serverpod_key -N ""

# This creates:
# ~/.ssh/serverpod_key     (private key - keep secret!)
# ~/.ssh/serverpod_key.pub (public key - goes to AWS)

# View your public key (you'll need this later)
cat ~/.ssh/serverpod_key.pub
```

**Security Note:** Never share your private key. If compromised, delete it and create a new one.

---

## 6. Configure Terraform

### 6.1 Navigate to Terraform Directory

```bash
cd recall_butler_server/deploy/aws/terraform-simple
```

### 6.2 Create Configuration File

```bash
# Copy the example file
cp terraform.tfvars.example terraform.tfvars
```

### 6.3 Edit terraform.tfvars

Open `terraform.tfvars` and fill in your values:

```hcl
project_name = "recall-butler"
aws_region   = "us-west-2"

# Create a strong password (16+ chars, mixed case, numbers, symbols)
db_password = "MySecureP@ssw0rd123!"

# Paste your public key from Step 5
ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCx..."

instance_type = "t2.micro"
instance_ami = "ami-0ca285d4c2cda3300"
```

### 6.4 Understanding the Configuration

| Variable | Description | Notes |
|----------|-------------|-------|
| `project_name` | Name prefix for all resources | No underscores allowed |
| `aws_region` | AWS region | us-west-2 (Oregon) has good free tier |
| `db_password` | PostgreSQL password | Use strong password |
| `ssh_public_key` | Your SSH public key | From ~/.ssh/serverpod_key.pub |
| `instance_type` | EC2 size | t2.micro is free tier |
| `instance_ami` | Amazon Linux 2 image | Differs by region |

---

## 7. Deploy Infrastructure

### 7.1 Initialize Terraform

```bash
cd recall_butler_server/deploy/aws/terraform-simple
terraform init
```

This downloads required providers (AWS).

### 7.2 Preview Changes

```bash
terraform plan
```

Review what will be created:
- 1 VPC
- 2 Subnets
- 1 Internet Gateway
- 1 Route Table
- 2 Security Groups
- 1 RDS PostgreSQL instance
- 1 EC2 instance
- 1 SSH Key Pair

### 7.3 Apply Changes

```bash
terraform apply
```

Type `yes` when prompted. This takes 5-10 minutes.

### 7.4 Save Outputs

After completion, save the output values:

```bash
terraform output
```

You'll see:
```
api_url = "http://54.xxx.xxx.xxx:8080"
ec2_public_ip = "54.xxx.xxx.xxx"
rds_endpoint = "recall-butler-db.xxxx.us-west-2.rds.amazonaws.com:5432"
ssh_command = "ssh -i ~/.ssh/serverpod_key ec2-user@54.xxx.xxx.xxx"
```

---

## 8. Deploy Application

### 8.1 Connect to EC2

```bash
# Use the ssh_command from terraform output
ssh -i ~/.ssh/serverpod_key ec2-user@<EC2_PUBLIC_IP>
```

First connection will ask about fingerprint - type `yes`.

### 8.2 Verify EC2 Setup

```bash
# On EC2 instance
cat /home/ec2-user/setup-complete.txt  # Should say "Setup complete!"
docker --version
```

### 8.3 Install Dart on EC2

```bash
# On EC2 instance
sudo yum install -y wget unzip
wget https://storage.googleapis.com/dart-archive/channels/stable/release/3.5.0/sdk/dartsdk-linux-x64-release.zip
unzip dartsdk-linux-x64-release.zip
sudo mv dart-sdk /opt/dart-sdk
echo 'export PATH="$PATH:/opt/dart-sdk/bin"' >> ~/.bashrc
source ~/.bashrc
dart --version
```

### 8.4 Clone and Build Your Project

```bash
# On EC2 instance
cd /home/ec2-user
git clone <YOUR_REPO_URL> serverpod
cd serverpod/recall_butler_server
dart pub get
```

### 8.5 Configure Database Connection

Create `config/passwords.yaml`:

```bash
# On EC2 instance
cat > config/passwords.yaml << 'EOF'
production:
  database: YOUR_DB_PASSWORD

  # Add your API keys here
  serviceSecret: YOUR_SERVICE_SECRET
EOF
```

### 8.6 Create Production Config

Edit `config/production.yaml` to point to your RDS:

```yaml
apiServer:
  port: 8080
  publicHost: <EC2_PUBLIC_IP>
  publicPort: 8080
  publicScheme: http

insightsServer:
  port: 8081
  publicHost: <EC2_PUBLIC_IP>
  publicPort: 8081
  publicScheme: http

webServer:
  port: 8082
  publicHost: <EC2_PUBLIC_IP>
  publicPort: 8082
  publicScheme: http

database:
  host: <RDS_ADDRESS_WITHOUT_PORT>
  port: 5432
  name: serverpod
  user: postgres
```

### 8.7 Run Database Migrations

```bash
# On EC2 instance
cd /home/ec2-user/serverpod/recall_butler_server
dart bin/main.dart --mode production --apply-migrations
```

### 8.8 Run the Server

```bash
# Run in foreground (for testing)
dart bin/main.dart --mode production

# OR run in background with nohup
nohup dart bin/main.dart --mode production > /var/log/serverpod.log 2>&1 &
```

---

## 9. Verify Deployment

### 9.1 Test API Endpoint

From your local machine:

```bash
curl http://<EC2_PUBLIC_IP>:8080/health
```

### 9.2 Test from Flutter App

Update your Flutter app's server URL:

```dart
// In your Flutter app
var client = Client('http://<EC2_PUBLIC_IP>:8080/');
```

### 9.3 Access Insights

Open in browser: `http://<EC2_PUBLIC_IP>:8081`

---

## 10. Troubleshooting

### Can't SSH to EC2

```bash
# Check security group allows SSH (port 22)
# Verify your key permissions
chmod 400 ~/.ssh/serverpod_key

# Try with verbose output
ssh -v -i ~/.ssh/serverpod_key ec2-user@<IP>
```

### Database Connection Failed

```bash
# Test from EC2
psql -h <RDS_ENDPOINT> -U postgres -d serverpod

# Check security group allows 5432 from EC2
```

### Server Won't Start

```bash
# Check logs
tail -f /var/log/serverpod.log

# Common issues:
# - Wrong database password in passwords.yaml
# - Database host incorrect in production.yaml
# - Port already in use
```

### Terraform Errors

```bash
# Provider issues
terraform init -upgrade

# State issues
terraform refresh

# Destroy and recreate
terraform destroy
terraform apply
```

---

## 11. Clean Up

**Important:** To avoid charges, destroy resources when done learning.

### 11.1 Terminate via Terraform

```bash
cd recall_butler_server/deploy/aws/terraform-simple
terraform destroy
```

Type `yes` when prompted.

### 11.2 Verify Cleanup

Check AWS Console:
- EC2 → Instances (should be empty)
- RDS → Databases (should be empty)
- VPC → Your VPCs (only default should remain)

---

## 12. Production Checklist

Before going to production, address these:

### Security
- [ ] Use HTTPS (requires domain + SSL certificate)
- [ ] Restrict RDS access (remove 0.0.0.0/0 rule)
- [ ] Use private subnets for database
- [ ] Enable AWS WAF for API protection
- [ ] Rotate database passwords regularly
- [ ] Enable AWS CloudTrail for auditing

### Reliability
- [ ] Set up Auto Scaling Group
- [ ] Add Application Load Balancer
- [ ] Configure health checks
- [ ] Enable RDS Multi-AZ for failover
- [ ] Set up CloudWatch alarms

### Performance
- [ ] Use larger instance types as needed
- [ ] Enable RDS read replicas
- [ ] Add Redis for caching
- [ ] Use CloudFront CDN for static assets

### Operations
- [ ] Set up CI/CD pipeline
- [ ] Configure automated backups
- [ ] Set up log aggregation
- [ ] Create runbooks for common issues

---

## Quick Reference Commands

```bash
# SSH to server
ssh -i ~/.ssh/serverpod_key ec2-user@<IP>

# View Terraform state
terraform show

# Get outputs
terraform output

# View logs on EC2
tail -f /var/log/serverpod.log

# Restart server on EC2
pkill -f "dart bin/main.dart"
nohup dart bin/main.dart --mode production > /var/log/serverpod.log 2>&1 &

# Check if server is running
curl http://<IP>:8080/health
```

---

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                        Internet                              │
└─────────────────────────┬───────────────────────────────────┘
                          │
┌─────────────────────────▼───────────────────────────────────┐
│                      AWS Cloud                               │
│  ┌───────────────────────────────────────────────────────┐  │
│  │                    VPC (10.0.0.0/16)                   │  │
│  │  ┌─────────────────────────────────────────────────┐  │  │
│  │  │              Public Subnet (10.0.1.0/24)         │  │  │
│  │  │  ┌─────────────────────────────────────────┐    │  │  │
│  │  │  │           EC2 (t2.micro)                │    │  │  │
│  │  │  │  ┌───────────────────────────────────┐  │    │  │  │
│  │  │  │  │         Serverpod Server          │  │    │  │  │
│  │  │  │  │  • API:      :8080               │  │    │  │  │
│  │  │  │  │  • Insights: :8081               │  │    │  │  │
│  │  │  │  │  • Web:      :8082               │  │    │  │  │
│  │  │  │  └───────────────────────────────────┘  │    │  │  │
│  │  │  └─────────────────────────────────────────┘    │  │  │
│  │  └─────────────────────────────────────────────────┘  │  │
│  │                          │                             │  │
│  │  ┌───────────────────────▼─────────────────────────┐  │  │
│  │  │              Public Subnet 2 (10.0.2.0/24)       │  │  │
│  │  │  ┌─────────────────────────────────────────┐    │  │  │
│  │  │  │     RDS PostgreSQL (db.t3.micro)        │    │  │  │
│  │  │  │     • Database: serverpod               │    │  │  │
│  │  │  │     • Port: 5432                        │    │  │  │
│  │  │  └─────────────────────────────────────────┘    │  │  │
│  │  └─────────────────────────────────────────────────┘  │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

---

## Common Issues & Solutions

| Issue | Cause | Solution |
|-------|-------|----------|
| "Permission denied (publickey)" | Wrong SSH key | Use `-i ~/.ssh/serverpod_key` |
| "Connection refused" on port 8080 | Server not running | SSH and start server |
| Database connection timeout | Security group | Check RDS security group rules |
| "No space left on device" | Small EBS volume | Increase root volume size |
| Terraform state locked | Previous run crashed | `terraform force-unlock <ID>` |

---

## Next Steps

After learning with this simplified setup:

1. **Add a Domain**: Buy a cheap domain and set up Route 53
2. **Add SSL**: Create ACM certificate for HTTPS
3. **Add Load Balancer**: Use Application Load Balancer
4. **Set up CI/CD**: Use the existing GitHub Actions workflow
5. **Go Production**: Use the full Terraform config in `../terraform/`

Happy deploying!

---

## Appendix: Exact Commands Used in Our Deployment

This section documents the exact commands we ran during the successful deployment on 2025-12-21.

### A.1 Tool Installation (Without sudo)

```bash
# Install AWS CLI to user directory
cd /tmp
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
mkdir -p ~/.local/bin ~/.aws-cli
./aws/install -i ~/.aws-cli -b ~/.local/bin
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Verify
~/.local/bin/aws --version
# Output: aws-cli/2.32.21 Python/3.13.11 Linux/6.14.0-37-generic

# Install Terraform
cd /tmp
wget -q https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip
unzip -o terraform_1.9.8_linux_amd64.zip
mv terraform ~/.local/bin/

# Verify
~/.local/bin/terraform --version
# Output: Terraform v1.9.8
```

### A.2 SSH Key Generation

```bash
# Generate SSH key pair (no passphrase for automation)
ssh-keygen -t rsa -b 4096 -f ~/.ssh/serverpod_key -N "" -C "serverpod-aws-key"

# View public key (copy this for terraform.tfvars)
cat ~/.ssh/serverpod_key.pub
```

### A.3 AWS CLI Configuration

```bash
# Configure AWS credentials (interactive)
~/.local/bin/aws configure
# Enter: Access Key ID, Secret Access Key, us-west-2, json

# Verify configuration
~/.local/bin/aws sts get-caller-identity
# Output: {"UserId": "...", "Account": "...", "Arn": "arn:aws:iam::..."}
```

### A.4 Create terraform.tfvars

```bash
cd recall_butler_server/deploy/aws/terraform-simple

# Create the config file with your values
cat > terraform.tfvars << 'EOF'
project_name = "recall-butler"
aws_region   = "us-west-2"

# Database password (no @, /, ", or space allowed by RDS)
db_password = "SecurePass123456"

# Your SSH public key
ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2E... your-key-here"

# EC2 instance configuration (t3.micro is free tier for new accounts)
instance_type = "t3.micro"
instance_ami  = "ami-0d8ff527aeca17d19"
EOF
```

### A.5 Deploy Infrastructure

```bash
cd recall_butler_server/deploy/aws/terraform-simple

# Initialize Terraform
~/.local/bin/terraform init

# Preview what will be created
~/.local/bin/terraform plan

# Apply (creates all resources)
~/.local/bin/terraform apply -auto-approve

# Save the outputs
~/.local/bin/terraform output
# Output:
# api_url = "http://35.86.93.209:8080"
# ec2_public_ip = "35.86.93.209"
# rds_endpoint = "recall-butler-db.cfwoomoiipi1.us-west-2.rds.amazonaws.com:5432"
# ssh_command = "ssh -i ~/.ssh/serverpod_key ec2-user@35.86.93.209"
```

### A.6 Build Server Locally

```bash
cd recall_butler_server

# Get dependencies
dart pub get

# Compile to native executable
dart compile exe bin/main.dart -o bin/server
# Output: Generated: .../bin/server
```

### A.7 Create Production Config Files

```bash
# Create production-ec2.yaml
cat > config/production-ec2.yaml << 'EOF'
apiServer:
  port: 8080
  publicHost: 35.86.93.209
  publicPort: 8080
  publicScheme: http

insightsServer:
  port: 8081
  publicHost: 35.86.93.209
  publicPort: 8081
  publicScheme: http

webServer:
  port: 8082
  publicHost: 35.86.93.209
  publicPort: 8082
  publicScheme: http

database:
  host: recall-butler-db.cfwoomoiipi1.us-west-2.rds.amazonaws.com
  port: 5432
  name: serverpod
  user: postgres
  requireSsl: true

redis:
  enabled: false
  host: localhost
  port: 6379

maxRequestSize: 10485760

sessionLogs:
  consoleEnabled: true
  consoleLogFormat: text
EOF

# Create passwords-ec2.yaml
cat > config/passwords-ec2.yaml << 'EOF'
shared:
  geminiApiKey: 'YOUR_GEMINI_API_KEY'
  groqApiKey: 'YOUR_GROQ_API_KEY'

production:
  database: 'SecurePass123456'
  serviceSecret: 'YOUR_SERVICE_SECRET'
EOF
```

### A.8 Package and Upload to EC2

```bash
cd recall_butler_server

# Create deployment package
tar -czvf /tmp/serverpod-deploy.tar.gz \
  bin/server \
  config/production-ec2.yaml \
  config/passwords-ec2.yaml \
  migrations/ \
  web/ \
  lib/src/generated/protocol.yaml

# Upload to EC2
scp -i ~/.ssh/serverpod_key /tmp/serverpod-deploy.tar.gz \
  ec2-user@35.86.93.209:/home/ec2-user/
```

### A.9 Setup on EC2

```bash
# SSH to EC2
ssh -i ~/.ssh/serverpod_key ec2-user@35.86.93.209

# On EC2: Extract and setup
cd /home/ec2-user
rm -rf serverpod
mkdir -p serverpod
cd serverpod
tar -xzvf ../serverpod-deploy.tar.gz

# Rename config files
mv config/production-ec2.yaml config/production.yaml
mv config/passwords-ec2.yaml config/passwords.yaml

# Make server executable
chmod +x bin/server

# Exit EC2
exit
```

### A.10 Start Server

```bash
# SSH and start server
ssh -i ~/.ssh/serverpod_key ec2-user@35.86.93.209 << 'EOF'
cd /home/ec2-user/serverpod
nohup ./bin/server --mode production --apply-migrations > /home/ec2-user/serverpod.log 2>&1 &
sleep 10
ps aux | grep "bin/server" | grep -v grep
tail -20 /home/ec2-user/serverpod.log
EOF
```

### A.11 Verify Deployment

```bash
# Test API endpoint
curl http://35.86.93.209:8080/
# Output: OK 2025-12-21 05:34:02.480741Z

# Test web server
curl http://35.86.93.209:8082/ | head -5
# Output: <!DOCTYPE html>...
```

### A.12 Useful Management Commands

```bash
# View live logs
ssh -i ~/.ssh/serverpod_key ec2-user@35.86.93.209 \
  "tail -f /home/ec2-user/serverpod.log"

# Restart server
ssh -i ~/.ssh/serverpod_key ec2-user@35.86.93.209 << 'EOF'
pkill -f "bin/server"
cd /home/ec2-user/serverpod
nohup ./bin/server --mode production > /home/ec2-user/serverpod.log 2>&1 &
EOF

# Check server status
ssh -i ~/.ssh/serverpod_key ec2-user@35.86.93.209 \
  "ps aux | grep server | grep -v grep"

# Check disk space
ssh -i ~/.ssh/serverpod_key ec2-user@35.86.93.209 "df -h"
```

### A.13 Destroy Resources (When Done)

```bash
cd recall_butler_server/deploy/aws/terraform-simple
~/.local/bin/terraform destroy -auto-approve
```

---

## Key Learnings from This Deployment

### Issues Encountered and Solutions

| Issue | Cause | Solution |
|-------|-------|----------|
| PostgreSQL 16.3 not available | Version deprecated | Use 16.6 instead |
| t2.micro not free tier | New accounts use t3 | Use t3.micro |
| Password with @ rejected | RDS password restrictions | Use only alphanumeric |
| Redis config error | Missing host even when disabled | Add `host: localhost` |
| RDS connection failed | SSL required by default | Set `requireSsl: true` |
| EC2 /tmp disk full | tmpfs RAM disk filled | Use main disk or Docker |

### Important Notes

1. **RDS Password Rules**: Cannot contain `@`, `/`, `"`, or spaces
2. **SSL Required**: RDS PostgreSQL requires SSL by default
3. **Free Tier Instance**: Use `t3.micro` (not t2.micro) for new AWS accounts
4. **PostgreSQL Version**: Check available versions with:
   ```bash
   aws rds describe-db-engine-versions --engine postgres \
     --query 'DBEngineVersions[*].EngineVersion'
   ```
5. **Amazon Linux 2023**: Uses `dnf` instead of `yum`
