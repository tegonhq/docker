#!/bin/sh

# Define the compose file based on the presence of the --dev argument
COMPOSE_FILE="docker-compose.yaml"
if [[ "$1" == "--dev" ]]; then
    COMPOSE_FILE="docker-compose.dev.yaml"
fi


docker-compose -f "$COMPOSE_FILE" down