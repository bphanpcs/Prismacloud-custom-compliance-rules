#!/bin/sh
# Set the list of allowed user IDs
ALLOWED_USERS="0,1,2,3,4,5,6,7,8,9,10"

# Check if jq is installed
if ! [ -x "$(command -v jq)" ]; then
  echo "jq is not installed. Installing it now..."
  apt-get update && apt-get install -y jq
fi

# Get the list of running containers in the cluster
PODS=$(kubectl get pods --all-namespaces -o json)

# Parse the JSON output and check each container's user ID
for CONTAINER in $(echo $PODS | jq -r '.items[].spec.containers[].securityContext.runAsUser')
do
    # Check if the user ID is not in the list of allowed users
    if [[ "$ALLOWED_USERS" != *"$CONTAINER"* ]]
    then
        echo "Container running as an unusual user! (User ID: $CONTAINER)"
        exit 1
    fi
done

# If we make it here, all containers are running as allowed users
echo "All containers are running as expected user IDs."
exit 0
