#!/bin/bash

# Check if image ID is provided
if [ -z "$1" ]; then
  echo "Please provide the image ID to delete."
  exit 1
fi

# Get the image ID from the provided argument
image_id=$1

# Execute podman rmi command until there are no error messages
while true; do
  # Execute podman rmi command
  result=$(podman rmi $image_id 2>&1)

  # Check if the result contains "Error: Image used by"
  if [[ $result == *"Error: Image used by"* ]]; then
    # Extract the container ID from the error message
    container_id=$(echo "$result" | grep -oE '[[:alnum:]]{64}')

    # Execute podman rm command to remove the container
    podman rm $container_id
  else
    # No error message found, exit the loop
    break
  fi
done
