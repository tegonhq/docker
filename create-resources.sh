# This is used to run the script that we have written in server to easily create
# 1. User
# 2. Workspace
# 3. Team

# Function to log error messages and exit
log_error_and_exit() {
    echo "[ERROR] $1"
    exit 1
}

# To run this server container must be running
# Incase you are running server in local you can directly call `yarn script/createUserWorkspaceTeam` in server folder
echo "Running createUserWorkspaceTeam script."
docker exec -i $SERVER_CONTAINER_NAME yarn script/createUserWorkspaceTeam || log_error_and_exit "Failed to run createUserWorkspaceTeam script."