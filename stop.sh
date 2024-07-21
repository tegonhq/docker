#!/bin/sh

# Define the compose file based on the presence of the --dev argument
COMPOSE_FILE="docker-compose.yaml"

docker-compose -f "$COMPOSE_FILE" down
