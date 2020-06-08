resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = "us-central1"

  # Need at least 2 nodes to ensure the loadbalancer can come up
  initial_node_count = 3

  node_locations = [
    "us-central1-c",
  ]

  master_auth {
    client_certificate_config {
      issue_client_certificate = true
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

variable cluster_name {}

resource "time_sleep" "wait_for_cluster" {
  depends_on = [google_container_cluster.primary]

  create_duration = "20s"
}

output "kubernetes" {
  depends_on = [time_sleep.wait_for_cluster]
  value = {
    load_config_file = false
    host     = google_container_cluster.primary.endpoint
    username = null
    password = null
    token = null
    cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
    client_certificate = base64decode(google_container_cluster.primary.master_auth.0.client_certificate)
    client_key = base64decode(google_container_cluster.primary.master_auth.0.client_key)
  }
  sensitive = true
}