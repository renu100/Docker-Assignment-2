#!/bin/bash
cd /home/ec2-user/flask-app
docker pull 942731209985.dkr.ecr.ap-south-1.amazonaws.com/poc-repo:latest
docker run -d -p 8080:8080 942731209985.dkr.ecr.ap-south-1.amazonaws.com/poc-repo:latest
