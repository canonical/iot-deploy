#!/bin/sh

USERNAME=$1
if [ -z "$USERNAME" ]; then
  echo "The Launchpad username must be specified to create a user"
  exit 1
fi

# Get the name of the management service pod
POD_NAME=$(sudo microk8s kubectl get pods --no-headers -o custom-columns=":metadata.name" | grep management)

sudo microk8s kubectl exec -it "$POD_NAME" -- ./createsuperuser -username $1 -email admin@example.com -name "Super User"
