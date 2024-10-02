#!/bin/bash
cd /home/ec2-user/flask-app
sudo docker rm -f flask-app-container
aws ecr get-login-password --region ap-south-1 | sudo docker login --username AWS --password-stdin 942731209985.dkr.ecr.ap-south-1.amazonaws.com
if sudo lsof -i :8080; then
  echo "Port 8080 is in use. Stopping the container using it..."
  container_id=$(sudo docker ps -q --filter "expose=8080")
  sudo docker stop $container_id || true
fi
sudo docker pull 942731209985.dkr.ecr.ap-south-1.amazonaws.com/poc-repo:latest
sudo docker run -d --name flask_app-container -p 8080:8080 942731209985.dkr.ecr.ap-south-1.amazonaws.com/poc-repo:latest
