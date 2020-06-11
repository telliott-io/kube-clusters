#!/bin/bash

echo "Checking cluster health"

# Send a request to the health endpoint for the k8s API.
# This request will stall until the cluster is completely ready.
OUT=$(curl --silent --insecure --user $USER:$PASSWORD "$HOST/healthz")

# Check for an ok response
if [$OUT!="ok\n"]
then
    echo "Unexpected output: $OUT"
    exit 2
fi