#!/bin/bash

echo "loging to aws"
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin account.id.dkr.ecr.us-east-1.amazonaws.com

echo "docker build command"
docker build -t ecr-repo-name .

echo "adding tag"
docker tag my-docker-repo:latest ecr-uri:latest

echo "pushing image to ecr"
docker push ecr-uri:latest
