#!/bin/bash

# This script prepopulates a standard trigger.dev data into the postgres database directly.
# This is done because trigger.dev doesn't currently provide APIs to perform these changes,
# and there is no way to avoid authentication for trigger.dev.

# Load environment variables from .env file
export $(grep -v '^#' .env | xargs)
export $(envsubst < .env | grep -v '^#' | xargs)

DB_CONTAINER_NAME="tegon-db"

# Function to check if rows exist in the User table
check_rows() {
  docker exec -i $DB_CONTAINER_NAME psql -U $POSTGRES_USER -d $TRIGGER_DB -t -c "SELECT COUNT(*) FROM \"User\";" | xargs
}

# Function to execute a batch insert SQL script
execute_batch_insert() {
  docker exec -i $DB_CONTAINER_NAME psql -U $POSTGRES_USER -d $TRIGGER_DB -c "
  BEGIN;
  INSERT INTO \"User\" (
    id, admin, \"authenticationMethod\", \"displayName\", email, name, \"confirmedBasicDetails\", \"updatedAt\"
  ) VALUES (
    '$TRIGGER_COMMON_ID', true, 'MAGIC_LINK', 'Harshith', 'harshith@tegon.ai', 'Harshith', true, CURRENT_TIMESTAMP
  );

  INSERT INTO \"Organization\" (
    id, slug, \"title\", \"v3Enabled\", \"updatedAt\"
  ) VALUES (
    '$TRIGGER_COMMON_ID', 'tegon', 'Tegon', true, CURRENT_TIMESTAMP
  );

  INSERT INTO \"OrgMember\" (
    id, \"organizationId\", \"userId\", role, \"updatedAt\"
  ) VALUES (
    '$TRIGGER_COMMON_ID', '$TRIGGER_COMMON_ID', '$TRIGGER_COMMON_ID', 'ADMIN', CURRENT_TIMESTAMP
  );
  COMMIT
  "
}

# Function to check the result of the last command and exit if it failed
check_last_command() {
  if [ $? -ne 0 ]; then
    echo "Error: $1"
    exit 1
  fi
}

# Check if rows > 0 in User table
row_count=$(check_rows)

if [ "$row_count" -gt 0 ]; then
  echo "Rows exist in User table. Exiting."
  exit 0
fi

# Execute batch insert
execute_batch_insert
check_last_command "Failed to execute batch insert."

echo "Successfully inserted rows for User, Organization"
