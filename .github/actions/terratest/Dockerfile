FROM golang:1.14.3

ENV TERRAFORM_VERSION="0.13.6"

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Install utilities
RUN apt-get update \
    && apt-get install unzip

# Get Terraform
RUN wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -O /tmp/terraform_${TERRAFORM_VERSION} \
    && unzip -d /usr/local/bin /tmp/terraform_${TERRAFORM_VERSION}

ENTRYPOINT ["/entrypoint.sh"]