terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.5.1"
    }
  }
}

data "digitalocean_kubernetes_cluster" "primary" {
  name    = var.cluster_name
}

output "kubernetes" {
  value = {
    load_config_file = false
    host     = data.digitalocean_kubernetes_cluster.primary.endpoint
    token = data.digitalocean_kubernetes_cluster.primary.kube_config[0].token
    cluster_ca_certificate = base64decode(data.digitalocean_kubernetes_cluster.primary.kube_config[0].cluster_ca_certificate)
  }
  sensitive = true
}

provider "kubernetes" {
  host             = data.digitalocean_kubernetes_cluster.example.endpoint
  token            = data.digitalocean_kubernetes_cluster.example.kube_config[0].token
  cluster_ca_certificate = base64decode(
    data.digitalocean_kubernetes_cluster.example.kube_config[0].cluster_ca_certificate
  )
}