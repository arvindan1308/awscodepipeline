#!/bin/bash

echo "loging to aws"
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 588933971286.dkr.ecr.us-east-1.amazonaws.com

echo "docker build command"
docker build -t my-docker-repo .

echo "adding tag"
docker tag my-docker-repo:latest 588933971286.dkr.ecr.us-east-1.amazonaws.com/my-docker-repo:latest

echo "pushing image to ecr"
docker push 588933971286.dkr.ecr.us-east-1.amazonaws.com/my-docker-repo:latest
