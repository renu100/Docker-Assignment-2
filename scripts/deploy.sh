#!/bin/bash

# Navigate to the application directory
cd /home/ec2-user/flask-app

# Set variables for ECR repository
ECR_URL="942731209985.dkr.ecr.ap-south-1.amazonaws.com"
REPO_NAME="poc-repo"
BUILD_NUMBER=${1:-latest}  # Use the first argument as the build number, or default to 'latest'

# Check if the old container exists and remove it
if sudo docker ps -a --format '{{.Names}}' | grep -q 'flask_app-container'; then
    echo "Removing the old container..."
    sudo docker rm -f flask_app-container
fi

# Log in to Amazon ECR
echo "Logging in to Amazon ECR..."
aws ecr get-login-password --region ap-south-1 | sudo docker login --username AWS --password-stdin $ECR_URL

# Check if port 8080 is in use and stop the container using it
if sudo lsof -i :8080; then
    echo "Port 8080 is in use. Stopping the container using it..."
    container_id=$(sudo docker ps -q --filter "expose=8080")
    if [ -n "$container_id" ]; then
        sudo docker stop $container_id
    fi
fi

# Pull the specified Docker image (either 'latest' or a specific build number)
echo "Pulling the Docker image with tag: $BUILD_NUMBER..."
sudo docker pull $ECR_URL/$REPO_NAME:$BUILD_NUMBER

# Run the new Docker container with the specified image version
echo "Running the Docker container with image tag: $BUILD_NUMBER..."
sudo docker run -d --name flask_app-container -p 8080:8080 $ECR_URL/$REPO_NAME:$BUILD_NUMBER

echo "Deployment complete with image tag: $BUILD_NUMBER."
