#!/bin/sh

# Copy providers into working directory
mkdir -p testdata/civo/terraform.d/plugins/linux_amd64/
cp /plugins/* testdata/civo/terraform.d/plugins/linux_amd64/

go test . -timeout 30m -v $@