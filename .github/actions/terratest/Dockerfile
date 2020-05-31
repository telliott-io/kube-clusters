FROM golang:1.14.3

ENV TERRAFORM_VERSION="0.12.26"

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Install utilities
RUN apt-get update \
    && apt-get install unzip

# Get Terraform
RUN wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -O /tmp/terraform_${TERRAFORM_VERSION} \
    && unzip -d /usr/local/bin /tmp/terraform_${TERRAFORM_VERSION}

# Get Civo TF Provider
RUN wget -q https://github.com/civo/terraform-provider-civo/releases/download/v0.9.4/terraform-provider-civo_0.9.4_linux_amd64.tar.gz -O - | tar -xz terraform-provider-civo \
    && mkdir -p /plugins \
    && mv terraform-provider-civo /plugins/terraform-provider-civo

CMD ["/entrypoint.sh"]