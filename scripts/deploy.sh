#!/bin/bash

# Navigate to the application directory
cd /home/ec2-user/flask-app

# Stop any existing Docker containers
#docker-compose down || echo "No running containers to stop."

# Pull the latest Docker image from ECR
docker pull 942731209985.dkr.ecr.ap-south-1.amazonaws.com/poc-repo:${CODEBUILD_BUILD_ID}

# Remove any previous containers running the app (if any)
docker rm -f flask-app-container || echo "No previous container to remove."

# Run the new Docker image
docker run -d -p 8080:8080 --name flask-app-container 942731209985.dkr.ecr.ap-south-1.amazonaws.com/poc-repo:${CODEBUILD_BUILD_ID}

