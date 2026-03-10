#!/bin/bash
set -e

# Log everything for debugging
exec > >(tee /var/log/user-data.log) 2>&1
echo "Starting user data script at $(date)"

# Update and install Docker
yum update -y
yum install -y docker
systemctl start docker
systemctl enable docker
usermod -a -G docker ec2-user

echo "Docker installed: $(docker --version)"

# Authenticate to ECR using the EC2 IAM role
aws ecr get-login-password --region ${aws_region} | \
  docker login --username AWS --password-stdin ${ecr_repo}

echo "Authenticated to ECR"

# Pull the latest app image
docker pull ${ecr_repo}:latest

echo "Image pulled: ${ecr_repo}:latest"

# Run the Flask app
docker run -d \
  --name flask-app \
  --restart unless-stopped \
  -p 80:5000 \
  -e AWS_REGION=${aws_region} \
  -e SECRET_NAME=${secret_name} \
  -e DB_HOST=${db_host} \
  ${ecr_repo}:latest

echo "Container started at $(date)"
echo "Running containers: $(docker ps)"