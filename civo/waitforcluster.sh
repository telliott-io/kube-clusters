#!/bin/bash

echo "Checking cluster health"

# Send a request to the health endpoint for the k8s API.
# This request will stall until the cluster is completely ready.
OUT=$(curl --silent --insecure --user $USER:$PASSWORD "$HOST/healthz")

# Check for an ok response
while [ "$OUT" != "ok" ]; do
    echo "Unexpected output: $OUT"
    OUT=$(curl --silent --insecure --user $USER:$PASSWORD "$HOST/healthz")
    sleep 5
done