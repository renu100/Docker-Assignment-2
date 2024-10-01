#!/bin/bash

# Exit script on error
set -e

# Navigate to the application directory
cd /home/ec2-user/flask-app

# Stop any existing Docker containers
echo "Stopping existing Docker containers..."
sudo docker stop flask-app-container || echo "No running containers to stop."
sudo docker rm flask-app-container || echo "No previous container to remove."

# Set a fallback image tag if CODEBUILD_BUILD_ID is not set
IMAGE_TAG=${CODEBUILD_BUILD_ID:-latest}

echo "Using image tag: $IMAGE_TAG"

# Pull the latest Docker image from ECR
sudo docker pull 942731209985.dkr.ecr.ap-south-1.amazonaws.com/poc-repo:$IMAGE_TAG || { echo 'Docker pull failed'; exit 1; }

# Run the new Docker image
echo "Running the new Docker container..."
sudo docker run -d -p 8080:8080 --name flask-app-container 942731209985.dkr.ecr.ap-south-1.amazonaws.com/poc-repo:$IMAGE_TAG || { echo 'Failed to start the new container'; exit 1; }

# Check running containers
sudo docker ps
