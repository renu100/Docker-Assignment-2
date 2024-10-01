#!/bin/bash

# Exit the script if any command fails
set -e

# Navigate to the application directory
cd /home/ec2-user/flask-app

# Stop any existing Docker containers (use sudo if necessary)
echo "Stopping existing Docker containers..."
sudo docker-compose down || echo "No running containers to stop."

# Pull the latest Docker image from ECR
echo "Pulling the latest Docker image from ECR..."
echo "Using image tag: $CODEBUILD_BUILD_ID"  # Debugging to check the tag
sudo docker pull 942731209985.dkr.ecr.ap-south-1.amazonaws.com/poc-repo:${CODEBUILD_BUILD_ID} || { echo 'Docker pull failed'; exit 1; }

# Remove any previous container running the app
echo "Removing any previous container..."
sudo docker rm -f flask-app-container || echo "No previous container to remove."

# Run the new Docker image (ensure the app uses the right ports)
echo "Running the new Docker container..."
sudo docker run -d -p 8080:8080 --name flask-app-container 942731209985.dkr.ecr.ap-south-1.amazonaws.com/poc-repo:${CODEBUILD_BUILD_ID} || { echo 'Failed to start the new container'; exit 1; }

# Verify if the container is running
echo "Checking running containers..."
sudo docker ps
