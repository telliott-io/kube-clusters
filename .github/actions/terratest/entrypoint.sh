#!/bin/sh

# Copy providers into working directory
mkdir -p terraform.d/plugins/linux_amd64/
cp /plugins/* terraform.d/plugins/linux_amd64/

go test . -v