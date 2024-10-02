#!/bin/bash
cd /home/ec2-user/flask-app
sudo docker rm -f flask-app-container
sudo docker pull 942731209985.dkr.ecr.ap-south-1.amazonaws.com/poc-repo:latest
sudo docker run -d --name flask_app-container -p 8080:8080 942731209985.dkr.ecr.ap-south-1.amazonaws.com/poc-repo:latest
