#!/bin/bash
# Deploy Serverpod to EC2 instance
# Usage: ./deploy-server.sh <EC2_IP> <RDS_ENDPOINT>

set -e

EC2_IP=$1
RDS_ENDPOINT=$2
SSH_KEY="${SSH_KEY:-~/.ssh/serverpod_key}"
PROJECT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"

if [ -z "$EC2_IP" ] || [ -z "$RDS_ENDPOINT" ]; then
    echo "Usage: ./deploy-server.sh <EC2_IP> <RDS_ENDPOINT>"
    echo "Example: ./deploy-server.sh 54.123.45.67 recall-butler-db.abc123.us-west-2.rds.amazonaws.com:5432"
    exit 1
fi

echo "=========================================="
echo "Deploying Serverpod to EC2"
echo "=========================================="
echo "EC2 IP: $EC2_IP"
echo "RDS Endpoint: $RDS_ENDPOINT"
echo "Project Dir: $PROJECT_DIR"
echo "=========================================="

# Parse RDS endpoint
RDS_HOST=$(echo $RDS_ENDPOINT | cut -d: -f1)
RDS_PORT=$(echo $RDS_ENDPOINT | cut -d: -f2)

echo ""
echo "Step 1: Building server locally..."
cd "$PROJECT_DIR"
dart pub get
dart compile kernel bin/main.dart

echo ""
echo "Step 2: Creating deployment package..."
cd "$PROJECT_DIR/.."
tar -czvf serverpod-deploy.tar.gz \
    recall_butler_server/bin/ \
    recall_butler_server/lib/ \
    recall_butler_server/config/ \
    recall_butler_server/migrations/ \
    recall_butler_server/web/ \
    recall_butler_server/pubspec.yaml \
    recall_butler_server/pubspec.lock \
    recall_butler_server/Dockerfile \
    recall_butler_server/docker-compose.yaml

echo ""
echo "Step 3: Copying to EC2..."
scp -i "$SSH_KEY" -o StrictHostKeyChecking=no serverpod-deploy.tar.gz ec2-user@$EC2_IP:/home/ec2-user/

echo ""
echo "Step 4: Setting up on EC2..."
ssh -i "$SSH_KEY" -o StrictHostKeyChecking=no ec2-user@$EC2_IP << REMOTE_SCRIPT
set -e

cd /home/ec2-user
rm -rf serverpod
mkdir -p serverpod
tar -xzvf serverpod-deploy.tar.gz -C serverpod --strip-components=0
cd serverpod/recall_butler_server

# Create production config
cat > config/production.yaml << 'YAML_CONFIG'
apiServer:
  port: 8080
  publicHost: $EC2_IP
  publicPort: 8080
  publicScheme: http

insightsServer:
  port: 8081
  publicHost: $EC2_IP
  publicPort: 8081
  publicScheme: http

webServer:
  port: 8082
  publicHost: $EC2_IP
  publicPort: 8082
  publicScheme: http

database:
  host: $RDS_HOST
  port: $RDS_PORT
  name: serverpod
  user: postgres
YAML_CONFIG

echo "Server setup complete on EC2!"
REMOTE_SCRIPT

# Clean up local tar
rm -f "$PROJECT_DIR/../serverpod-deploy.tar.gz"

echo ""
echo "=========================================="
echo "Deployment package uploaded!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. SSH into server: ssh -i $SSH_KEY ec2-user@$EC2_IP"
echo "2. Create passwords.yaml with your database password"
echo "3. Run the server with Docker or Dart"
echo ""
