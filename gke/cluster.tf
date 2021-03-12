terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.57.0"
    }
  }
}

resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = "us-central1"

  # Need at least 2 nodes to ensure the loadbalancer can come up
  initial_node_count = 3

  node_locations = [
    "us-central1-c",
  ]

  master_auth {
    username = ""
    password = ""
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/compute",
    ]
  }
}

# Retrieve an access token as the Terraform runner
data "google_client_config" "provider" {}

output "kubernetes" {
  value = {
    load_config_file = false
    host  = "https://${google_container_cluster.primary.endpoint}"
    token = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(
      google_container_cluster.primary.master_auth[0].cluster_ca_certificate,
    )
  }
  sensitive = true
}