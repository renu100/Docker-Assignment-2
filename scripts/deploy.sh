#!/bin/bash
cd /home/ec2-user/flask-app
if sudo docker ps -a --format '{{.Names}}' | grep -q 'flask_app-container'; then
    echo "Removing the old container..."
    sudo docker rm -f flask_app-container
fi
echo "Logging in to Amazon ECR..."
aws ecr get-login-password --region ap-south-1 | sudo docker login --username AWS --password-stdin 942731209985.dkr.ecr.ap-south-1.amazonaws.com
if sudo lsof -i :8080; then
    echo "Port 8080 is in use. Stopping the container using it..."
    container_id=$(sudo docker ps -q --filter "expose=8080")
    if [ -n "$container_id" ]; then
        sudo docker stop $container_id
    fi
fi
echo "Pulling the latest Docker image..."
sudo docker pull 942731209985.dkr.ecr.ap-south-1.amazonaws.com/poc-repo:latest
echo "Running the new Docker container..."
sudo docker run -d --name flask_app-container -p 8080:8080 942731209985.dkr.ecr.ap-south-1.amazonaws.com/poc-repo:latest
