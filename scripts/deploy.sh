#!/bin/bash
cd /home/ec2-user/flask-app

# Get the latest git commit hash as the image tag
IMAGE_TAG=$(git rev-parse --short HEAD)
ECR_REPO="942731209985.dkr.ecr.ap-south-1.amazonaws.com/poc-repo:$IMAGE_TAG"

# Check if the container exists and remove it if it does
if sudo docker ps -a --format '{{.Names}}' | grep -q 'flask_app-container'; then
    echo "Removing the old container..."
    sudo docker rm -f flask_app-container
fi

# Log in to Amazon ECR
echo "Logging in to Amazon ECR..."
aws ecr get-login-password --region ap-south-1 | sudo docker login --username AWS --password-stdin 942731209985.dkr.ecr.ap-south-1.amazonaws.com

# Check if port 8080 is in use, and stop the container using it
if sudo lsof -i :8080; then
    echo "Port 8080 is in use. Stopping the container using it..."
    container_id=$(sudo docker ps -q --filter "expose=8080")
    if [ -n "$container_id" ]; then
        sudo docker stop $container_id
    fi
fi

# Pull the latest Docker image with the dynamic tag
echo "Pulling the latest Docker image with tag $IMAGE_TAG..."
if ! sudo docker pull "$ECR_REPO"; then
    echo "Failed to pull the Docker image. Please check the repository and image name."
    exit 1
fi

# Run the new Docker container with the new tag
echo "Running the new Docker container with tag $IMAGE_TAG..."
if ! sudo docker run -d --name flask_app-container -p 8080:8080 "$ECR_REPO"; then
    echo "Failed to run the Docker container. Please check for errors."
    exit 1
fi

echo "Deployment completed successfully with image tag $IMAGE_TAG."
