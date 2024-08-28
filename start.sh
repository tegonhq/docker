#!/bin/bash

# This is the script to 
# 1. Start the docker-compose 
# 2. Trigger.dev has prepolated data
# 3. You have workspace, team created

# Load environment variables from .env file
set -a
source .env
set +a

DB_CONTAINER_NAME="tegon-db"
SERVER_CONTAINER_NAME="tegon-server"


# Define the compose file based on the presence of the --dev argument
COMPOSE_FILE="docker-compose.yaml"

# Function to log error messages and exit
log_error_and_exit() {
    echo "[ERROR] $1"
    exit 1
}

# Start docker compose
echo "Starting Docker Compose with $COMPOSE_FILE..."
docker compose --env-file .env -f $COMPOSE_FILE up -d || log_error_and_exit "Failed to start Docker Compose."

# Wait for containers to be up and running
echo "Waiting for containers to start..."
sleep 10

# Run the init-trigger.sh script
echo "Running init-trigger.sh script..."
./init-trigger.sh || log_error_and_exit "Failed to run init-trigger.sh."

echo "Successfully started."
exit 0
