terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.5.1"
    }
    time = {
      source = "hashicorp/time"
      version = "0.7.0"
    }
  }
}

data "digitalocean_kubernetes_versions" "example" {}

resource "digitalocean_kubernetes_cluster" "primary" {
  name    = var.cluster_name
  region  = "nyc1"
  # Default to the latest version slug
  version = data.digitalocean_kubernetes_versions.example.latest_version
  tags    = ["production"]

  node_pool {
    name       = "worker-pool"
    size       = "s-2vcpu-2gb"
    node_count = 3
  }

  lifecycle {
    # Don't  attempt to change the K8s version of existing clusters
    ignore_changes = [version]
  }
}

resource "time_sleep" "wait_for_cluster" {
  depends_on = [digitalocean_kubernetes_cluster.primary]

  create_duration = "20s"
}

output "kubernetes" {
  depends_on = [time_sleep.wait_for_cluster]
  value = {
    load_config_file = false
    host     = digitalocean_kubernetes_cluster.primary.endpoint
    token = digitalocean_kubernetes_cluster.primary.kube_config[0].token
    cluster_ca_certificate = base64decode(digitalocean_kubernetes_cluster.primary.kube_config[0].cluster_ca_certificate)
  }
  sensitive = true
}