#!/bin/bash
# Check if the docker directory exists
if [ -d "./docker" ]; then
    echo "Removing existing docker directory..."
    rm -rf ./docker
fi

# Clone the repository
git clone https://github.com/tegonhq/docker.git

# Fetch the .env file from Secret Manager
gcloud secrets versions access latest --secret=tegon-prod > docker/.env

mkdir -p ./docker/certs
gcloud secrets versions access latest --secret=tegon-gcs > docker/certs/tegon-gcs.json


# Navigate to the app directory
cd ./docker

# Read the VERSION from the .env file
export VERSION=$(grep -oP '(?<=VERSION=).*' .env)


docker pull tegonhq/tegon-server:$VERSION
docker pull tegonhq/tegon-webapp:$VERSION

docker compose up -d