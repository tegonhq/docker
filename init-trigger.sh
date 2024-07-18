#!/bin/bash

# This file is used to prepopulate a standard trigger.dev data into the postgres directly. 
# This is done in this fashion as trigger.dev doesn't have the APIs to do these changes and 
# also there is no way to avoid authentication for trigger.dev

# Hopefully later in the timeline if they make those features this file won't be needed



# Load environment variables from .env file
export $(grep -v '^#' .env | xargs)
export $(envsubst < .env | grep -v '^#' | xargs)

DB_CONTAINER_NAME="tegon-db"
ID="clyofc7dn0000o33e4sup590l"
ID1="clyofc7dn0000o33e5sup590l"


# Function to check if rows > 0
check_rows() {
  docker exec -i $DB_CONTAINER_NAME psql -U $POSTGRES_USER -d $TRIGGER_DB -t -c "SELECT COUNT(*) FROM \"User\";" | xargs
}

# Function to insert a row and return the ID
insert_user_row() {
  docker exec -i $DB_CONTAINER_NAME psql -U $POSTGRES_USER -d $TRIGGER_DB -t -c "INSERT INTO \"User\" (
    id, admin, \"authenticationMethod\", \"displayName\", email, name, \"confirmedBasicDetails\", \"updatedAt\"
  ) VALUES (
    '$ID', true, 'MAGIC_LINK', 'Harshith', 'harshith@tegon.ai', 'Harshith', true, CURRENT_TIMESTAMP
  ) RETURNING id;" | xargs
}

# Function to insert a org_member row and return the ID
insert_organization_row() {
  docker exec -i $DB_CONTAINER_NAME psql -U $POSTGRES_USER -d $TRIGGER_DB -t -c "INSERT INTO \"Organization\" (
    id, slug, \"title\", \"v3Enabled\", \"updatedAt\"
  ) VALUES (
    '$ID', 'tegon', 'Tegon', true, CURRENT_TIMESTAMP
  ) RETURNING id;" | xargs
}

# Function to insert a org_member row and return the ID
insert_org_member_row() {
  docker exec -i $DB_CONTAINER_NAME psql -U $POSTGRES_USER -d $TRIGGER_DB -t -c "INSERT INTO \"OrgMember\" (
    id, \"organizationId\", \"userId\", role, \"updatedAt\"
  ) VALUES (
    '$ID', '$ID', '$ID', 'ADMIN', CURRENT_TIMESTAMP
  ) RETURNING id;" | xargs
}

# Function to insert a project row and return the ID
insert_project_row() {
  docker exec -i $DB_CONTAINER_NAME psql -U $POSTGRES_USER -d $TRIGGER_DB -t -c "INSERT INTO \"Project\" (
    id, name, \"organizationId\", slug, \"externalRef\", version, \"updatedAt\"
  ) VALUES (
    '$ID', 'Tegon', '$ID', 'tegon', 'proj_tegon_prod', 'V3', CURRENT_TIMESTAMP
  ) RETURNING id;" | xargs
}

# Function to insert a environments row and return the ID
insert_prod_environments_row() {
  docker exec -i $DB_CONTAINER_NAME psql -U $POSTGRES_USER -d $TRIGGER_DB -t -c "INSERT INTO \"RuntimeEnvironment\" (
    id, slug, \"apiKey\", \"organizationId\", \"orgMemberId\", \"projectId\", type, \"pkApiKey\", shortcode, \"updatedAt\"
  ) VALUES (
    '$ID', 'prod', '$TRIGGER_SECRET', '$ID', '$ID', '$ID', 'PRODUCTION', '$TRIGGER_SECRET', 'prod', CURRENT_TIMESTAMP
  ) RETURNING id;" | xargs
}

insert_dev_environments_row() {
  docker exec -i $DB_CONTAINER_NAME psql -U $POSTGRES_USER -d $TRIGGER_DB -t -c "INSERT INTO \"RuntimeEnvironment\" (
    id, slug, \"apiKey\", \"organizationId\", \"orgMemberId\", \"projectId\", type, \"pkApiKey\", shortcode, \"updatedAt\"
  ) VALUES (
    '$ID1', 'dev', '$TRIGGER_DEV_SECRET', '$ID', '$ID', '$ID', 'DEVELOPMENT', '$TRIGGER_DEV_SECRET', 'dev', CURRENT_TIMESTAMP
  ) RETURNING id;" | xargs
}


# Check if rows > 0 in User table
row_count=$(check_rows)

if [ "$row_count" -gt 0 ]; then
  echo "Rows exist in $DB_TABLE table"
  exit 0
fi

#Insert a user row if the count is 0 and return the ID
new_user_id=$(insert_user_row)

if [ -z "$new_user_id" ]; then
  echo "Failed to insert into User table"
  exit 1
fi

new_org_id=$(insert_organization_row)

if [ -z "$new_org_id" ]; then
  echo "Failed to insert into Organization table"
  exit 1
fi

new_org_mem_id=$(insert_org_member_row)

if [ -z "$new_org_mem_id" ]; then
  echo "Failed to insert into Org member table"
  exit 1
fi

new_project_id=$(insert_project_row)

if [ -z "$new_project_id" ]; then
  echo "Failed to insert into Project table"
  exit 1
fi

new_dev_env_id=$(insert_dev_environments_row)

if [ -z "$new_dev_env_id" ]; then
  echo "Failed to insert into RuntimeEnvironments dev table"
  exit 1
fi

new_env_id=$(insert_prod_environments_row)

if [ -z "$new_env_id" ]; then
  echo "Failed to insert into RuntimeEnvironments table"
  exit 1
fi

echo "Inserted rows for User, Organization, Projects and runtimes"