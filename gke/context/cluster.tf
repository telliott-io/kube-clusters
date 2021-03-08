terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.57.0"
    }
  }
}

data "google_container_cluster" "cluster" {
  name     = var.cluster_name
  location = "us-central1"
}

# Retrieve an access token as the Terraform runner
data "google_client_config" "provider" {}

output "kubernetes" {
  value = {
    load_config_file = false
    host  = "https://${data.google_container_cluster.cluster.endpoint}"
    token = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(
      data.google_container_cluster.cluster.master_auth[0].cluster_ca_certificate,
    )
  }
  sensitive = true
}